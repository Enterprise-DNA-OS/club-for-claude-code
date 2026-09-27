# /register

Open events use a capacity limit. When full, registration creates a waiting-list place. A cancellation does not automatically promote the waiting list; review it before rebooking. Attendance can only be recorded once the event has started.

Run:

```bash
node scripts/club.mjs register <member> <event>
```

Use --json when combining results. On an ambiguous match, list the candidates and ask the operator to choose. Never select the first match. Nothing in this recipe sends, publishes or processes a payment.
