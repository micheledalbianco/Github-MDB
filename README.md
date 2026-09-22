# Asta Live — Fantacalcio

Gestione di un'**asta del fantacalcio dal vivo** (in presenza, 12 partecipanti,
chiamata per ruolo) con tre viste su tre dispositivi:

- **Banditore** — conduce l'asta: seleziona il ruolo in corso, chiama i
  giocatori dal listone, batte il countdown, registra i rilanci (regia +
  telefoni), assegna. Gestisce turni, budget e slot.
- **Giocatore** — dal telefono di ognuno: rilancia, vede la propria rosa, i
  crediti, il rilancio massimo e il listone (con i già presi spenti).
- **Tabellone** — sul maxischermo: giocatore all'asta + countdown, panoramica
  di tutte le 12 squadre in una schermata, e recap crediti tra un ruolo e
  l'altro.

Regole implementate: chiamata per ruolo con turno a rotazione (avanza dopo chi
prende il giocatore), niente overbudget (offerta massima calcolata tenendo
conto degli slot da riempire a 1 credito), spegnimento automatico di chi è
tagliato per budget o ha completato il ruolo, import listone Quotazioni
fantacalcio.it ed export rose (un CSV per squadra, formato `Squadra,Id,Prezzo`).

## Stato attuale

`public/index.html` è l'app completa (UI + logica di gioco), funzionante da
**un singolo dispositivo**. È già **deployabile su Netlify** come sito statico:
ideale per usarla dal PC del banditore con il **Tabellone proiettato**.

Il passo successivo è il **real-time multi-dispositivo** (i 12 telefoni): vedi
sotto.

## Costi

**Gratis** per questo uso:

- **Netlify** — hosting del sito statico: gratuito (il piano a pagamento non è
  necessario). Sottodominio `*.netlify.app` incluso.
- **Supabase** — sync real-time tra i dispositivi: tier gratuito, ampiamente
  sufficiente per 13 dispositivi in una serata.

Netlify **da solo non può** tenere aperta una connessione WebSocket, perciò il
real-time è affidato a Supabase.

## Deploy su Netlify

1. Collega questo repository a Netlify (New site → Import from Git) **oppure**
   trascina la cartella `public/` su app.netlify.com/drop.
2. Impostazioni build: **publish directory = `public`**, nessun comando di
   build (`netlify.toml` è già configurato).
3. Fatto: apri l'URL `*.netlify.app`.

### Uso

- Apri l'app e usa il selettore in alto per Banditore / Giocatore / Tabellone /
  Setup.
- **Setup**: importa il CSV Quotazioni, imposta persone ↔ squadre, esporta le
  rose a fine asta, oppure ripristina.
- Scenario dimostrativo: aggiungi `?demo=C` all'URL (o `P`, `D`, `A`) per
  partire a metà di quel ruolo con dati d'esempio. Senza parametro parte
  un'asta vera da zero (500 crediti, rose vuote).

## Real-time multi-dispositivo (Supabase) — prossimo step

Architettura: il **banditore è l'unico che scrive** lo stato canonico
dell'asta; giocatori e tabellone lo ricevono in tempo reale; i giocatori
inviano i rilanci come "azioni" che il banditore valida e applica.

Setup:

1. Crea un progetto gratuito su [supabase.com](https://supabase.com).
2. SQL Editor → esegui `supabase/schema.sql`.
3. Project Settings → API: copia **Project URL** e **anon public key**.
4. Inseriscile in `public/config.js` (verrà aggiunto in questo step), oppure
   come variabili in Netlify.

> La `anon key` è pubblica per definizione: la sicurezza dell'evento è data dal
> **codice stanza** riservato. Sufficiente per un'asta privata.

## Sviluppo locale

Essendo statico, basta un server statico qualsiasi:

```bash
cd public && python3 -m http.server 8080
# apri http://localhost:8080
```

---
🤖 Generato con [Claude Code](https://claude.com/claude-code)
