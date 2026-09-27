# /compliance

Read docs/compliance.md and profile. NZ evidence rules apply only to the NZ profile. Other checks compare records with stored obligations and the constitution. Report each missing reference and source, not a blanket compliance verdict.

Run:

```bash
node scripts/club.mjs compliance
```

Use --json when combining results. On an ambiguous match, list the candidates and ask the operator to choose. Never select the first match. Nothing in this recipe sends, publishes or processes a payment.
