# /complete-task

Read the relevant records, resolve the supplied names and record the requested outcome. Report what changed.

Run:

```bash
node scripts/club.mjs complete-task <task> <completion note>
```

Use --json when combining results. On an ambiguous match, list the candidates and ask the operator to choose. Never select the first match. Nothing in this recipe sends, publishes or processes a payment.
