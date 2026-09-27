# Move contacts from TidyHQ

1. In TidyHQ open Contacts. Configure the columns you need, including the contact identifier, name, email and any membership dates. Clear unwanted filters. Choose Actions, then Export All. TidyHQ emails the CSV to the address on your contact profile, which its help article says can take up to an hour.
2. Keep the original export. Inspect the headings and one family with a shared email. Do not merge on email. For membership details, use Memberships > Reports, choose fields under Options and export CSV separately.
3. Start a fresh database with `npm run migrate`, with DATA_DIR set to a new folder. Do not seed real databases.
4. Run `npm run club -- import tidyhq contacts.csv --dry-run --date-order=DMY`. Check the counts, then repeat without `--dry-run`. One file imports in one transaction. Repeating the same contact IDs updates those contacts.
5. Run members, renewals-due and consent-review. Compare counts, dates and a sample of original rows before adopting the new system.

## Mapping

| Export heading | Club field |
|---|---|
| Contact ID, ID, Contact Number | external_id, required stable key |
| Full Name or Name, otherwise First Name/Given Name and Last Name/Surname | name |
| Email or Email Address | email |
| Organisation or Organization | organisation |
| Membership Level or Membership | level; new levels have zero fee until reviewed |
| Membership Status or Status | active/current → active; expired/lapsed → lapsed; pending, suspended, archived retained; cancelled → contact |
| Subscription Start Date, Member Since, Joined On | joined_on |
| Subscription End Date, Expiry Date, Renewal Due | renewal_due |
| Every original column | source_data, preserved as text |

Headers are case-insensitive. ISO dates work directly. Slashed dates require explicit DMY or MDY. Duplicate IDs, duplicate headers, malformed CSV, unknown statuses and invalid dates reject the whole file. Blank status means contact, not an active member. Joining and marketing consent are never inferred from an export. Repeat imports preserve locally recorded consent and never delete contacts omitted from the file.

This importer takes one contact snapshot per ID and one current membership level. If the selected export lacks an ID, add the stable TidyHQ contact identifier first. Repeated membership rows for one contact need a mapping decision before import. Multiple memberships, family links, teams, groups, old payments, invoices, event attendance, mail, forms and attachments do not become operational records from this contact file. Additional columns remain in source_data when present. Enterprise DNA maps the separate histories during migration. Membership reports have selectable columns, not one guaranteed fixed format.

The included fixture is illustrative, not a captured vendor export. Review your actual headings during the test run. No connection to TidyHQ or its payment provider is made.

## Sources checked 27 September 2026

- [Contact export](https://support.tidyhq.com/en/articles/3429171-navigating-the-contacts-table-layout)
- [Membership reports](https://support.tidyhq.com/en/articles/506041-viewing-membership-detail-info-via-memberships-reports/)

## Export and recovery

`npm run club -- export club-backup.json` takes a consistent JSON snapshot of every domain record and the audit trail. It is a portable extract, not a one-command restore format. Also back up the PGlite directory with all processes stopped, or use a Postgres backup. Test recovery before using real records. Original evidence files are stored separately and need their own backups.
