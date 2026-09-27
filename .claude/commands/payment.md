# /payment

Record only a receipt already received. Verify the invoice, currency, remaining balance and unique bank reference. Partial receipts are supported; overpayments and duplicate references are refused. Nothing charges a card.

Run:

```bash
node scripts/club.mjs payment <invoice> <amount> <unique bank reference>
```

Use --json when combining results. On an ambiguous match, list the candidates and ask the operator to choose. Never select the first match. Nothing in this recipe sends, publishes or processes a payment.
