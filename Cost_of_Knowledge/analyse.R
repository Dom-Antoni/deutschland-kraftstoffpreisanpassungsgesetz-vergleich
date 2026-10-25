# Reproduce the post's own calculations; literature estimates are cited separately.
# From repository root: Rscript Cost_of_Knowledge/analyse.R [--refit]
if (.Platform$OS.type == "windows") {
  suppressWarnings(Sys.setlocale("LC_CTYPE", "English_United States.utf8"))
}
needed <- c("readxl", "readr", "dplyr", "tidyr")
if ("--refit" %in% commandArgs(TRUE)) needed <- c(needed, "Synth")
missing <- needed[!vapply(needed, requireNamespace, logical(1), quietly=TRUE)]
if (length(missing)) stop("Install required packages first: ", paste(missing, collapse=", "))
suppressPackageStartupMessages({library(dplyr); library(tidyr); library(readr)})
filearg <- grep("^--file=", commandArgs(FALSE), value=TRUE)
base <- if(length(filearg)) dirname(normalizePath(sub("^--file=", "", filearg[1]))) else
  if(file.exists("Cost_of_Knowledge/analyse.R")) normalizePath("Cost_of_Knowledge") else getwd()
repo <- dirname(base)
out <- file.path(base, "ergebnisse")
dir.create(out, showWarnings=FALSE)
rawfile <- file.path(base,"data/EU_Weekly_Oil_Bulletin_History_2026-10-22.xlsx")
fuels <- c("Super 95", "Diesel")
de_w <- read_csv(file.path(base,"data/de_laendergewichte.csv"),show_col_types=FALSE)
at_w <- read_csv(file.path(base,"data/at_laendergewichte.csv"),show_col_types=FALSE)
for(w in list(de_w,at_w)) {
  stopifnot(!anyDuplicated(w[c("iso2","kraftstoff")]),all(w$gewicht>=0),
            all(abs(tapply(w$gewicht,w$kraftstoff,sum)-1)<1e-4))
}
units <- sort(unique(c("AT","DE",at_w$iso2,de_w$iso2)))
extract <- function(sheet, taxword, value_name) {
  x <- readxl::read_excel(rawfile,sheet=sheet,col_names=FALSE,col_types="text",.name_repair="minimal")
  dates <- as.Date(suppressWarnings(as.numeric(x[[1]])),origin="1899-12-30")
  rows <- which(!is.na(dates) & dates>=as.Date("2005-01-01"))
  stopifnot(!anyDuplicated(dates[rows]))
  bind_rows(lapply(units,function(cc) bind_rows(lapply(c("euro95","diesel"),function(f) {
    j <- which(as.character(x[1,])==paste(cc,"price",taxword,"tax",f,sep="_"))
    stopifnot(length(j)==1L,x[[j]][3]=="1000 l")
    original <- suppressWarnings(as.numeric(x[[j]][rows]))
    stopifnot(!any(!is.na(x[[j]][rows]) & nzchar(x[[j]][rows]) & is.na(original)))
    tibble(datum=dates[rows],iso2=cc,kraftstoff=if(f=="euro95") "Super 95" else "Diesel",
           !!value_name:=ifelse(original>0,original/1000,NA_real_))
  }))))
}
weekly <- inner_join(extract("Prices wo taxes","wo","netto_eur_l"),
                     extract("Prices with taxes","with","brutto_eur_l"),
                     by=c("datum","iso2","kraftstoff"),relationship="one-to-one")
stopifnot(max(weekly$datum)==as.Date("2026-10-19"),
          !anyDuplicated(weekly[c("datum","iso2","kraftstoff")]))
monthly <- weekly |> mutate(monat=as.Date(format(datum,"%Y-%m-01"))) |>
  group_by(monat,iso2,kraftstoff) |>
  summarise(netto_eur_l=if(all(is.na(netto_eur_l))) NA_real_ else mean(netto_eur_l,na.rm=TRUE),
            meldungen=sum(!is.na(netto_eur_l)),.groups="drop")

# Source-vintage check for all training data and all Austrian comparison months.
original_monthly <- read_csv(file.path(repo,"preise_monatlich.csv"),show_col_types=FALSE) |>
  mutate(monat=as.Date(monat))
needed_months <- original_monthly |>
  filter((monat<=as.Date("2015-12-01") & iso2 %in% c("AT",at_w$iso2)) |
         (monat>=as.Date("2019-01-01") & monat<=as.Date("2026-03-01") &
            iso2 %in% c("DE",de_w$iso2)))
vintage_check <- needed_months |> select(monat,iso2,kraftstoff,alt=netto_eur_l) |>
  inner_join(monthly,by=c("monat","iso2","kraftstoff"),relationship="one-to-one")
stopifnot(nrow(vintage_check)==nrow(needed_months),
          all(is.na(vintage_check$alt)==is.na(vintage_check$netto_eur_l)),
          max(abs(vintage_check$alt-vintage_check$netto_eur_l),na.rm=TRUE)<1e-10)

# Optional full re-estimation using exactly the pre-intervention specification.
# The default uses archived full-precision weights to reproduce the published values.
if("--refit" %in% commandArgs(TRUE)) {
  refits <- list()
  for(country in c("DE","AT")) for(fuel in fuels) {
    frozen <- if(country=="DE") filter(de_w,kraftstoff==fuel) else filter(at_w,kraftstoff==fuel)
    donors <- frozen$iso2
    first <- as.Date(if(country=="DE") "2019-01-01" else "2005-01-01")
    last <- as.Date(if(country=="DE") "2026-03-01" else "2010-12-01")
    panel <- monthly |> filter(monat>=first,monat<=last,kraftstoff==fuel,
                               iso2 %in% c(country,donors)) |>
      select(monat,iso2,netto_eur_l) |> pivot_wider(names_from=iso2,values_from=netto_eur_l) |>
      arrange(monat)
    stopifnot(identical(panel$monat,seq(first,last,by="month")),!anyNA(panel))
    Y <- as.matrix(panel[,c(country,donors)])
    years <- unique(format(panel$monat,"%Y"))
    X <- do.call(rbind,lapply(years,function(year) colMeans(Y[format(panel$monat,"%Y")==year,,drop=FALSE])))
    fit <- Synth::synth(X1=X[,country,drop=FALSE],X0=X[,donors,drop=FALSE],
                       Z1=Y[,country,drop=FALSE],Z0=Y[,donors,drop=FALSE],
                       optimxmethod=c("Nelder-Mead","BFGS"),genoud=FALSE,verbose=FALSE)
    fresh <- as.numeric(fit$solution.w)
    stopifnot(all(fresh>=0),abs(sum(fresh)-1)<1e-4,
              max(abs(drop(Y[,donors,drop=FALSE] %*% (fresh-frozen$gewicht))))<0.0001)
    refits[[paste(country,fuel)]] <- frozen |>
      transmute(untersuchungsland=country,kraftstoff,iso2,archiviert=gewicht,neu=fresh)
  }
  write_csv(bind_rows(refits),file.path(out,"neu_schaetzung_gewichte.csv"))
}

# DE: three equally weighted Monday observations, not a full October average.
de_dates <- as.Date(c("2026-10-05","2026-10-12","2026-10-19"))
de_input <- weekly |> filter(datum %in% de_dates,iso2 %in% c("DE",de_w$iso2))
stopifnot(nrow(de_input)==72L,!anyNA(de_input$netto_eur_l))
de_contributions <- de_input |> filter(iso2!="DE") |>
  inner_join(de_w,by=c("iso2","kraftstoff"),relationship="many-to-one") |>
  mutate(beitrag_eur_l=netto_eur_l*gewicht) |> arrange(kraftstoff,datum,iso2)
de_synth <- de_contributions |> group_by(datum,kraftstoff) |>
  summarise(synthetisch_eur_l=sum(beitrag_eur_l),laender=n(),.groups="drop")
stopifnot(all(de_synth$laender==11L))
de_path <- de_input |> filter(iso2=="DE") |> select(datum,kraftstoff,netto_eur_l,brutto_eur_l) |>
  inner_join(de_synth,by=c("datum","kraftstoff"),relationship="one-to-one") |>
  mutate(differenz_cent_l=100*(netto_eur_l-synthetisch_eur_l),
         # Same German tax schedule as in the original October update.
         energiesteuer_eur_l=if_else(kraftstoff=="Super 95",0.5141,0.3300),
         sonstige_steuern_eur_l=if_else(kraftstoff=="Super 95",0.1482,0.1618),
         steuercheck_eur_l=netto_eur_l-(brutto_eur_l/1.19-energiesteuer_eur_l-sonstige_steuern_eur_l))
stopifnot(max(abs(de_path$steuercheck_eur_l))<1e-5)
de_summary <- de_path |> group_by(kraftstoff) |>
  summarise(beobachtungen=n(),von=min(datum),bis=max(datum),
            differenz_cent_l=mean(differenz_cent_l),.groups="drop")

# AT: sixty equally weighted calendar-month averages, January 2011–December 2015.
at_input <- monthly |> filter(monat>=as.Date("2011-01-01"),monat<=as.Date("2015-12-01"),
                              iso2 %in% c("AT",at_w$iso2))
stopifnot(nrow(at_input)==60L*24L*2L,!anyNA(at_input$netto_eur_l))
at_contributions <- at_input |> filter(iso2!="AT") |>
  inner_join(at_w,by=c("iso2","kraftstoff"),relationship="many-to-one") |>
  mutate(beitrag_eur_l=netto_eur_l*gewicht) |> arrange(kraftstoff,monat,iso2)
at_synth <- at_contributions |> group_by(monat,kraftstoff) |>
  summarise(synthetisch_eur_l=sum(beitrag_eur_l),laender=n(),.groups="drop")
stopifnot(all(at_synth$laender==23L))
at_path <- at_input |> filter(iso2=="AT") |> select(monat,kraftstoff,netto_eur_l,meldungen) |>
  inner_join(at_synth,by=c("monat","kraftstoff"),relationship="one-to-one") |>
  mutate(differenz_cent_l=100*(netto_eur_l-synthetisch_eur_l))
at_summary <- at_path |> group_by(kraftstoff) |>
  summarise(beobachtungen=n(),von=min(monat),bis=max(monat),
            differenz_cent_l=mean(differenz_cent_l),.groups="drop")
stopifnot(all(at_summary$beobachtungen==60L),all(de_summary$beobachtungen==3L))
own <- bind_rows(mutate(de_summary,reihe="DE_2026_eigene_Rechnung"),
                 mutate(at_summary,reihe="AT_2011_2015_eigene_Rechnung"))
expected <- tibble(reihe=c(rep("DE_2026_eigene_Rechnung",2),rep("AT_2011_2015_eigene_Rechnung",2)),
                   kraftstoff=rep(c("Super 95","Diesel"),2),erwartet=c(6.17,4.34,-3.03,-2.32))
check <- inner_join(own,expected,by=c("reihe","kraftstoff"),relationship="one-to-one")
stopifnot(nrow(check)==4L,all(abs(check$differenz_cent_l-check$erwartet)<0.005))

# External results: transcribed from the article's section 7.2, not re-estimated.
literature <- read_csv(file.path(base,"data/literatur_de_2013.csv"),show_col_types=FALSE) |>
  mutate(differenz_cent_l=100*effekt_eur_l)
write_csv(de_input,file.path(out,"de_quellpreise_3_wochen.csv"))
write_csv(de_contributions,file.path(out,"de_laenderbeitraege.csv"))
write_csv(de_path,file.path(out,"de_wochenvergleich.csv"))
write_csv(at_contributions,file.path(out,"at_laenderbeitraege.csv"))
write_csv(at_path,file.path(out,"at_monatsvergleich_2011_2015.csv"))
write_csv(own,file.path(out,"eigene_ergebnisse.csv"))
write_csv(literature,file.path(out,"literatur_ergebnisse.csv"))
writeLines(trimws(capture.output(sessionInfo()),which="right"),
           con=file.path(out,"R_sessionInfo.txt"))
print(own,width=Inf)
print(literature,width=Inf)
cat("Checks passed. Literature values are cited inputs, not a replication of the paper.\n")
