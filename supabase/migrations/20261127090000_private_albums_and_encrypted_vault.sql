-- Angel Memories: private photo albums and encrypted PIN vault.
-- Idempotent schema migration; row ownership is enforced by RLS.

create table if not exists public.albums (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null check (char_length(btrim(name)) between 1 and 80),
  created_at timestamptz not null default now()
);
create table if not exists public.album_media (
  album_id uuid not null references public.albums(id) on delete cascade,
  media_id uuid not null references public.media_items(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (album_id, media_id)
);
create index if not exists albums_user_created_idx on public.albums(user_id, created_at desc);
create index if not exists album_media_media_idx on public.album_media(media_id);
alter table public.albums enable row level security;
alter table public.album_media enable row level security;
drop policy if exists "Users manage their own albums" on public.albums;
create policy "Users manage their own albums" on public.albums for all to authenticated
  using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
drop policy if exists "Users view their own album media" on public.album_media;
create policy "Users view their own album media" on public.album_media for select to authenticated
  using (exists (select 1 from public.albums a where a.id = album_id and a.user_id = (select auth.uid())));
drop policy if exists "Users add their own media to albums" on public.album_media;
create policy "Users add their own media to albums" on public.album_media for insert to authenticated
  with check (
    exists (select 1 from public.albums a where a.id = album_id and a.user_id = (select auth.uid()))
    and exists (select 1 from public.media_items m where m.id = media_id and m.user_id = (select auth.uid()))
  );
drop policy if exists "Users remove media from their own albums" on public.album_media;
create policy "Users remove media from their own albums" on public.album_media for delete to authenticated
  using (exists (select 1 from public.albums a where a.id = album_id and a.user_id = (select auth.uid())));
grant select, insert, update, delete on public.albums to authenticated;
grant select, insert, delete on public.album_media to authenticated;

create table if not exists public.vault_items (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  object_path text not null unique,
  file_name text not null,
  content_type text not null default 'application/octet-stream',
  size_bytes bigint not null default 0 check (size_bytes >= 0),
  salt_b64 text not null,
  iv_b64 text not null,
  created_at timestamptz not null default now()
);
create index if not exists vault_items_user_created_idx on public.vault_items(user_id, created_at desc);
alter table public.vault_items enable row level security;
drop policy if exists "Users access only their own encrypted vault items" on public.vault_items;
create policy "Users access only their own encrypted vault items" on public.vault_items for all to authenticated
  using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
grant select, insert, update, delete on public.vault_items to authenticated;

-- Vault objects are encrypted in the browser before upload. Storage objects remain
-- inside the owner's existing private bucket folder: <auth.uid()>/vault/<uuid>.enc.
