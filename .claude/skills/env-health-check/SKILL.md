---
name: env-health-check
description: Check that the booking app under test is healthy before any test run (Smoke, Regression, Full, or an agent execution). Use before running test cases, after restarting the app, or when room pages hang or crash.
---

# Environment health check

Run this **before every test run**. A working home page doesn't mean the booking flow works (L-24). On 2026-11-23 the public demo served the home page while every room page loaded forever.

## Steps

1. Run the check script against the environment under test:
   ```bash
   bash .claude/skills/env-health-check/scripts/health_check.sh            # local copy (http://localhost:3003)
   bash .claude/skills/env-health-check/scripts/health_check.sh https://automationintesting.online   # public demo
   ```
2. Read the verdict on the last line:
   - **READY:** the entry criteria are met. Record the timestamp and the booking count in the run file, then start Smoke.
   - **NOT READY:** don't run the suite. Mark the planned cases **Blocked**, and record the time window and the failing endpoints. If the problem is a 5xx on `/api/room/{id}`, check the UI as well. An endless spinner with no message is a product finding (CAND-09), separate from the outage.
3. Check the **booking count** against what you expect:
   - A fresh local start has 3 seeded bookings.
   - Anything more means earlier runs left data. The suite's dates are fixed, so a re-run would collide with those bookings and give false Fails. Restart with `bash run_locally.sh` (without `-e`) to reset, then run this check again.
4. Write the result at the top of the run file:
   ```
   Health check <date time TZ> · <base URL> · rooms <n> · bookings <n> · READY / NOT READY (<failing endpoints>)
   ```

## What it checks

| Check | Pass when | Why |
|---|---|---|
| `GET /api/room` | 200 and at least 3 rooms | The home page room list and availability work |
| `GET /api/room/1`, `/2`, `/3` | 200 | Room pages load. This is what failed on the demo |
| `GET /api/report/room/1` | 200 | The room calendar loads |
| `GET /api/branding` | 200 | The page shell loads |
| Bookings across rooms 1–3 | Reported (not pass/fail) | Detects leftover data before a re-run |

## Rules
- Never start a run on NOT READY. Only the person running the tests can override that, and the override and its reason go in the run file.
- The script only reads. It never creates, changes or deletes data, and it needs no credentials.
- Record the environment, base URL and app version (commit) with every result. Findings can differ between the demo and the local build (BUG-03, CAND-10).
