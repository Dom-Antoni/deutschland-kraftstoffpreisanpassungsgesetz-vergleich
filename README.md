# Spritpreis-Vergleiche: Deutschland und Österreich

Die Datei `analyse.Rmd` berechnet synthetische Vergleichspreise für Deutschland und Österreich und erstellt acht Grafiken aus `preise_monatlich.csv`.

## Inhalt

Die Zahlen des LinkedIn-Posts zu „Cost of Knowledge“ sind im Unterordner
[Cost_of_Knowledge](Cost_of_Knowledge/README.md) aufgeschlüsselt: reproduzierbarer
R-Code, archivierte EU-Daten, Länderbeiträge, Oktober-Update 2026 und getrennte
Literaturquellen. Dort ist auch dokumentiert, warum die Zeiträume gewählt wurden.

- `analyse.Rmd`: R-Code für Gewichtsschätzung, Modelltest und Grafiken.
- `preise_monatlich.csv`: monatliche Nettopreise für Super 95 und Diesel.
- `QUELLE.txt`: Herkunft und Aufbereitung der Preise.
- `plots/`: acht durch den Code erzeugte PNG-Dateien.

## Ausführen

Benötigt wird R ab Version 4.1. Im Ordner dieses Dokuments in R ausführen:

```r
user_lib <- Sys.getenv("R_LIBS_USER")
if (!nzchar(user_lib)) user_lib <- file.path(path.expand("~"), "R", "library")
if (!dir.exists(user_lib)) dir.create(user_lib, recursive = TRUE)
.libPaths(c(user_lib, .libPaths()))
if (!requireNamespace("knitr", quietly = TRUE)) {
  install.packages("knitr", lib = user_lib, repos = "https://cloud.r-project.org")
}
knitr::knit("analyse.Rmd", output = "analyse_ausgefuehrt.md")
```

Alternativ kann man `analyse.Rmd` in RStudio öffnen und die R-Blöcke einzeln ausführen. Jeder Grafik-Block speichert eine PNG-Datei und zeigt dasselbe Plotobjekt direkt unter dem Block an. Der erste Block installiert fehlende Analysepakete automatisch in die persönliche R-Bibliothek. Dafür ist beim ersten Lauf ein Internetzugang erforderlich. `analyse_ausgefuehrt.md` und `chunk_figures/` sind temporäre Ausgaben des vollständigen Prüflaufs.

## Aussage der acht Grafiken

| Datei | Bildaussage |
| --- | --- |
| `DE_01` | Ländergewichte des synthetischen Deutschlands für Super 95 und Diesel. |
| `DE_02` | Beobachtete und synthetische Nettopreise Deutschlands im zeitlichen Modelltest. |
| `DE_03` | Monatliche Nettopreise Deutschlands und des synthetischen Vergleichs, 2025–2026. |
| `DE_04` | Vorzeichenbehaftete Nettopreisdifferenz zwischen Deutschland und synthetischem Vergleich, Juli–September 2026. |
| `AT_01` | Ländergewichte des synthetischen Österreichs für Super 95 und Diesel. |
| `AT_02` | Beobachtete und synthetische Nettopreise Österreichs im Testjahr 2010. |
| `AT_03` | Monatliche Nettopreise Österreichs und des synthetischen Vergleichs, 2008–2015. |
| `AT_04` | Vorzeichenbehaftete Nettopreisdifferenz zwischen Österreich und synthetischem Vergleich, 2011–2015. |

Die Gewichte werden bei jedem Lauf neu berechnet; die abgelegten Grafiken werden nicht eingelesen. Prüfungen im R-Code kontrollieren Datenumfang und zentrale Ergebnisse. Die Abstände zu den synthetischen Vergleichspreisen sind keine isolierten kausalen Wirkungen der 12-Uhr-Regeln.

Die acht Grafiken wurden mit der beigefügten CSV erneut erzeugt und geprüft. Grafische Details wie Schriften können je nach Betriebssystem abweichen.
