# T.A.R.A.L.L.O.
Trabiccolo Amministrazione Rottami e Assistenza, Legalmente-noto-come L'inventario Opportuno

Server in PHP e (My)SQL (anche se forse un NoSQL sarebbe stato più adatto) del programma che useremo per gestire l'inventario dei vecchi computer accatastati in laboratorio, nonché di quelli donati ad associazioni e scuole a cui facciamo assistenza.

## Database
La struttura è in `database.sql`. Dopo una serie di false partenze, la scrittura di una spec non particolarmente formale e di due diagrammi entity-relationship, siamo pervenuti a questo.

## Installazione

WIP

`composer install --no-dev -o` dovrebbe generare l'autoloader ottimizzato senza dipendenze di sviluppo (= PHPUnit).

### TODO
- [x] Foreign key
- [X] Qualcosa per rappresentare la struttura ad albero degli Item
	- [X] ...e gli Item rimossi (metterli nell'Item radice "cestino"? Rimuoverli dalla tabella Tree?)
- [X] Gestire proprietà duplicate con valori diversi (= non si mettono e basta)
- [x] Trovare una soluzione più degna per tenere traccia di che stanno facendo gli adesivi col numero di inventario e col seriale di Windows (è necessario tenerne traccia perché dobbiamo staccarli e restituirli prima di dare via i computer)
- [ ] Scrivere il codice.
