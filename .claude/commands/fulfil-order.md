# /fulfil-order

Read orders and products first. Fulfilment deducts stock once in the same transaction. Insufficient stock refuses the operation; fulfilled orders cannot be edited.

Run:

```bash
node scripts/club.mjs fulfil-order <order>
```

Use --json when combining results. On an ambiguous match, list the candidates and ask the operator to choose. Never select the first match. Nothing in this recipe sends, publishes or processes a payment.
