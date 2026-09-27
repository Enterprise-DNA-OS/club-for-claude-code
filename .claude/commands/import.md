# /import

Read docs/replace-tidyhq.md. Inspect headers and date order, then run the test import and compare counts before applying. Consent is never inferred. Duplicate contacts by ID reject the file. Extra columns are preserved.

Run:

```bash
node scripts/club.mjs import tidyhq <contacts.csv> --dry-run --date-order=DMY
```

Use --json when combining results. On an ambiguous match, list the candidates and ask the operator to choose. Never select the first match. Nothing in this recipe sends, publishes or processes a payment.
