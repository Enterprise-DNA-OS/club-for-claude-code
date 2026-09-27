# Club for Claude Code

Members, subs, team lists, volunteer duties and committee records in a database your club owns. MIT-licensed software for the club secretary, treasurer and volunteer coordinator. Works with Claude Code, Codex, OpenCode or Cursor.

| Do it yourself | We customise it | We run it for you |
|---|---|---|
| Free. Clone, run the demo and import contacts. | Your fields, club rules, TidyHQ history, web front end or different stack. | Installed, connected and operated through Omni by Enterprise DNA. Setup fee, then retainer. |
| [Quick start](#quick-start) | [Get your version built](https://enterprisedna.co/omni/book/?offer=replace-software&utm_campaign=tidyhq&utm_medium=customise) | [Book a call](https://enterprisedna.co/omni/book/?offer=replace-software&utm_campaign=tidyhq&utm_medium=managed) |

## The club's weekly work

Review renewals, chase unpaid subs, cover the club day roster, carry committee actions forward and prepare the treasurer's report. The fictional Harbour Community Sports Club has a partial payment, lapsed player, unassigned gate duty, missing AGM minutes and overdue committee actions. Demo dates move with the first seed; reseeding preserves changes.

## Quick start

Node 20 or later on Windows or Linux:

```bash
git clone https://github.com/Enterprise-DNA-OS/club-for-claude-code.git
cd club-for-claude-code
npm install
npm run demo
npm test
npm run view
npm run docs
```

PGlite stores the demo under .data/db without a server. Set DATABASE_URL for hosted Postgres. TLS certificate checks are enabled. Real imports belong in a fresh DATA_DIR after npm run migrate, without demo seeding. Open the folder in your agent and ask which club duties need cover. AGENTS.md and CLAUDE.md route to the same command recipes.

## Commands

58 executable commands and 59 agent recipes. [Arguments and calculations](docs/cli.md).

- /members
- /levels
- /renewals-due
- /attention
- /arrears
- /events
- /registrations
- /invoices
- /payments
- /donations
- /training-gaps
- /training
- /engagement
- /level-summary
- /cash-summary
- /donor-summary
- /officers
- /obligations
- /activity
- /audit
- /consent-review
- /renewal-risk
- /profile
- /teams
- /team-list
- /team-readiness
- /duty-roster
- /volunteer-gaps
- /volunteer-load
- /meetings
- /committee-actions
- /interests
- /expenses
- /treasurer-review
- /files
- /products
- /orders
- /member
- /event
- /compliance
- /weekly-review
- /add
- /set
- /renew
- /register
- /check-in
- /cancel-registration
- /payment
- /log
- /assign-duty
- /complete-task
- /fulfil-order
- /draft-agenda
- /draft-renewal
- /draft-invitation
- /import
- /export
- /customise
- /new-view

Human tables by default, --json for automation, partial IDs and case-insensitive names. Ambiguous names list candidates and exit 1. Mutations write an audit entry. Receipts record money already received; nothing sends or charges a card.

## Ten questions beyond a fixed dashboard

These queries work on the demo today and can be changed around your club. TidyHQ also supports reporting and exports; no claim is made that these questions are impossible in its product.

- Which players have unpaid subs or expired memberships? `team-readiness`
- Which duties still need a volunteer in the next fortnight? `volunteer-gaps`
- Who has the most assigned duties this month? `volunteer-load`
- Which committee actions are overdue or have no owner? `committee-actions`
- Which members are up for renewal but have stopped attending? `renewal-risk`
- How much remains unpaid after partial receipts? `arrears`
- Which held meetings lack minutes and whose consent is missing? `compliance`
- What is left from recorded receipts and gifts after expenses? `treasurer-review`
- Which events have people waiting for places? `events`
- Which members have gone quiet for more than sixty days? `attention`

## Your first hour: ten things to ask for

1. Put our club name, colours and logo on the paperwork.
2. Test an import of our TidyHQ contacts.
3. Record our real membership fees and season dates.
4. Show players with overdue subs after partial payments.
5. Assign the uncovered club day duty.
6. Draft the next committee agenda.
7. Record our constitution's notice period.
8. Add a field for our competition grade using a migration.
9. Show missing officer consent and eligibility evidence.
10. Build a read-only view of the secretary's Monday jobs.

## Paperwork and read-only views

Change brand.json once. npm run docs produces member statements, event rolls, renewal letters, governance notices, committee agendas and duty sheets under docs-out/. The fictional demo renders fourteen files across those six types. npm run view renders the club week and committee review under views/. All are local snapshots, not a public web application.

[Switch from TidyHQ](docs/replace-tidyhq.md) explains the one-command contact import, field aliases, test run, dates, repeat imports and separate mapping for memberships, family links and financial history. [Compliance checks](docs/compliance.md) cover NZ evidence gaps and recorded local deadlines. A green check is not a legal certificate.

[Why no front end](docs/why-no-front-end.md) explains mobile, offline, member self-service, online payment and hosted website scope. Enterprise DNA can add these to a custom version. This base needs restricted database access, host security and tested backups before real member data is used. Local PGlite supports one process at a time.

## Verification

Tests exercise every command on a temporary database, including repeat seed and import, transaction rollback, duplicate receipts, overpayments, event capacity, consent, stock fulfilment, drafts, exports and HTML. They run through PGlite's Postgres engine. Hosted Postgres and Windows execution were not exercised in this run.

MIT licence. Not affiliated with TidyHQ or Anthropic. Hosting and agent usage have separate costs. [Book 30 minutes with Sam](https://enterprisedna.co/omni/book/?offer=replace-software&utm_campaign=tidyhq&utm_medium=readme).
