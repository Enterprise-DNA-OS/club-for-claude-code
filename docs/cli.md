# CLI guide

Run node scripts/club.mjs <command> [arguments] [--json]. Human tables are the default. All matching uses case-insensitive names or partial UUIDs. Multiple matches print candidates to stderr and exit 1. Exact UUIDs remove ambiguity.

## Reads

- `members`
- `levels`
- `renewals-due`
- `attention`
- `arrears`
- `events`
- `registrations`
- `invoices`
- `payments`
- `donations`
- `training-gaps`
- `training`
- `engagement`
- `level-summary`
- `cash-summary`
- `donor-summary`
- `officers`
- `obligations`
- `activity`
- `audit`
- `consent-review`
- `renewal-risk`
- `profile`
- `teams`
- `team-list`
- `team-readiness`
- `duty-roster`
- `volunteer-gaps`
- `volunteer-load`
- `meetings`
- `committee-actions`
- `interests`
- `expenses`
- `treasurer-review`
- `files`
- `products`
- `orders`

## Record actions

- `member <member name or ID>`
- `event <event name or ID>`
- `add <record type> '{"name":"..."}'` Read docs/cli.md for writable record types and scripts/lib/fields.json for allowed fields. Names and ID prefixes work on related record fields. Preserve evidence references. Do not invent data.
- `set <record type> <name or ID> '{"field":"value"}'` Read the record before editing and use only allowed fields. Changing a record writes an audit entry. Invoice edits with receipts and fulfilled-order edits are blocked. Archive rather than delete.
- `renew <member> <YYYY-MM-DD>` This is a club policy: require joining consent, a level and settled or explicitly voided invoices. The new expiry must be in the future and later than the current expiry. Renewal changes the record; it does not bill a card or issue an invoice.
- `register <member> <event>` Open events use a capacity limit. When full, registration creates a waiting-list place. A cancellation does not automatically promote the waiting list; review it before rebooking. Attendance can only be recorded once the event has started.
- `check-in <registration>`
- `cancel-registration <registration>`
- `payment <invoice> <amount> <unique bank reference>` Record only a receipt already received. Verify the invoice, currency, remaining balance and unique bank reference. Partial receipts are supported; overpayments and duplicate references are refused. Nothing charges a card.
- `log <member> <note>`
- `assign-duty <duty> <member>`
- `complete-task <task> <completion note>`
- `fulfil-order <order>` Read orders and products first. Fulfilment deducts stock once in the same transaction. Insufficient stock refuses the operation; fulfilled orders cannot be edited.
- `draft-agenda <meeting>` Read meetings, committee-actions, interests and treasurer-review first. Write the agenda to drafts. Review the constitution notice period and recipient list. This does not issue a meeting notice.
- `draft-renewal <member>`
- `draft-invitation <member> <event>` Read the member and event first. This promotional draft requires recorded marketing consent. Never infer consent from imported contact details. Save to drafts only.
- `import tidyhq <contacts.csv> --dry-run --date-order=DMY` Read docs/replace-tidyhq.md. Inspect headers and date order, then run the test import and compare counts before applying. Consent is never inferred. Duplicate contacts by ID reject the file. Extra columns are preserved.
- `export <backup.json>`

The weekly-review combines renewals, duties and committee actions. compliance reports missing evidence. help lists all 58 executable commands. 59 agent recipes include customise and new-view.

## Writable records

Allowed fields live in scripts/lib/fields.json. Use add and set for levels, members, events, invoices, donations, training, officers, obligations, teams, team_members, duties, meetings, tasks, interests, expenses, files, products, orders and club_profile. Dates use YYYY-MM-DD. Money is stored in decimal currency units, never mixed across currencies.

Example: node scripts/club.mjs add teams '{"name":"Senior squad","season":"2027","coach_id":"Mei"}'. PowerShell users can place the JSON in a variable or invoke through their coding agent. Use related names in member_id, coach_id, event_id, team_id, meeting_id, officer_id and product_id.

Create club_profile once for a fresh unseeded database, with name and jurisdiction NZ, AU-VIC or AU-OTHER. A singleton constraint prevents conflicting profiles. Set actual obligations and source references for the club's jurisdiction.

## Calculations and boundaries

Arrears are non-void overdue invoices minus recorded receipts. Treasurer review combines those receipts, donations and recorded expenses by currency across all stored dates; it is not a statutory financial statement. No tax, bank feed or processor is included. Donations do not issue tax receipts.

Team readiness flags inactive or expired memberships and any unpaid invoice. It is not sporting eligibility, safeguarding or coaching clearance. Volunteer gaps show unassigned duties within fourteen days, including overdue ones. Training gaps compare the current calendar year's hours with club policy on the membership level. Last contact older than sixty days is quiet. Renewal queries include expired and upcoming dates within sixty days.

Events use one place per contact. To release a waiting-list registration for reconsideration, cancel it, then update its status only through a reviewed migration or supported extension; automatic promotion is not implemented. Recorded stock is physical on-hand stock, not reservations for open orders.

Exports include all domain records and audit, but not original evidence files. Generated documents and drafts contain personal records: protect them along with backups. Nothing sends, bills or publishes.

Tests use temporary PGlite and Node filesystem APIs. Hosted Postgres and Windows execution were not exercised in this run.
