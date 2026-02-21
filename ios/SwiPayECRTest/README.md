# SwiPay | ECR Test (iOS)

Erstellt von Martin Bitzer.

## Funktionsumfang
- Modernes SwiftUI-App-Layout für iPhone (iOS 17+).
- Name der App: **SwiPay | ECR Test**.
- Bis zu 5 Terminal-Profile speicherbar.
- Terminalsuche mit Nexgo-MAC-Präfix-Validierung (als vorbereitete Basis für produktive Discovery).
- Editierbare Terminaldaten: Name, Schnittstelle, IP, Port, MAC.
- Porttest-Menü für externe Systeme und lokales Terminal.
- Verifizierungsbutton für EP2-Testlauf über alle Schnittstellen:
  - JSON KIT
  - ZVT
  - OPI
  - Cloud KIT
  - REST API
- Optionale Fehlersimulationen:
  - absichtliche Fehler
  - absichtliche Ablehnungen
- Kommunikationslog inkl. Export per E-Mail (Mailto-Flow).

## Hinweise
- Die Quellen (Confluence für OUI/MAC-Liste und PDF „TCP IP List“) sind als interne Artefakte angenommen; Default-Werte in der App sind bewusst als Startkonfiguration gesetzt und sollten mit den finalen Infrastrukturwerten ersetzt werden.
- Für eine echte Netzwerkerkennung auf MAC-Ebene ist auf iOS in der Regel ein ergänzender Backend-/MDM-Ansatz nötig.

## Build
```bash
cd ios/SwiPayECRTest
swift build
```
