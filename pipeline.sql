-- 1. Esquema base
create schema if not exists proveedores;

-- 2. Tabla maestra
create table proveedores.proveedor (
    id                uuid primary key default gen_random_uuid(),
    cuit              varchar(13) unique not null,
    razon_social      text not null,
    rubro             text,
    direccion         jsonb,
    cuenta_bancaria   jsonb,
    estado            text check (estado in ('pendiente','aprobado','rechazado','suspendido')),
    created_at        timestamptz default now(),
    updated_at        timestamptz default now()
);

-- 3. Contactos
create table proveedores.contacto (
    id            uuid primary key default gen_random_uuid(),
    proveedor_id  uuid references proveedores.proveedor(id) on delete cascade,
    nombre        text not null,
    email         citext not null,
    telefono      text,
    rol           text
);

-- 4. Evaluaciones
create table proveedores.evaluacion (
    id             uuid primary key default gen_random_uuid(),
    proveedor_id   uuid references proveedores.proveedor(id) on delete cascade,
    score          int check (score between 0 and 100),
    criterios      jsonb,
    evaluador_id   uuid references auth.users(id),
    fecha          date default current_date
);

-- 5. Documentos
create table proveedores.documento (
    id             uuid primary key default gen_random_uuid(),
    proveedor_id   uuid references proveedores.proveedor(id) on delete cascade,
    tipo           text,
    url            text,
    checksum       text,
    uploaded_by    uuid references auth.users(id),
    uploaded_at    timestamptz default now()
);

-- 6. Índices
create index idx_proveedor_estado on proveedores.proveedor(estado);
create index idx_evaluacion_proveedor on proveedores.evaluacion(proveedor_id);
create index idx_documento_proveedor on proveedores.documento(proveedor_id);

-- 7. Row Level Security (RLS)
alter table proveedores.proveedor enable row level security;
create policy "Ver todos" on proveedores.proveedor for select using (true);
create policy "Crear si está autenticado" on proveedores.proveedor for insert with check (auth.role() = 'authenticated');