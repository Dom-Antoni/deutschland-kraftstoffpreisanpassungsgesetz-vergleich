# Politikcheck der Deutschland-Spenderländer

Stand: 18.10.2026. Gezielte Recherche in Regierungs-, Parlaments-, Steuerbehörden-
und Gesetzesquellen zu Kraftstoffmaßnahmen 2026, Schwerpunkt April bis Oktober
und das Preisfenster 15.09.–15.10. (letzter Preisstichtag 12.10.). Ergänzend ältere
Eingriffe, soweit sie für die Einschätzung der Kontrollländer wichtig sind.
Dies ist keine lückenlose Rechtsinventur oder Freigabe als interventionsfreier Pool.

Gewichte stammen unverändert aus `data/de_laendergewichte.csv`; sie sind Modellanteile,
keine Handels- oder Marktanteile. Steuerdaten aus der EU-Datei vom 15.10. sind
unter `data/spender_steuertermine_seit_april2026.csv` dokumentiert.
Deren Termine können erste Bulletin-Meldungen sein und von rechtlichen
Inkrafttretensdaten abweichen; NA bedeutet keinen bezifferten Eintrag, nicht Null.

| Land | Super 95 | Diesel | Belegter Befund | Bedeutung für die Analyse |
| --- | ---: | ---: | --- | --- |
| Schweden | 50,78 % | 17,75 % | Energiesteuersenkung 01.05.–30.09.2026; zusätzliche CO2-Steuersenkung 01.07.–30.11.2026. Zum 01.10. entfällt die erste Senkung. Außerdem Emissionsminderungspflicht seit Juli 2025 bei 10 %. [S1–S3] | Höchste Prüfpriorität bei Super: große Gewichtung und Steuerwechsel im Zielfenster. Die Emissionspflicht wirkt auch auf Produktions-/Mischkosten und wird durch Steuerabzug nicht entfernt. Sie liegt allerdings bereits im Trainingszeitraum. |
| Finnland | 30,62 % | <0,001 % | Erneuerbaren-Verpflichtung 2026 auf 19,5 % gegenüber 16,5 % 2025; Steuerentlastung für 2026/27 im Gesetzgebungsverfahren dokumentiert, geltende Tabellen bei Vero. Am 15.10.2026 neues Hilfspaket mit angekündigten Kraftstoffhilfen für Unternehmen und Fahrzeugsteuerentlastung. [S4–S6] | Hohe Prüfpriorität für Super. Die Quotenänderung ab Januar ist bereits teilweise im Training, kann aber zeitabhängige Kostenwirkungen haben. Das Paket vom 15.10. ist kein Beleg für eine bereits wirksame Maßnahme vor dem letzten Preisstichtag 12.10. |
| Niederlande | 16,35 % | 12,77 % | Ermäßigte Kraftstoff-Verbrauchsteuern gelten bis Ende 2026; frühere Regelung verlängert. Für September/Oktober hier kein zusätzlicher neuer allgemeiner Preisdeckel bestätigt. [S7] | Fortbestehender Eingriff; kein nachgewiesener neuer Bruch im Zielfenster aus dieser Maßnahme. Kein Beleg völliger Politikfreiheit. |
| Irland | 2,19 % | 17,07 % | Zusätzliche Verbrauchsteuersenkung im April; für September/Oktober geplante Rücknahmen ausgesetzt. Parlamentarische Antwort vom 29.09. bestätigt vollständige Verlängerung bis 31.10. [S8] | Bedeutend für Diesel. Laufende Entlastung und Weitergabeeffekte prüfen. Frühere Ankündigungen einer Oktober-Erhöhung beschreiben nicht den letztlich geltenden Stand. |
| Litauen | 0,013 % | 52,41 % | Parlament beschloss am 14.04. temporäre Senkung der festen Diesel-Verbrauchsteuer von 500 auf 450 EUR/1.000 L bis 15.06.; aktuelle reguläre Gesamtsteuer einschließlich CO2-Komponente 553,60 EUR/1.000 L. [S9] | Größtes Dieselgewicht: frühere Senkung und Rücknahme relevant für den Verlauf ab April. Aus der beendeten Senkung allein folgt kein neuer September/Oktober-Bruch. |
| Lettland | 0,017 % | <0,001 % | Diesel-Verbrauchsteuer April–September 396 EUR/1.000 L; Oktober–Dezember 330. Benzin ab Oktober 490 EUR/1.000 L. Steuerbehörde verweist auf Gesetz vom 26.03. samt Änderungen. [S10] | Aktuelle Änderung im Zielfenster, aber im bestehenden Modell wegen sehr kleiner Gewichte nahezu ohne direkten numerischen Einfluss. |
| Estland | 0,007 % | <0,001 % | Am 15.04. verabschiedetes Gesetz streicht die für 01.05.2026 geplanten Energie-Verbrauchsteuererhöhungen. [S11] | Geplante Erhöhung ist nicht als tatsächlich erfolgte Erhöhung zu behandeln. Sehr geringe Gewichte. |
| Spanien | <0,001 % | <0,001 % | Krisenbedingte Kraftstoffsteuerentlastungen, im September beschlossener weiterer Erlass erhält Dieselentlastung im Oktober und verstärkt Benzinentlastung. [S12] | Aktueller Eingriff, aber nahezu Nullgewicht. |
| Portugal | 0,005 % | <0,001 % | Fortlaufende temporäre Anpassungen der Kraftstoffsteuer ISP; Regierungsmitteilung im September bestätigt Fortführung der Entlastung. Auch EU-Historie zeigt Anpassungen im Zielfenster. [S13] | Politisch beeinflusste Preise, im Modell nahezu Nullgewicht. |
| Zypern | 0,006 % | <0,001 % | Ministerrat verlängerte am 10.09. die Kraftstoff-Verbrauchsteuerentlastung bis 30.11.; Regierung nennt 8,33 Cent/L für Benzin und Diesel. [S14] | Laufende Entlastung im Zielfenster, aber nahezu Nullgewicht. |
| Bulgarien | 0,010 % | <0,001 % | Regierungsprogramm für 20-Euro-Kompensation an einkommensschwache Autobesitzer; Zahlungen für April im Mai bestätigt. [S15] | Transfer statt allgemeiner Deckel für den gemeldeten Preis. Nachfrageeffekt möglich; sehr geringes Gewicht. Fortgeltung/Zahlungen im September/Oktober nicht eigens belegt. |

## Einordnung

Der Pool darf nicht als „Länder ohne Preisgesetze“ bezeichnet werden. Mehrere
gewichtete Länder haben selbst reagiert. Das widerlegt die Rechnung des
gewichteten Durchschnitts nicht, schränkt aber seine Eignung als unverzerrtes
Gegenbild eines Deutschlands ohne 12-Uhr-Regel ein.

Die EU-Reihe ohne indirekte Steuern entfernt die rechnerische direkte
Steuerkomponente. Sie entfernt nicht automatisch unvollständige oder verzögerte
Weitergabe, Nachfrageeffekte, Subventionen außerhalb der ausgewiesenen Steuern,
Vorratshaltung, Margenreaktionen oder Kosten von Erneuerbaren-Verpflichtungen.
Aus der Existenz eines Gesetzes allein lassen sich Größe und Richtung einer
Netto-Verzerrung nicht bestimmen. Insbesondere ist kein pauschaler zusätzlicher
Steuerabzug von den bereits steuerfreien Preisen gerechtfertigt.

Schweden ist wegen des Wechsels am 01.10. und des Supergewichts von 50,78 %
zuerst zu prüfen. Irland und Litauen haben gemeinsam rund 69,48 % des
Dieselgewichts; deren frühere Maßnahmen sind deshalb keineswegs nebensächlich.
Die finnische Quote liegt vor April und damit teilweise im Trainingsfenster;
das ist ein anderer Fall als eine neu nach April eingeführte Maßnahme.

Die bisherigen Resultate von +4,51 Cent/L Super und +3,47 Cent/L Diesel netto
sind deskriptive Abstände des bestehenden Modells. Dieser Check liefert keine
numerische Korrektur und keinen Beleg für einen kausalen deutschen Gesetzeseffekt.

Sinnvolle nächste Prüfung: Modelle mit vorab begründeten Ausschlüssen neu
ausschließlich vor April fitten und mit denselben zurückgehaltenen Zeitfenstern
validieren, insbesondere ohne Schweden sowie für Diesel ohne Litauen/Irland.
Gewichte nicht einfach entfernen und verbleibende Gewichte auf 100 % skalieren;
das wäre ein anderes, nicht erneut angepasstes Modell. Schlechtere Passung kann
auch bedeuten, dass keine ausreichend belastbare Vergleichsgruppe übrig bleibt.

## Primärquellen (abgerufen 18.10.2026)

- S1: Schwedische Regierung, erste befristete Senkung: https://www.regeringen.se/pressmeddelanden/2026/04/nu-sanks-skatten-pa-bensin-och-diesel/
- S2: Steuerbehörde, gültige zeitlich getrennte Sätze einschließlich Juli–September und Oktober–November: https://www.skatteverket.se/foretag/skatterochavdrag/punktskatter/energiskatter/skattpabransle.4.15532c7b1442f256bae5e56.html?trk=public_post_comment-text ; parlamentarischer Beschluss: https://www.riksdagen.se/sv/dokument-och-lagar/dokument/betankande/extra-andringsbudget-for-2026-stod-till-ukraina_hd01fiu47/
- S3: Schwedische Energiebehörde, Emissionsminderungspflicht seit Juli 2025: https://www.energimyndigheten.se/klimat/transporter/reduktionsplikt/
- S4: Finnische Regierung, bestätigtes Quotengesetz vom Dezember 2024: https://valtioneuvosto.fi/-//1410877/jakeluvelvoite-nousee-ensi-vuonna-maltillisesti-16-5-prosenttiin ; Gesetzestext: https://www.finlex.fi/fi/lainsaadanto/2007/446/muutoshistoria/20240841
- S5: Finnische Steuerbehörde, Kraftstoffsteuertabellen: https://www.vero.fi/en/businesses-and-corporations/taxes-and-charges/excise-taxation/nestemaiset-polttoaineet/Tax-rates-on-liquid-fuels/ ; parlamentarische Vorlage: https://www.eduskunta.fi/fi/asiat-ja-aanestykset/valtiopaivaasiat/asiakirjat/edktunnus/EDK-2025-AK-41800
- S6: Finnische Regierung, erst am 15.10. angekündigtes Paket: https://valtioneuvosto.fi/en/-/government-to-ease-motoring-costs-eur-60-million-in-relief-for-commuters-and-entrepreneurs
- S7: Niederländische Regierung, aktuelle Geltung bis Ende 2026: https://www.rijksoverheid.nl/themas/belastingen-uitkeringen-en-toeslagen/belasting-betalen/vraag-en-antwoord/belasting-betalen/accijns-betalen
- S8: Irisches Parlament, Antwort vom 29.09.2026: https://prelive.oireachtas.ie/en/debates/question/2026-09-29/328/
- S9: Litauisches Finanzministerium, beschlossene Senkung: https://finmin.lrv.lt/lt/naujienos/pritarta-finansu-ministerijos-siulymui-laikinai-sumazinti-akcizus-dyzeliniam-kurui-B6Lj/ ; aktuelle Sätze: https://finmin.lrv.lt/en/competence-areas/taxation/main-taxes/excise-duties/
- S10: Lettische Steuerbehörde, befristete Sätze: https://www.vid.gov.lv/lv/akcizes-nodokla-likmes
- S11: Estnisches Parlament, verabschiedete Streichung: https://www.riigikogu.ee/pressiteated/akkermann-aktsiisitousude-arajatmine-leevendab-energiahindade-tousu-moju/
- S12: Spanisches Gesetzblatt vom 30.09.2026: https://www.boe.es/boe/dias/2026/09/30/pdfs/BOE-A-2026-20265.pdf
- S13: Portugiesische Regierung, fortbestehende Maßnahmen: https://portugal.gov.pt/pt/gc25/comunicacao/noticias/governo-prolonga-medidas-para-proteger-familias-e-empresas-face-a-subida-dos-combustiveis ; Rechtsgrundlage der dynamischen Anpassung: https://files.diariodarepublica.pt/1s/2026/03/04602/0000300004.pdf
- S14: Zyprische Regierung, Verlängerung vom 10.09.2026: https://www.gov.cy/en/economy-and-finance/statement-by-the-minister-of-finance-of-the-republic-of-cyprus-regarding-the-extending-of-the-reduction-of-special-consumption-excise-duty-rates-on-fuel-until-30-november/
- S15: Bulgarische Regierung, Beschluss 229/2026: https://www.strategy.bg/bg/pris/legal-information/reseniia/169304 ; Sozialministerium, tatsächliche Auszahlung: https://www.mlsp.government.bg/232-000-dushi-shche-poluchat-ot-kompensatsiya-za-visokite-tseni-na-gorivata

Quellenkritik: Ältere estnische Steuerinformationen enthalten noch die später
gestrichene Mai-Erhöhung; alte irische Pläne noch die später ausgesetzten
September/Oktober-Erhöhungen. Schwedens erste Senkung bis September ist nicht
die gesamte Entlastung: Die zweite läuft bis November weiter. Diese zeitlich
neueren bzw. spezifischeren Belege wurden für die obige Einordnung verwendet.
