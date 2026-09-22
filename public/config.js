// ============================================================
// Configurazione Asta Live
// ------------------------------------------------------------
// Lascia i campi VUOTI per usare l'app in "modalità locale" (un solo
// dispositivo, come il prototipo).
//
// Per attivare il MULTIPLAYER (i 12 telefoni sincronizzati) incolla qui i
// due valori del tuo progetto Supabase:
//   Supabase → Project Settings → API
//     - Project URL      → SUPABASE_URL
//     - anon public key  → SUPABASE_ANON_KEY
// e assicurati di aver eseguito supabase/schema.sql.
// ============================================================
window.ASTA_CONFIG = {
  SUPABASE_URL: "",
  SUPABASE_ANON_KEY: "",
  ROOM: "ASTA"        // codice stanza: cambialo per fare aste diverse
};
