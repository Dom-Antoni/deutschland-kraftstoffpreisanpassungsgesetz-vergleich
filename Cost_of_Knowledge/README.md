# Cost of Knowledge: Herkunft der Zahlen im LinkedIn-Post

Dieser Ordner macht die sechs Preisangaben nachvollziehbar. Vier stammen aus
unseren eigenen synthetischen Vergleichen, zwei aus einer veröffentlichten Studie.
Alle beziehen sich auf Preise **ohne indirekte Steuern**, nicht auf Gewinnmargen.
Positives Vorzeichen bedeutet teurer als der Vergleich, negatives günstiger.

| Angabe | Super 95 | Diesel | Herkunft |
| --- | ---: | ---: | --- |
| Deutschland, Oktober 2026 bisher | +6,17 Cent/L | +4,34 Cent/L | Eigene Rechnung aus drei Montagspreisen: 05., 12. und 19.10.2026 |
| Österreich, Januar 2011–Dezember 2015 | −3,03 Cent/L | −2,32 Cent/L | Eigene Rechnung aus 60 Monatswerten; Diesel im Post auf −2,3 gerundet |
| Deutschland, Transparenzregel ab 2013, langfristig | ca. −2,2 Cent/L | ca. −3 Cent/L | Bernhardt, Breiderhoff und Dewenter (2025), Abschnitt 7.2 |

**Zahlenkorrektur im eingereichten Post:** Für die Literaturangabe zu Super ist
**2,2** statt **2,02 Cent/L** durch den Ergebnisteil belegt. Die Eingabe und die
belegte Zahl stehen nebeneinander in `data/post_zahlencheck.csv`.

## Schnell reproduzieren

Benötigt: R ab 4.1 sowie `readxl`, `readr`, `dplyr` (ab 1.1.1), `tidyr`.
Für eine komplette Neuschätzung außerdem `Synth` (ursprünglich Version 1.1.10).
Pakete werden vom Skript nicht automatisch installiert. Einmal bei Bedarf:

```r
install.packages(c("readxl", "readr", "dplyr", "tidyr", "Synth"))
```

Vom Repository-Stamm im Terminal:

```sh
Rscript Cost_of_Knowledge/analyse.R
```

Oder in R/RStudio vom Repository-Stamm:

```r
source("Cost_of_Knowledge/analyse.R", encoding="UTF-8")
```

Der Standardlauf liest die archivierte EU-Originaldatei und die ungerundeten
Ländergewichte, berechnet sämtliche Länderbeiträge und mittelt die daraus
entstehenden Preisabstände neu. Es ist kein Internetzugang erforderlich.

Auch die vier eigenen Gewichtsschätzungen können neu ausgeführt werden:

```sh
Rscript Cost_of_Knowledge/analyse.R --refit
```

Dabei werden ausschließlich die ursprünglichen Trainingszeiträume verwendet.
Die neu geschätzten Gewichte werden mit den archivierten verglichen; für
Unterschiede im Trainingspreisverlauf gilt eine Toleranz von 0,01 Cent/L.
Die Ergebnisrechnung verwendet weiterhin die archivierten Gewichte, damit sie
exakt denselben veröffentlichten Modellstand dokumentiert. Kleine numerische
Abweichungen bei Neuschätzungen können von Softwareversionen abhängen.

## Rechenweg

1. Aus dem EU-Tabellenblatt `Prices wo taxes` kommen die Spalten
   `<ISO2>_price_wo_tax_euro95` und `<ISO2>_price_wo_tax_diesel`.
2. Die Quelle ist in EUR je 1.000 Liter angegeben. Division durch 1.000 ergibt EUR/L.
   Nichtpositive und fehlende Werte gelten als fehlend und werden nicht aufgefüllt.
3. Für jeden Termin: `synthetischer Preis = Summe(Länderpreis × Ländergewicht)`.
4. `Abstand in Cent/L = 100 × (tatsächlicher Nettopreis − synthetischer Nettopreis)`.
5. Das arithmetische Mittel der Terminabstände liefert die Angabe im Post.

Die EU-Quelle ist bereits steuerbereinigt. Es gibt keinen zweiten Steuerabzug.
Die deutsche Brutto-Netto-Kontrolle nutzt für Oktober 19 % Umsatzsteuer,
Energiesteuer von 0,5141 EUR/L Super bzw. 0,3300 EUR/L Diesel sowie sonstige
indirekte Steuern von 0,1482 bzw. 0,1618 EUR/L laut EU-Steuertabellen.
Diese Werte dienen der Kontrolle, nicht einer erneuten Bereinigung.

### Deutschland: Warum diese drei Oktoberwerte?

Der Post verwendet den Datenstand vom **25.10.2026**, EU-Veröffentlichung
**22.10.2026**, mit jüngstem Preisstichtag **19.10.2026**. In diesem Stand liegen
für Oktober genau die Meldungen vom 5., 12. und 19. Oktober vor. Jeder Termin
zählt gleich. Das ist ein **vorläufiger Oktober-Durchschnitt**, kein vollständiger
Monat und kein Durchschnitt aller Tankvorgänge oder tatsächlich bezahlten Liter.

Die Gewichte wurden getrennt für Super und Diesel aus **Januar 2019 bis März
2026** geschätzt. Merkmale sind die Jahresmittel 2019–2025 und das Mittel des
ersten Quartals 2026; die Optimierung nutzt die Passung aller 87 Monatswerte.
Keine späteren deutschen Preise beeinflussen die Gewichtssuche. Diesel und
Super verwenden jeweils elf vorläufig ausgewählte Vergleichsländer.

Der Code nutzt dieselbe `Synth`-Spezifikation wie `../analyse.Rmd`:
nichtnegative Ländergewichte mit Summe eins, optimierte Merkmalsgewichte,
`Nelder-Mead` und `BFGS` sowie den Standard-Quadratiksolver des Pakets.
Die Monatsgewichte werden für das Update auf zeitgleiche Wochenpreise angewandt.
Das ist eine Fortschreibung des bestehenden Modells; die frühere monatliche
Validierung ist keine zusätzliche eigenständige Validierung dieses Wochenfensters.

Der eingefrorene aktuelle Datenstand enthält eine nachträgliche Korrektur der
irischen Preise vom 12.10.2026. Deshalb können Oktober-Zwischenstände aus der
vorherigen EU-Ausgabe geringfügig abweichen.

### Österreich: Warum 2011 bis 2015?

Die Gewichte stammen aus **Januar 2005 bis Dezember 2010**, getrennt nach
Kraftstoff, mit jährlichen Preismerkmalen und 72 monatlichen Trainingspreisen.
23 technisch vollständig verfügbare Vergleichsländer werden berücksichtigt;
das ist keine abgeschlossene Prüfung auf eigene politische Eingriffe.

Für jeden Kalendermonat wird zuerst der Mittelwert der vorhandenen EU-Meldungen
gebildet. Danach werden die **60 Monatsabstände Januar 2011–Dezember 2015**
gleich gewichtet. Monate mit fünf Meldungen erhalten damit nicht mehr Gewicht
als Monate mit vier Meldungen.

Das Fünfjahresfenster wurde praktisch gewählt, um über kurzfristige Bewegungen
hinauszuschauen. **2015 ist kein behaupteter historischer Wendepunkt**, kein
nachgewiesen störungsfreier Endpunkt und kein statistisch optimales Enddatum.
Die Rechnung zeigt den durchschnittlichen Abstand über diese gewählte Spanne.

Die Einmal-pro-Tag-Beschränkung existierte bereits seit Juli 2009. Januar 2011
markiert die Umstellung auf Mittag; die Transparenzpflicht begann im August
2011. Unser Fenster startet im Januar und enthält deshalb sieben Monate vor
der Transparenzpflicht. Es ist nicht als isolierte Schätzung ihres Effekts benannt.
Weitere Eingriffe umfassten die Mineralölsteuererhöhung Januar 2011 sowie
befristete Preisänderungsverbote 2012.

### Literatur: Woher kommen die deutschen Transparenzzahlen?

Bernhardt, L., Breiderhoff, X. und Dewenter, R. (2025):
*New Evidence on Price Effects of Transparency Regulations in European Fuel Markets*.
[DOI / Volltext](https://doi.org/10.1007/s10842-024-00438-1).

Abschnitt **7.2**, Tabelle **8**, langfristiges Modell **DE.III**: Der Text nennt
2,2 Cent/L Senkung für Super und ungefähr 3 Cent/L für Diesel; beide langfristigen
Ergebnisse sind dort auf dem 5-%-Niveau signifikant. DE.III nutzt September 2008
bis August 2018; Eingriffsdatum ist der Beginn des Probebetriebs am 31.08.2013.
Abschnitt 6 beschreibt die verwendeten steuerfreien Preise. Die Methode der
Studie ist **synthetic difference-in-differences**, nicht exakt unser `Synth`-Modell.

`data/literatur_de_2013.csv` erfasst die gerundeten Textangaben als externe
Quellenwerte. Das Skript rechnet lediglich EUR/L in Cent/L um. **Es repliziert
nicht die Originalstudie** und gibt die Textangaben nicht als exakte Koeffizienten aus.

## Welche Aussage wird damit belegt?

Belegt werden die angegebenen eigenen Modellabstände und die ausdrücklich
getrennt zitierten Literaturergebnisse. Die Zahlen allein messen keine
„knowledge costs“ und testen den im Post vorgeschlagenen Mechanismus nicht.
Die Behauptung, dass Transparenz allgemein Preise senkt und die Mittagsregel
allgemein Preise erhöht, ist damit nicht nachgewiesen. Insbesondere ist unser
Österreich-Abstand kein isolierter Transparenzeffekt. Die genannte Studie
findet für Österreich keine signifikante Senkung durch die Transparenzpflicht.
Diese Einordnung ändert keine der berechneten Zahlen.

Neue Eingriffe in den deutschen Spenderländern sind im beigefügten
[Politikcheck](SPENDERLAENDER_POLITIKCHECK_2026-10-18.md) dokumentiert.
Steuerfreie Reihen entfernen nicht automatisch Nachfrage- oder Weitergabeeffekte.

## Wo finde ich die einzelnen Zahlen?

| Datei unter `ergebnisse/` | Inhalt |
| --- | --- |
| `eigene_ergebnisse.csv` | Vier selbst berechnete Mittelwerte mit Zeitraum und Beobachtungszahl |
| `de_wochenvergleich.csv` | Die sechs deutschen Oktober-Beobachtungen inklusive Steuerkontrolle |
| `de_laenderbeitraege.csv` | Jeder deutsche Länderpreis, sein Gewicht und sein Beitrag je Termin |
| `at_monatsvergleich_2011_2015.csv` | Tatsächlicher und synthetischer Preis sowie Abstand für alle 120 Kraftstoff-Monate |
| `at_laenderbeitraege.csv` | Jeder österreichische Länderbeitrag je Monat und Kraftstoff |
| `literatur_ergebnisse.csv` | Die zwei separat zitierten und umgerechneten Literaturwerte |
| `post_zahlencheck.csv` | Abgleich der sechs Angaben aus dem eingereichten Post |
| `neu_schaetzung_gewichte.csv` | Vergleich archivierter und neu geschätzter Gewichte, nach `--refit` |
| `R_sessionInfo.txt` | Softwareversionen des ausgeführten Laufs |

Die Ausgangsgewichte stehen ungerundet in `data/`. Die Daten des bestehenden
Repositorys `../preise_monatlich.csv` werden gegen die Monatsaggregation der
archivierten Originaldatei geprüft. Fehlende Werte, Schlüssel, Beobachtungszahlen,
Länderzahlen, Gewichtssummen, Rundung und deutsche Steuern werden kontrolliert.

## Originalquelle und Datenstand

- [Europäische Kommission: Weekly Oil Bulletin](https://energy.ec.europa.eu/data-and-analysis/weekly-oil-bulletin_en)
- [Historien-Download](https://energy.ec.europa.eu/document/download/906e60ca-8b6a-44e7-8589-652854d2fd3f_en?filename=Weekly_Oil_Bulletin_Prices_History_maticni_4web.xlsx)
- Archiv: `data/EU_Weekly_Oil_Bulletin_History_2026-10-22.xlsx`, heruntergeladen am 25.10.2026.
- SHA-256: `7E019A27FE2DF6F324EC7A7C551B98142713FBEE32AA7A030906101FFC22B2FD`.

Der Online-Download wird fortgeschrieben; zur Reproduktion der Postzahlen ist
die beigefügte archivierte Datei maßgeblich. Das Skript lädt nicht unbemerkt neuere Daten.
