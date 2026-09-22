-- ============================================================
-- Schema Supabase per l'Asta Live (sync real-time dei dispositivi)
-- Esegui questo SQL una volta nel progetto Supabase:
--   Dashboard → SQL Editor → New query → incolla → Run
-- ============================================================

-- Una "stanza" = un'asta. Contiene lo stato completo come JSON.
-- L'operatore (banditore) è l'unico che scrive lo stato canonico.
create table if not exists public.rooms (
  id          text primary key,               -- codice stanza (es. "BNM26")
  state       jsonb not null default '{}'::jsonb,
  updated_at  timestamptz not null default now(),
  created_at  timestamptz not null default now()
);

-- Azioni inviate dai giocatori (rilanci) — l'operatore le legge e le applica.
create table if not exists public.actions (
  id          bigint generated always as identity primary key,
  room_id     text not null references public.rooms(id) on delete cascade,
  kind        text not null,                  -- es. 'raise', 'raise_to'
  payload     jsonb not null default '{}'::jsonb,
  created_at  timestamptz not null default now()
);

create index if not exists actions_room_idx on public.actions (room_id, id);

-- Realtime: notifica i client su ogni cambiamento
alter publication supabase_realtime add table public.rooms;
alter publication supabase_realtime add table public.actions;

-- RLS: accesso pubblico con la anon key (adatto a un evento privato con
-- codice stanza riservato). Si può restringere in seguito.
alter table public.rooms   enable row level security;
alter table public.actions enable row level security;

drop policy if exists rooms_all   on public.rooms;
drop policy if exists actions_all on public.actions;
create policy rooms_all   on public.rooms   for all using (true) with check (true);
create policy actions_all on public.actions for all using (true) with check (true);

-- Pulizia opzionale delle azioni vecchie (manuale):
--   delete from public.actions where created_at < now() - interval '1 day';
