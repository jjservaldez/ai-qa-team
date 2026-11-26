# Execution: Re-check TC-053, TC-038 · 2026-11-26 · executor agent
Health check `Health check · 2026-11-26 17:22:34 CST · http://localhost:3003` → `/api/room` 200 (rooms: 3), `/api/room/1..3` 200, `/api/report/room/1` 200, `/api/branding` 200, `bookings (rooms 1-3): 3 (fresh local start = 3 seeded)`, **VERDICT: READY** · Base URL http://localhost:3003 · Browser: Playwright MCP `@playwright/mcp@0.0.86` (from `.mcp.json`), viewport 1280×900
Environment: local copy of restful-booker-platform at commit `efe2deb8ce02db541adbf9d3a6604caf5fbdaae6` (from `git -C ~/Projects/restful-booker-platform rev-parse HEAD`, read at 17:22:34), started with `run_locally.sh`, running as a development build. Results apply only to this local copy.
Run window: 17:22:34–17:24:54 CST (2 min 20 s)

Source: `test-suite/execution-copy.csv`, cases TC-053 and TC-038. Host `https://automationintesting.online` was replaced with `http://localhost:3003`; nothing else changed.

Baseline before the run: 3 seeded bookings (room 1 2026-02-01..05, room 2 2026-02-02..04, room 3 2026-03-01..05). This equals the seeded count, so the run went ahead.

How the cases were run: through Playwright MCP. I used `browser_navigate` for the address-bar steps (TC-053 step 1, TC-038 step 1). I used `browser_click` or `browser_run_code_unsafe` with Playwright locator `click()` for every other step: real clicks, no values set through JavaScript, no href opened instead of a click. Neither case types anything. Read-only `evaluate`/`innerText` calls were used only to read values (field values, hrefs, Price Summary text, calendar geometry). The Next.js dev-tools badge ("1 Insight", bottom left) was visible in every screenshot. It is a collapsed badge, not an error overlay, so nothing was closed.

## TC-053: Check Out before Check In selected with the home page date picker
- **Result:** Fail
- **Actual:**
  - Step 1: `http://localhost:3003/` loaded at 17:22:48. Initial fields: Check In `26/11/2026`, Check Out `27/11/2026`.
  - Step 2 (Check In, picker only): I clicked the Check In field and the picker opened on `November 2026`. I clicked "Next Month" 4 times (`December 2026` → `January 2027` → `February 2027` → `March 2027`), then clicked the gridcell `Choose Monday, 15 March 2027` (`aria-disabled=false`). The picker closed. Check In = `15/03/2027`. Check Out stayed `27/11/2026`, already before Check In, and the app did not adjust it or show a message.
  - Step 3 (Check Out, picker only): I clicked the Check Out field and the picker opened on `November 2026`. I clicked "Next Month" 4 times to `March 2027`. The cell `Choose Saturday, 13 March 2027` was **not disabled** (`aria-disabled=false`, class `react-datepicker__day react-datepicker__day--013 react-datepicker__day--weekend`), and no earlier day was greyed out (see screenshot). I clicked it.
  - Step 4: Check In `15/03/2027`, Check Out **`13/03/2027`**. **No message** near the date fields: the `#booking` section text is only `Check Availability & Book Your Stay / Check In / Check Out / Check Availability`, and there are no `.alert` or `.invalid-feedback` elements. The oracle's first branch fails: the picker did not prevent the selection, and Check Out ended up `13/03/2027`.
  - Step 5: I clicked "Check Availability". It sent `GET /api/room?checkin=2027-03-15&checkout=2027-03-13` → 200. Still no message, and the fields were unchanged. "Our Rooms" lists `Single £100 per night`, `Double £150 per night`, `Suite £225 per night`, with "Book now" hrefs `/reservation/1?checkin=2027-03-15&checkout=2027-03-13`, `/reservation/2?…`, `/reservation/3?…` (all with the same reversed dates). The second branch (the TC-035 validation: a clear message near the date fields) also fails. This contradicts AC11.
  - Step 6: I clicked "Book now" on the Single card (href `/reservation/1?…`). URL `http://localhost:3003/reservation/1?checkin=2027-03-15&checkout=2027-03-13`, loaded 17:23:52, heading `Single Room`, no error page. Price Summary: **`£100 x -2 nights £-200`**, `Cleaning fee £25`, `Service fee £15`, **`Total £-160`**. The oracle requires "the Price Summary does not show negative nights or negative amounts".
- **Evidence:** home page loaded [TC-053-1.yml](evidence/2026-11-26/TC-053-1.yml) · after Check In selection [TC-053-2.yml](evidence/2026-11-26/TC-053-2.yml) · Check Out picker on March 2027 with 13 March selectable [TC-053-1.jpg](evidence/2026-11-26/TC-053-1.jpg), [TC-053-3.yml](evidence/2026-11-26/TC-053-3.yml) · fields 15/03/2027 and 13/03/2027 with no message [TC-053-2.jpg](evidence/2026-11-26/TC-053-2.jpg), [TC-053-4.yml](evidence/2026-11-26/TC-053-4.yml) · after "Check Availability" [TC-053-5.yml](evidence/2026-11-26/TC-053-5.yml) · room page with negative Price Summary [TC-053-3.jpg](evidence/2026-11-26/TC-053-3.jpg), [TC-053-6.yml](evidence/2026-11-26/TC-053-6.yml) · network and console [TC-053-network.txt](evidence/2026-11-26/TC-053-network.txt): all API calls 200; no `POST /api/booking` (the case does not submit); console 0 errors on both pages (1 warning: outdated JSX transform).
- **Bug / ticket:** BUG-02 (AC11). This confirms BUG-02 through the date-picker path, as the "to confirm on first run" note asks.
- **Time:** 17:22:48–17:24:00 (home loaded 17:22:48; room page loaded 17:23:52)
- **Method:** real clicks only, no typing. Picker clicks: Check In field → "Next Month" ×4 → `15 March 2027`; Check Out field → "Next Month" ×4 → `13 March 2027`. The "Next Month" clicks and the day clicks ran as Playwright `click()` inside `browser_run_code_unsafe`. For step 6, the Single card's "Book now" was found by the locator `a[href^="/reservation/1?"]`, because my card-scoped locator found 0 matches. It is the same link (the Single card's "Book now", room 1), and it was clicked with a real click.
- **Notes:** Outside the oracle: after the Check In selection (step 2), Check Out stayed `27/11/2026`, earlier than the new Check In, with no adjustment or warning. It is the same missing validation as BUG-02, so it is not filed as a new candidate.

## TC-038: "View Details" in Similar Rooms keeps the selected dates
- **Result:** Pass
- **Actual:**
  - Step 1: URL before the click: `http://localhost:3003/reservation/1?checkin=2027-04-05&checkout=2027-04-07` (loaded 17:24:12). Room 1 Price Summary total `£240`.
  - Step 2: "Similar Rooms You Might Like" shows two cards. Double card: `Double`, `2 Guests`, `£150/night`, link `View Details` with href **`/reservation/2?checkin=2027-04-05&checkout=2027-04-07`** (snapshot ref `f35e307`). Suite card: `View Details` with href `/reservation/3?checkin=2027-04-05&checkout=2027-04-07`.
  - Step 3: I clicked the Double card's "View Details" (ref `f35e307`) with a real click.
  - Step 4:
    - URL after the click: **`http://localhost:3003/reservation/2?checkin=2027-04-05&checkout=2027-04-07`**. It matches the oracle.
    - Room name: heading `Double Room`, breadcrumb `Home / Rooms / Double Room`.
    - Calendar: it opened on `November 2026`. I clicked "Next" 5 times (`December 2026`, `January 2027`, `February 2027`, `March 2027`, `April 2027`). A single `Selected` event bar is in the week row `04 05 06 07 08 09 10`. It starts at the 05 column (x=905, the same as cell `05`) and is 138 px wide = 3 columns (05, 06, 07; `flex-basis: 42.8571%`). It starts on 5 April and covers 5 and 6 April 2027. It also covers 7 April, which the oracle does not assert (PO-4).
    - Price Summary: `£150 x 2 nights £300`, `Cleaning fee £25`, `Service fee £15`, `Total £340`. It matches the oracle.
    - No today/tomorrow dates were shown, and nothing was booked.
- **Evidence:** room 1 page with the Double card's "View Details" link and its href [TC-038-2.yml](evidence/2026-11-26/TC-038-2.yml) (lines 223–232), [TC-038-2.jpg](evidence/2026-11-26/TC-038-2.jpg) · destination page right after the click [TC-038-3.yml](evidence/2026-11-26/TC-038-3.yml) · calendar on April 2027 with the Selected bar and the Price Summary [TC-038-3.jpg](evidence/2026-11-26/TC-038-3.jpg), [TC-038-4.yml](evidence/2026-11-26/TC-038-4.yml) · network and console [TC-038-network.txt](evidence/2026-11-26/TC-038-network.txt): the click triggered `GET /api/room/2`, `/api/branding`, `/api/report/room/2`, `/api/room`, all 200; no `POST /api/booking`; console 0 errors on both pages (1 warning: outdated JSX transform).
- **Bug / ticket:** BUG-03 not reproduced on this local copy (consistent with `bugs/README.md`: "Not reproduced on local. Verify on the demo").
- **Time:** 17:24:12–17:24:45 (room 1 loaded 17:24:12; room 2 loaded 17:24:25)
- **Method:** step 1 used `browser_navigate` (address bar, as written). Step 3 used a real `browser_click` on the snapshot ref of the Double card's link; Playwright resolved it as `getByRole('link', { name: 'View Details' }).first()`, which is the Double card's link (the first of the two, per the snapshot), and the URL after the click confirms room 2. The calendar "Next" clicks ran as Playwright `click()` in `browser_run_code_unsafe`.
- **Notes:** The earlier files TC-038-1.jpg and TC-038-1.yml were left untouched. This re-check's files start at number 2.

## Totals
Pass 1 (TC-038) · Fail 1 (TC-053) · Blocked 0 · Question 0

## Data check (17:24:54, read-only curl)
- `/api/report/room/1` → `2026-02-01..2026-02-05` only; `/api/report/room/2` → `2026-02-02..2026-02-04` only; `/api/report/room/3` → `2026-03-01..2026-03-05` only. These are the 3 seeded bookings, unchanged.
- No "Booking Confirmed" in this run, and no booking was stored. Neither case submits.
- `/api/room?checkin=2027-04-05&checkout=2027-04-07` → rooms `[1, 2, 3]` all available, so nothing was stored for TC-038's dates. `/api/room?checkin=2027-03-13&checkout=2027-03-15` returned the rooms list; nothing is stored in March 2027 (see the reports above).
- No double bookings. The health check after the run reported `bookings (rooms 1-3): 3`, `VERDICT: READY`.

## NEW-CANDIDATEs
None.

## Deviations
- TC-053 step 6: the Single card's "Book now" was found by its href prefix (`a[href^="/reservation/1?"]`), because my card-scoped locator matched nothing. It was still a real click on that link.
- Playwright MCP wrote its usual auto-generated snapshot and console logs to `.playwright-mcp/` (for example `page-2026-11-26T23-22-48-613Z.yml`). They were left in place; nothing was deleted or overwritten.
- No files were overwritten. TC-038-1.jpg and TC-038-1.yml from the earlier run are untouched.

---

## Triage (QA lead, 2026-11-26)
1. **TC-053 blocker accepted; the case is fixed.** After step 3, Check Out must be after Check In, whatever the picker does. Step 2 now has its own expected result, step 5 no longer says "If both dates were set", and the case links AC11 and AC2. Its related bug is now BUG-02, CAND-17.
2. **Leftover Check Out opened as CAND-17, linked to BUG-02:** after Check In is set to 15/03/2027, Check Out stays at 27/11/2026, before the new Check In, with no warning.
3. **TC-038 reworded:** only the URL, the "Selected" bar and the Price Summary count for the verdict. The calendar opening on another month with today highlighted is not a failure. "Booked" and the AC1 link are removed, because the case never submits.
4. **Minor points accepted:** TC-038's Pass applies to the local copy only and is not evidence against BUG-03; the empty root `alert` node is the Next.js route announcer, now noted in `executor.md`.
5. **New coverage gaps** go to `test-suite/BACKLOG.md`, not to the suite: "View Details" carries reversed dates to other rooms; the availability API accepts a reversed date range; Back and refresh on a room page with reversed dates.
