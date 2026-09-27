# /weekly-review

Run renewals-due, duty-roster and committee-actions separately, then write the Monday review: overdue subs and owner, uncovered duties and due date, overdue committee actions and owner. Finish with three concrete next actions. No messages are sent.

Run:

```bash
node scripts/club.mjs weekly-review
```

Use --json when combining results. On an ambiguous match, list the candidates and ask the operator to choose. Never select the first match. Nothing in this recipe sends, publishes or processes a payment.
