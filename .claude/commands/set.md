# /set

Read the record before editing and use only allowed fields. Changing a record writes an audit entry. Invoice edits with receipts and fulfilled-order edits are blocked. Archive rather than delete.

Run:

```bash
node scripts/club.mjs set <record type> <name or ID> '{"field":"value"}'
```

Use --json when combining results. On an ambiguous match, list the candidates and ask the operator to choose. Never select the first match. Nothing in this recipe sends, publishes or processes a payment.
