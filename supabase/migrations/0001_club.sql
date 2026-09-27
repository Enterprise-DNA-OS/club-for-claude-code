create function touch_updated_at() returns trigger language plpgsql as $$ begin NEW.updated_at=now(); return NEW; end $$;
create table levels (id uuid primary key default gen_random_uuid(), name text not null unique, annual_fee numeric(12,2) not null default 0 check(annual_fee>=0), currency text not null default 'NZD' check(currency ~ '^[A-Z]{3}$'), training_hours numeric not null default 0 check(training_hours>=0), created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create trigger levels_updated before update on levels for each row execute function touch_updated_at();
create table members (id uuid primary key default gen_random_uuid(), name text not null, email text, organisation text, external_id text unique, level_id uuid references levels, status text not null default 'pending' check(status in ('active','pending','lapsed','suspended','contact','archived')), joined_on date, renewal_due date, consent_on date, consent_ref text, marketing_consent boolean not null default false, last_contact_on date, source_data jsonb not null default '{}', created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create trigger members_updated before update on members for each row execute function touch_updated_at();
create table events (id uuid primary key default gen_random_uuid(), name text not null, starts_on date not null, capacity integer not null check(capacity>0), fee numeric(12,2) not null default 0 check(fee>=0), currency text not null default 'NZD' check(currency ~ '^[A-Z]{3}$'), status text not null default 'open' check(status in ('open','closed','cancelled')), venue text, created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create trigger events_updated before update on events for each row execute function touch_updated_at();
create table registrations (id uuid primary key default gen_random_uuid(), name text not null, member_id uuid not null references members, event_id uuid not null references events, status text not null default 'registered' check(status in ('registered','attended','cancelled','waitlisted')), unique(member_id,event_id), created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create trigger registrations_updated before update on registrations for each row execute function touch_updated_at();
create table invoices (id uuid primary key default gen_random_uuid(), name text not null unique, member_id uuid not null references members, amount numeric(12,2) not null check(amount>0), currency text not null default 'NZD' check(currency ~ '^[A-Z]{3}$'), due_on date not null, kind text not null default 'dues', void boolean not null default false, created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create trigger invoices_updated before update on invoices for each row execute function touch_updated_at();
create table payments (id uuid primary key default gen_random_uuid(), name text not null, invoice_id uuid not null references invoices, amount numeric(12,2) not null check(amount>0), paid_on date not null default current_date, reference text not null unique, created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create trigger payments_updated before update on payments for each row execute function touch_updated_at();
create table donations (id uuid primary key default gen_random_uuid(), name text not null, member_id uuid not null references members, amount numeric(12,2) not null check(amount>0), currency text not null default 'NZD' check(currency ~ '^[A-Z]{3}$'), received_on date not null default current_date, purpose text not null, reference text not null unique, created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create trigger donations_updated before update on donations for each row execute function touch_updated_at();
create table training (id uuid primary key default gen_random_uuid(), name text not null, member_id uuid not null references members, completed_on date not null, hours numeric not null check(hours>0), evidence_ref text not null, created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create trigger training_updated before update on training for each row execute function touch_updated_at();
create table officers (id uuid primary key default gen_random_uuid(), name text not null, member_id uuid references members, role text not null, appointed_on date not null, ends_on date, consent_ref text, eligibility_ref text, created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create trigger officers_updated before update on officers for each row execute function touch_updated_at();
create table obligations (id uuid primary key default gen_random_uuid(), name text not null, jurisdiction text not null, due_on date not null, source_url text not null, evidence_ref text, completed_on date, notice_days integer check(notice_days>=0), notice_sent_on date, created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create trigger obligations_updated before update on obligations for each row execute function touch_updated_at();
create table activity (id uuid primary key default gen_random_uuid(), name text not null, member_id uuid not null references members, happened_on date not null default current_date, note text not null, created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create trigger activity_updated before update on activity for each row execute function touch_updated_at();
create table audit (id uuid primary key default gen_random_uuid(), name text not null, record_id uuid, detail jsonb not null default '{}', created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create trigger audit_updated before update on audit for each row execute function touch_updated_at();

create view invoice_balances as select i.*,m.name as member, i.amount-coalesce(p.paid,0) as balance from invoices i join members m on m.id=i.member_id left join (select invoice_id,sum(amount) paid from payments group by invoice_id) p on p.invoice_id=i.id;
create view member_health as select m.id,m.name,m.status,l.name as level,m.renewal_due,m.last_contact_on,coalesce(b.unpaid,0) as unpaid_invoices,coalesce(c.hours,0) as training_hours,coalesce(l.training_hours,0) as training_target,coalesce(e.attendances,0) as attendances from members m left join levels l on l.id=m.level_id left join (select member_id,count(*) filter(where balance>0) unpaid from invoice_balances where not void group by member_id) b on b.member_id=m.id left join (select member_id,sum(hours) hours from training where completed_on>=date_trunc('year',current_date)::date and completed_on<=current_date group by member_id) c on c.member_id=m.id left join (select member_id,count(*) attendances from registrations r join events e on e.id=r.event_id where r.status='attended' and e.starts_on>=current_date-365 and e.starts_on<=current_date group by member_id) e on e.member_id=m.id;
create view event_summary as select e.id,e.name,e.starts_on,e.capacity,e.status,e.currency,count(r.id) filter(where r.status in ('registered','attended')) as booked,count(r.id) filter(where r.status='attended') as attended,count(r.id) filter(where r.status='waitlisted') as waiting from events e left join registrations r on r.event_id=e.id group by e.id;
create index members_renewal on members(renewal_due);
create index registrations_event on registrations(event_id);
create index invoices_member on invoices(member_id);

create table teams (id uuid primary key default gen_random_uuid(), name text not null unique, season text not null, coach_id uuid references members, created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create trigger teams_updated before update on teams for each row execute function touch_updated_at();

create table team_members (id uuid primary key default gen_random_uuid(), name text not null, team_id uuid not null references teams, member_id uuid not null references members, role text not null default 'player', unique(team_id,member_id), created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create trigger team_members_updated before update on team_members for each row execute function touch_updated_at();

create table duties (id uuid primary key default gen_random_uuid(), name text not null unique, event_id uuid references events, due_on date not null, member_id uuid references members, status text not null default 'open' check(status in ('open','assigned','done')), check(status='open' or member_id is not null), created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create trigger duties_updated before update on duties for each row execute function touch_updated_at();

create table meetings (id uuid primary key default gen_random_uuid(), name text not null unique, held_on date not null, kind text not null default 'committee' check(kind in ('committee','agm','general')), agenda text not null default '', minutes_ref text, notice_sent_on date, notice_days integer not null default 14 check(notice_days>=0), status text not null default 'planned' check(status in ('planned','held','cancelled')), created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create trigger meetings_updated before update on meetings for each row execute function touch_updated_at();

create table tasks (id uuid primary key default gen_random_uuid(), name text not null unique, meeting_id uuid references meetings, member_id uuid references members, due_on date not null, status text not null default 'open' check(status in ('open','done','cancelled')), note text not null default '', created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create trigger tasks_updated before update on tasks for each row execute function touch_updated_at();

create table interests (id uuid primary key default gen_random_uuid(), name text not null, officer_id uuid not null references officers, disclosed_on date not null, matter text not null, management text not null, created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create trigger interests_updated before update on interests for each row execute function touch_updated_at();

create table expenses (id uuid primary key default gen_random_uuid(), name text not null, amount numeric(12,2) not null check(amount>0), currency text not null default 'NZD' check(currency ~ '^[A-Z]{3}$'), paid_on date not null, category text not null, evidence_ref text not null, reference text not null unique, created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create trigger expenses_updated before update on expenses for each row execute function touch_updated_at();

create table files (id uuid primary key default gen_random_uuid(), name text not null, kind text not null, location text not null, review_on date, created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create trigger files_updated before update on files for each row execute function touch_updated_at();

create table products (id uuid primary key default gen_random_uuid(), name text not null unique, stock integer not null default 0 check(stock>=0), unit_price numeric(12,2) not null check(unit_price>=0), currency text not null default 'NZD' check(currency ~ '^[A-Z]{3}$'), created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create trigger products_updated before update on products for each row execute function touch_updated_at();

create table orders (id uuid primary key default gen_random_uuid(), name text not null unique, member_id uuid not null references members, product_id uuid not null references products, quantity integer not null check(quantity>0), due_on date not null, status text not null default 'open' check(status in ('open','fulfilled','cancelled')), created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create trigger orders_updated before update on orders for each row execute function touch_updated_at();

create view team_register as select tm.id,t.name as team,t.season,m.name as member,m.status,m.renewal_due,tm.role,h.unpaid_invoices from team_members tm join teams t on t.id=tm.team_id join members m on m.id=tm.member_id join member_health h on h.id=m.id;
create view duty_roster as select d.id,d.name,e.name as event,d.due_on,m.name as volunteer,d.status from duties d left join members m on m.id=d.member_id left join events e on e.id=d.event_id;
create view committee_actions as select t.id,t.name,mt.name as meeting,m.name as owner,t.due_on,t.status,t.note from tasks t left join meetings mt on mt.id=t.meeting_id left join members m on m.id=t.member_id;

create table club_profile (id uuid primary key default gen_random_uuid(), singleton boolean not null default true unique check(singleton), name text not null, jurisdiction text not null check(jurisdiction in ('NZ','AU-VIC','AU-OTHER')), created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create trigger club_profile_updated before update on club_profile for each row execute function touch_updated_at();
