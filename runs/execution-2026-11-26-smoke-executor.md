# Execution: Smoke · 2026-11-26 · executor agent
Health check `Health check · 2026-11-26 15:15:16 CST · http://localhost:3003` → all endpoints 200 (`/api/room` rooms: 3, `/api/room/1..3`, `/api/report/room/1`, `/api/branding`), `bookings (rooms 1-3): 3 (fresh local start = 3 seeded)`, **VERDICT: READY** · Base URL http://localhost:3003 · App commit not visible from the UI (bugs/README.md lists the local copy as restful-booker-platform `efe2deb`; footer shows "restful-booker-platform v2.2"); QA repo HEAD `77d33cc` · Browser: Playwright MCP `@playwright/mcp@0.0.86` (Chromium 158), viewport 1280×900
Run window: 15:15:40–15:21:05 CST (5 min 25 s)

Suite source: `test-suite/execution-copy.csv`, Suite = Smoke → 8 cases (TC-001, 003, 004, 006, 008, 019, 029, 043). Host `https://automationintesting.online` replaced with `http://localhost:3003`; nothing else changed.

Baseline before the run (`/api/report/room/{id}`): room 1 2026-02-01..05, room 2 2026-02-02..04, room 3 2026-03-01..05 (the 3 seeded bookings).

General method for all cases:
- Buttons and links: real clicks (Playwright `click`).
- Home-page date fields: real click → `ControlOrMeta+A` → typed character by character → `Escape`.
- Form fields: typed character by character (`pressSequentially`), including accents and apostrophe in TC-008.
- `browser_evaluate` was used **read-only** to read field values, alert `<li>` items, button disabled state and the calendar bar geometry. It never set a value.
- Route-announcer note: every page has an empty Next.js `alert` element (`[ref=…e24]`/`e242`/`e357`) outside the booking panel; it is not the red error box and is ignored below.

---

## TC-001: Book a Single room end to end with dates chosen on the home page
- **Result:** Question (CAND-10 / PO-4)
- **Actual:**
  - Step 4: after "Check Availability" for 14/12/2026–16/12/2026, "Our Rooms" lists heading "Single" with "Book now" → `/reservation/1?checkin=2026-12-14&checkout=2026-12-16` (Double and Suite also listed). **Matches.**
  - Step 5: URL `http://localhost:3003/reservation/1?checkin=2026-12-14&checkout=2026-12-16`. **Matches.**
  - Step 6: after one click on "Next", toolbar label "December 2026". One "Selected" event (`rbc-event rbc-event-allday`) in the week row 13–19; it starts at the 14th cell (left 905 px = cell "14") and has `flex-basis: 42.8571%` (3 of 7 cells, 138 px), so it covers **14, 15 and 16**. Expected: 14 and 15 only. **Differs.**
  - Step 7: Price Summary `£100 x 2 nights` `£200` · `Cleaning fee` `£25` · `Service fee` `£15` · `Total` `£240`. **Matches.**
  - Step 8: textboxes "Firstname", "Lastname", "Email", "Phone", buttons "Reserve Now" and "Cancel" appear. **Matches.**
  - Step 11: panel shows heading "Booking Confirmed", "Your booking has been confirmed for the following dates:", `2026-12-14 - 2026-12-16`, and "Return home". No red box, no error page. **Matches.**
  - Main checks (steps 4, 5, 7, 8, 11): Pass. Step 6 only differs.
- **Evidence:** [TC-001-1.png](evidence/2026-11-26/TC-001-1.png) (December calendar, bar across 14–16) · [TC-001-2.png](evidence/2026-11-26/TC-001-2.png) (Booking Confirmed panel) · `POST /api/booking` → **201 Created**, request `{"roomid":1,"firstname":"Maria","lastname":"Gonzalez","depositpaid":false,"bookingdates":{"checkin":"2026-12-14","checkout":"2026-12-16"},"email":"maria.gonzalez@example.com","phone":"+523312345678"}`, response `{"bookingdates":{"checkin":"2026-12-14","checkout":"2026-12-16"},"bookingid":4,"depositpaid":false,"firstname":"Maria","lastname":"Gonzalez","roomid":1}` · Console: 0 errors, 1 warning (outdated JSX transform, framework).
- **Bug / ticket:** CAND-10 (PO-4 pending). No AC says whether the check-out day is shaded, so Question, not Fail.
- **Time:** 15:15:46–15:18:10
- **Method:** Real clicks and typing as written. Step 4 clicked the Single card's "Book now" link (Playwright resolved it as `getByRole('link',{name:'Book now'}).nth(1)` because the hero "Book Now" matches first; the resulting URL confirms room 1). Calendar bar read from the DOM in addition to the screenshot.
- **Notes:** "Return home" is a **link** (`<a href="/">`), not a button as the oracle says. Role/wording only; verdict unaffected.

## TC-003: Price Summary is correct for a 3-night Suite stay
- **Result:** Pass
- **Actual:**
  - Home page after "Check Availability" 07/12/2026–10/12/2026: Single, Double, Suite listed; Suite "Book now" → `/reservation/3?checkin=2026-12-07&checkout=2026-12-10`.
  - URL after click: `http://localhost:3003/reservation/3?checkin=2026-12-07&checkout=2026-12-10`. **Matches.**
  - Price Summary: `£225 x 3 nights` `£675` · `Cleaning fee` `£25` · `Service fee` `£15` · `Total` `£715`. Night count 3. **Matches.**
- **Evidence:** page text from snapshot `page-2026-11-26T21-18-34-124Z.yml`. No submit (no network to record). Console: 0 errors.
- **Bug / ticket:** —
- **Time:** 15:18:18–15:18:39
- **Method:** Real clicks and typing as written.
- **Notes:** —

## TC-004: First click on "Reserve Now" shows the form and "Cancel" without booking
- **Result:** Pass
- **Actual:**
  - Precondition URL opened at 15:18:42 (`/reservation/1?checkin=2026-12-21&checkout=2026-12-23`); panel rendered within ~9 s (first snapshot caught the page mid-load; waited for "Price Summary").
  - Step 1: no textboxes in the panel; "Reserve Now" visible. **Matches.**
  - Step 3: textboxes "Firstname", "Lastname", "Email", "Phone" appear, all values `""`, none disabled/readonly; buttons "Reserve Now" and "Cancel". No "Booking Confirmed"; no `.alert` element. Price Summary `£100 x 2 nights` `£200` · `£25` · `£15` · `Total` `£240`. **Matches.**
- **Evidence:** snapshots `page-2026-11-26T21-18-51-317Z.yml` (before) and `page-2026-11-26T21-18-59-974Z.yml` (after); no request to `/api/booking` (resource-timing count 0). Console: 0 errors.
- **Bug / ticket:** —
- **Time:** 15:18:42–15:19:04
- **Method:** Opened precondition URL in the address bar (as the case says); one real click.
- **Notes:** —

## TC-006: All fields at their minimum valid length are accepted
- **Result:** Pass
- **Actual:**
  - Step 1: Price Summary `£100 x 1 nights` `£100` · `Cleaning fee` `£25` · `Service fee` `£15` · `Total` `£140`. **Matches** (values).
  - Step 5: "Booking Confirmed", "Your booking has been confirmed for the following dates:", `2027-01-11 - 2027-01-12`, "Return home". No red box. **Matches.**
- **Evidence:** `POST /api/booking` → **201 Created**, response `{"bookingdates":{"checkin":"2027-01-11","checkout":"2027-01-12"},"bookingid":5,"depositpaid":false,"firstname":"Ana","lastname":"Lee","roomid":1}` · Console: 0 errors.
- **Bug / ticket:** —
- **Time:** 15:19:08–15:19:24
- **Method:** Real clicks; test data typed character by character (Ana / Lee / a@b.co / 01234567890).
- **Notes:** Wording only: "£100 x 1 nights" (plural) vs oracle "1 night". Outside the oracle values; verdict kept.

## TC-008: Names with accents, apostrophe and hyphen are accepted
- **Result:** Pass
- **Actual:**
  - Step 1: Price Summary `£150 x 2 nights` `£300` · `Cleaning fee` `£25` · `Service fee` `£15` · `Total` `£340`. **Matches.**
  - Typed values read back before submit: firstname `José`, lastname `O'Brien-Núñez`, email `jose.obrien@example.com`, phone `+523312345678`.
  - Step 5: "Booking Confirmed", `2027-02-01 - 2027-02-03`, "Return home". No red box, no error page, no garbled characters on the page. **Matches.**
- **Evidence:** `POST /api/booking` → **201 Created**, request `{"roomid":2,"firstname":"José","lastname":"O'Brien-Núñez",…,"bookingdates":{"checkin":"2027-02-01","checkout":"2027-02-03"},"email":"jose.obrien@example.com","phone":"+523312345678"}`, response `{"bookingdates":{"checkin":"2027-02-01","checkout":"2027-02-03"},"bookingid":6,"depositpaid":false,"firstname":"José","lastname":"O'Brien-Núñez","roomid":2}` · Console: 0 errors.
- **Bug / ticket:** —
- **Time:** 15:19:28–15:19:43
- **Method:** Real clicks; names typed character by character with `pressSequentially` (accents, apostrophe, hyphen).
- **Notes:** Stored spelling in the admin view: **NOT VERIFIED** (no admin access by rule). The POST response echoes the name correctly encoded, which is the closest non-admin evidence.

## TC-019: Firstname with 2 characters is rejected
- **Result:** Fail
- **Actual:**
  - No "Booking Confirmed". **Matches.**
  - Red box (`alert alert-danger`) shows exactly one bullet: `size must be between 3 and 18`. One bullet, about Firstname length 3–18: **matches**. The bullet **does not name the field** ("Firstname"): **differs** (AC8: "Each message identifies the field it refers to").
  - Fields still shown and editable (values `Al`, `Gonzalez`, `maria.gonzalez@example.com`, `+523312345678`; none disabled/readonly); "Reserve Now" enabled; no error page. **Matches.**
  - URL unchanged `http://localhost:3003/reservation/1?checkin=2027-06-01&checkout=2027-06-03`. **Matches.**
  - Price Summary `£100 x 2 nights` `£200` · `£25` · `£15` · `Total` `£240`. **Matches.**
- **Evidence:** [TC-019-1.png](evidence/2026-11-26/TC-019-1.png) · `POST /api/booking` → **400 Bad Request**, body `{"errors":["size must be between 3 and 18"]}` · Console: `[ERROR] Failed to load resource: the server responded with a status of 400 (Bad Request) @ http://localhost:3003/api/booking`.
- **Bug / ticket:** BUG-05 (AC8; PO-6 confirmation pending)
- **Time:** 15:19:49–15:20:02
- **Method:** Real clicks; test data typed character by character.
- **Notes:** The only failing check is the field name in the message.

## TC-029: Submitting with all fields empty shows an error per field and creates no booking
- **Result:** Fail
- **Actual:**
  - Step 4: No "Booking Confirmed". **Matches.** Red box lists 7 bullets, in this order: `size must be between 11 and 21` · `Lastname should not be blank` · `Firstname should not be blank` · `must not be empty` · `size must be between 3 and 18` · `must not be empty` · `size must be between 3 and 30`. Only 2 of 7 name their field; `must not be empty` (×2) and the three `size must be…` messages do not. **No message names Email or Phone.** The oracle states that a message without a field name (for example "must not be empty") fails: **differs**.
  - Form still usable (4 empty fields, enabled; "Reserve Now" and "Cancel" enabled); no error page; Price Summary `£100 x 2 nights` `£200` · `£25` · `£15` · `Total` `£240`. **Matches.**
  - Step 7: after breadcrumb "Home" and "Check Availability" 01/07/2027–03/07/2027, "Our Rooms" lists Single (`/reservation/1?checkin=2027-07-01&checkout=2027-07-03`), Double and Suite; `GET /api/room?checkin=2027-07-01&checkout=2027-07-03` → 200. **Matches** (no booking created).
- **Evidence:** [TC-029-1.png](evidence/2026-11-26/TC-029-1.png) · `POST /api/booking` → **400 Bad Request**, body `{"errors":["size must be between 11 and 21","Lastname should not be blank","Firstname should not be blank","must not be empty","size must be between 3 and 18","must not be empty","size must be between 3 and 30"]}` · Console: `[ERROR] Failed to load resource: the server responded with a status of 400 (Bad Request) @ http://localhost:3003/api/booking`.
- **Bug / ticket:** BUG-05 (AC8; PO-6 confirmation pending)
- **Time:** 15:20:11–15:20:39
- **Method:** Opened step 1 URL in the address bar (as written); real clicks; breadcrumb "Home" clicked (scoped to `nav[aria-label="breadcrumb"]`); dates typed as in TC-001.
- **Notes:** —

## TC-043: "Return home" button after confirmation
- **Result:** Pass
- **Actual:**
  - Step 2: "Booking Confirmed", "Your booking has been confirmed for the following dates:", `2027-04-26 - 2027-04-28`. **Matches.**
  - Step 4: after clicking "Return home", URL `http://localhost:3003/`; page shows the navigation (Rooms, Booking, Amenities, Location, Contact, Admin), "Check Availability & Book Your Stay" with "Check Availability", and "Our Rooms" (Single, Double, Suite). No error. **Matches.**
- **Evidence:** [TC-043-1.png](evidence/2026-11-26/TC-043-1.png) (home page after Return home) · `POST /api/booking` → **201 Created**, response `{"bookingdates":{"checkin":"2027-04-26","checkout":"2027-04-28"},"bookingid":7,"depositpaid":false,"firstname":"Maria","lastname":"Gonzalez","roomid":1}` · Console: 0 errors (only React DevTools info and HMR log after navigation).
- **Bug / ticket:** —
- **Time:** 15:20:42–15:21:00
- **Method:** Opened step 1 URL in the address bar (as written); real clicks; test data typed character by character.
- **Notes:** "Return home" is a link, not a button (same as TC-001). Wording/role only.

---

## Totals
| Pass | Fail | Blocked | Question |
|---|---|---|---|
| 5 (TC-003, 004, 006, 008, 043) | 2 (TC-019, 029) | 0 | 1 (TC-001) |

8 cases executed.

## Data check (read-only API, 15:21:05)
- `/api/report/room/1`: seeded 2026-02-01..05, plus **2026-12-14..16** (TC-001), **2027-01-11..12** (TC-006), **2027-04-26..28** (TC-043).
- `/api/report/room/2`: seeded 2026-02-02..04, plus **2027-02-01..03** (TC-008).
- `/api/report/room/3`: seeded 2026-03-01..05 only.
- 4 new bookings (ids 4–7) = 4 "Booking Confirmed" seen. One each, no double bookings.
- Rejected cases stored nothing: `/api/room?checkin=2027-06-01&checkout=2027-06-03` → rooms [1, 2, 3] (TC-019); `2027-07-01..03` → [1, 2, 3] (TC-029). Non-submitting cases: `2026-12-07..10` → [1, 2, 3] (TC-003), `2026-12-21..23` → [1, 2, 3] (TC-004).
- Booked ranges correctly excluded: `2026-12-14..16` → [2, 3]; `2027-01-11..12` → [2, 3]; `2027-04-26..28` → [2, 3]; `2027-02-01..03` → [1, 3].
- **Result: consistent.** Note: the environment now holds 7 bookings; the next suite run needs a data reset.

## NEW-CANDIDATEs
- None. All differences map to existing tickets (CAND-10, BUG-05).

## Deviations
- TC-001 step 4: the Playwright locator for the Single card's "Book now" resolved as `.nth(1)` because the hero "Book Now" link also matches; it was a real click on the Single card link (URL confirms room 1).
- Read-only `browser_evaluate` calls (no values set) to read input values, alert bullets, button state and calendar bar geometry (TC-001, 004, 008, 019, 029).
- TC-004: first snapshot was taken mid-load; waited for "Price Summary" (≈9 s after page load, under the 30 s limit) before checking step 1.
- No other deviations: no JavaScript value-setting, no href opening instead of clicks, no admin access.

---

## Triage (QA lead, 2026-11-26)
1. **TC-001:** stays **Question (CAND-10 · PO-4)**. The expected result "and not on other days" goes beyond the ACs, so it was overridden. The case goes to rewording.
2. **TC-001 Re-check** (read-only, 2026-11-26 15:41:58 CST): `GET http://localhost:3003/api/report/room/1` → **200**, body `{"report":[{"end":"2026-02-05","start":"2026-02-01","title":"Unavailable"},{"end":"2026-12-16","start":"2026-12-14","title":"Unavailable"},{"end":"2027-01-12","start":"2027-01-11","title":"Unavailable"},{"end":"2027-04-28","start":"2027-04-26","title":"Unavailable"}]}`. Room 1 has one entry for this stay, 2026-12-14 to 2026-12-16, which matches the booking's check-in and check-out (booking id 4). No entry starts on 2026-12-16. So the booking covers the nights of 14 and 15 December only, and the night of 16 December is not booked. The calendar draws the check-out date as shaded. This is a display issue, consistent with CAND-10. No data was created, changed or deleted.
3. **Evidence gaps** (review comments on TC-001, 003, 004, 006, 043): accepted. Fixed in `executor.md` with a lean evidence policy.
4. **"1 nights"** (TC-006): opened as **CAND-16**.
5. **"Return home" is a link, not a button:** TC-001 and TC-043 go to rewording.
6. **Run header:** must state that the target is the local copy and how the app was started.
7. **Smoke has no AC10–AC12 coverage:** cases will be added.
8. **Fixed December 2026 dates:** moved to December 2027.
