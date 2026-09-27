# /renew

This is a club policy: require joining consent, a level and settled or explicitly voided invoices. The new expiry must be in the future and later than the current expiry. Renewal changes the record; it does not bill a card or issue an invoice.

Run:

```bash
node scripts/club.mjs renew <member> <YYYY-MM-DD>
```

Use --json when combining results. On an ambiguous match, list the candidates and ask the operator to choose. Never select the first match. Nothing in this recipe sends, publishes or processes a payment.
