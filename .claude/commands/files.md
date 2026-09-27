# /files

Read current records and present the result with dates, amounts and named owners. Empty results mean no matching records, not proof the club has no work.

Run:

```bash
node scripts/club.mjs files
```

Use --json when combining results. On an ambiguous match, list the candidates and ask the operator to choose. Never select the first match. Nothing in this recipe sends, publishes or processes a payment.
