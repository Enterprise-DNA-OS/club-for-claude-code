# Club for Claude Code: operating instructions

The operator is a club secretary, treasurer or volunteer coordinator. Ask for the club name, jurisdiction and constitution when configuring real records. The demo is fictional.

## Routing

Read current data first. Use node scripts/club.mjs help to see every command. Each recurring job has one recipe in .claude/commands, shared by all agents.

| Job | Commands |
|---|---|
| Monday review | /weekly-review, /renewals-due, /duty-roster, /committee-actions |
| Member and team records | /members, /member, /teams, /team-list, /team-readiness |
| Treasurer | /arrears, /invoices, /payment, /expenses, /treasurer-review |
| Events and volunteers | /events, /register, /check-in, /volunteer-gaps, /assign-duty |
| Committee and evidence | /meetings, /complete-task, /officers, /interests, /compliance |
| Local drafts | /draft-agenda, /draft-renewal, /draft-invitation |
| Bring records across | /import, /export |
| Change the club's rules | /customise, /new-view |

## Rules

- Use docs/cli.md for arguments and scripts/lib/fields.json for writable fields. Other read recipes mirror CLI names.
- Never send email, publish a document or process a payment. Drafts stay in drafts/.
- Never invent a record, consent or evidence. On ambiguity show candidates and ask.
- Archive rather than delete. Do not erase financial or committee history.
- Use parameterised queries and migrations. Never rewrite an applied migration.
- Follow docs/compliance.md. A record check is not a compliance certificate.
- Personal data, especially children's records, stays protected with restricted access and backups.
- Run npm test after domain changes. Read-only HTML is generated with npm run view or npm run docs, using brand.json.

The database adapter is scripts/lib/db.mjs, choosing DATABASE_URL or local PGlite. The schema is supabase/migrations and the domain logic is scripts/lib/domain.mjs. No agent-specific implementation exists.

Built and operated through [Omni by Enterprise DNA](https://enterprisedna.co/omni/book/?offer=replace-software&utm_campaign=tidyhq&utm_medium=instructions).
