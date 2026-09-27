# /add

Read docs/cli.md for writable record types and scripts/lib/fields.json for allowed fields. Names and ID prefixes work on related record fields. Preserve evidence references. Do not invent data.

Run:

```bash
node scripts/club.mjs add <record type> '{"name":"..."}'
```

Use --json when combining results. On an ambiguous match, list the candidates and ask the operator to choose. Never select the first match. Nothing in this recipe sends, publishes or processes a payment.
