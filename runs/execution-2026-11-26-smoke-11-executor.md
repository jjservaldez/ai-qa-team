# Execution: Smoke (11 cases) · 2026-11-26 · executor agent
Health check `Health check · 2026-11-26 16:30:25 CST · http://localhost:3003` → `/api/room` 200 (rooms: 3), `/api/room/1..3` 200, `/api/report/room/1` 200, `/api/branding` 200, `bookings (rooms 1-3): 3 (fresh local start = 3 seeded)`, **VERDICT: READY** · Base URL http://localhost:3003 · Browser: Playwright MCP `@playwright/mcp@0.0.86` (Chrome/158.0.0.0 user agent), viewport 1280×900
Environment: local copy of restful-booker-platform at commit `efe2deb` (taken from `bugs/README.md`; the task did not give a commit, and the commit is not visible from the UI, whose footer says "restful-booker-platform v2.2"), started with `run_locally.sh`. Results apply only to this local copy. QA repo HEAD `ae522ea`.
Run window: 16:30:25–16:35:51 CST (5 min 26 s)

Suite source: `test-suite/execution-copy.csv`, Suite = Smoke → 11 cases (TC-001, 003, 004, 006, 008, 019, 029, 031, 035, 038, 043). They match the list in the task. Host `https://automationintesting.online` was replaced with `http://localhost:3003`; nothing else changed.

Baseline before the run: 3 seeded bookings (room 1 2026-02-01..05, room 2 2026-02-02..04, room 3 2026-03-01..05).

How every case was run:
- Steps were driven through Playwright MCP. I used `browser_navigate` for the address-bar steps and `browser_run_code_unsafe` for the other steps, which runs Playwright locator actions: `click()` for clicks and `pressSequentially()` for typing, character by character. No input value was set through JavaScript, and no href was opened in place of a click.
- Home-page date fields: real click → `ControlOrMeta+A` → typed character by character (`dd/mm/yyyy`) → `Escape` to close the picker.
- Read-only JavaScript (`innerText`, `inputValue`, `evaluate`) was used to read panel text, alert `<li>` items, field values and enabled state, and to work out which day cells the calendar "Selected" bar covers. It never changed the page, except the one viewport scroll noted under TC-029.
- On every submit, a `page.on('response')` listener captured the `POST /api/booking` request body and the response status and body. Those values are quoted below.
- Snapshots are saved as `.yml` text files. Screenshots are viewport-only JPEGs. No video, no traces.
- Note: the `.png` files in `runs/evidence/2026-11-26/` (TC-001-1.png, TC-001-2.png, TC-019-1.png, TC-029-1.png, TC-043-1.png) come from the earlier 15:15 run (`execution-2026-11-26-smoke-executor.md`), not from this run. This run's files are the `.jpg` and `.yml` files listed under each case.

---

## TC-001: Book a Single room end to end with dates chosen on the home page
- **Result:** Pass
- **Actual:**
  - Step 2: date fields read `14/12/2027` and `16/12/2027`. The home page then called `GET /api/room?checkin=2027-12-14&checkout=2027-12-16` → 200.
  - Step 4: "Our Rooms" lists `Single`, `Double`, `Suite`. The Single "Book now" href is `/reservation/1?checkin=2027-12-14&checkout=2027-12-16`.
  - Step 5: URL `http://localhost:3003/reservation/1?checkin=2027-12-14&checkout=2027-12-16`. It matches, with the host replaced.
  - Step 6: 13 clicks on "Next" (from November 2026) → label `December 2027`. One "Selected" bar starts on 14 December and covers day cells `14`, `15`, `16`. 14 and 15 are covered as required; 16 is not asserted (PO-4).
  - Step 7: `£100 x 2 nights £200`, `Cleaning fee £25`, `Service fee £15`, `Total £240`.
  - Step 8: the form shows empty fields `firstname`, `lastname`, `email`, `phone` (placeholders Firstname/Lastname/Email/Phone), and the buttons `Reserve Now` and `Cancel`.
  - Step 11: the panel text is `Booking Confirmed` / `Your booking has been confirmed for the following dates:` / `2027-12-14 - 2027-12-16` / `Return home`. No `.alert-danger` is shown and no error page.
- **Evidence:** home after Check Availability [TC-001-1.yml](evidence/2026-11-26/TC-001-1.yml) · calendar Dec 2027 and Price Summary [TC-001-1.jpg](evidence/2026-11-26/TC-001-1.jpg), [TC-001-2.yml](evidence/2026-11-26/TC-001-2.yml) · form [TC-001-3.yml](evidence/2026-11-26/TC-001-3.yml) · confirmation [TC-001-4.yml](evidence/2026-11-26/TC-001-4.yml)
  - Request: `{"roomid":1,"firstname":"Maria","lastname":"Gonzalez","depositpaid":false,"bookingdates":{"checkin":"2027-12-14","checkout":"2027-12-16"},"email":"maria.gonzalez@example.com","phone":"+523312345678"}`
  - Response: **201** `{"bookingdates":{"checkin":"2027-12-14","checkout":"2027-12-16"},"bookingid":4,"depositpaid":false,"firstname":"Maria","lastname":"Gonzalez","roomid":1}`
  - Console: 0 errors. 1 warning (React "outdated JSX transform"), which appears on every page.
- **Bug / ticket:** none. CAND-10 was observed (see Notes).
- **Time:** 16:31:03–16:32:00 (room page loaded 16:31:12)
- **Method:** real clicks and typing as written. Step 4 clicked the Single card's link with `getByRole('link',{name:'Book now',exact:true}).first()`. The exact match excludes the hero "Book Now"; the resulting URL confirms room 1.
- **Notes:** outside the oracle, the bar also shades the check-out day, 16 December (CAND-10 / PO-4). The oracle doesn't assert this, so the verdict is unchanged.

## TC-003: Price Summary is correct for a 3-night Suite stay
- **Result:** Pass
- **Actual:** dates `07/12/2027` → `10/12/2027`. `GET /api/room?checkin=2027-12-07&checkout=2027-12-10` → 200, and Single, Double and Suite are listed. URL after clicking the Suite card's "Book now": `http://localhost:3003/reservation/3?checkin=2027-12-07&checkout=2027-12-10`. Price Summary: `£225 x 3 nights £675`, `Cleaning fee £25`, `Service fee £15`, `Total £715`. The night count is exactly 3.
- **Evidence:** [TC-003-1.yml](evidence/2026-11-26/TC-003-1.yml) · no submit, so no POST · console 0 errors
- **Bug / ticket:** none
- **Time:** 16:32:09–16:32:15 (room page loaded 16:32:11)
- **Method:** real clicks and typing as written. Suite "Book now" clicked inside the card whose heading is "Suite".
- **Notes:** —

## TC-004: First click on "Reserve Now" shows the form and "Cancel" without booking
- **Result:** Pass
- **Actual:**
  - Step 1: 0 named input fields in the panel. "Reserve Now" is visible.
  - Step 3: after one click there are 4 empty, visible fields (`firstname`, `lastname`, `email`, `phone`). "Reserve Now" and "Cancel" are both visible. "Booking Confirmed" count is 0, and there is no `.alert-danger`. Price Summary: `£100 x 2 nights £200`, `£25`, `£15`, `Total £240`. No `POST /api/booking` was sent (count 0).
- **Evidence:** before [TC-004-1.yml](evidence/2026-11-26/TC-004-1.yml) · after [TC-004-2.yml](evidence/2026-11-26/TC-004-2.yml) · console 0 errors
- **Bug / ticket:** none
- **Time:** 16:32:16–16:32:30 (page loaded 16:32:16)
- **Method:** precondition URL opened in the address bar, as the case says. One real click.
- **Notes:** —

## TC-006: All fields at their minimum valid length are accepted
- **Result:** Pass
- **Actual:**
  - Step 1: `£100 x 1 nights £100`, `Cleaning fee £25`, `Service fee £15`, `Total £140`. The amounts match.
  - Step 5: `Booking Confirmed` / `Your booking has been confirmed for the following dates:` / `2027-01-11 - 2027-01-12` / `Return home`. No red box.
- **Evidence:** [TC-006-1.yml](evidence/2026-11-26/TC-006-1.yml) · [TC-006-2.yml](evidence/2026-11-26/TC-006-2.yml)
  - Request: `{"roomid":1,"firstname":"Ana","lastname":"Lee","depositpaid":false,"bookingdates":{"checkin":"2027-01-11","checkout":"2027-01-12"},"email":"a@b.co","phone":"01234567890"}`
  - Response: **201** `{"bookingdates":{"checkin":"2027-01-11","checkout":"2027-01-12"},"bookingid":5,"depositpaid":false,"firstname":"Ana","lastname":"Lee","roomid":1}`
  - Console: 0 errors
- **Bug / ticket:** CAND-16 (wording only)
- **Time:** 16:32:35–16:32:45
- **Method:** URL opened in the address bar. Real clicks. Test data typed character by character.
- **Notes:** this is a wording difference only. The page says "1 nights" where the oracle says "1 night", which is CAND-16. The amounts are correct, so the verdict is unchanged.

## TC-008: Names with accents, apostrophe and hyphen are accepted
- **Result:** Pass
- **Actual:**
  - Step 1: `£150 x 2 nights £300`, `Cleaning fee £25`, `Service fee £15`, `Total £340`.
  - Typed values read back from the fields: `José`, `O'Brien-Núñez`, `jose.obrien@example.com`, `+523312345678`.
  - Step 5: `Booking Confirmed` / `2027-02-01 - 2027-02-03` / `Return home`. No red box and no error page. No garbled characters: the request and response both carry `José` and `O'Brien-Núñez` intact.
- **Evidence:** [TC-008-1.yml](evidence/2026-11-26/TC-008-1.yml)
  - Request: `{"roomid":2,"firstname":"José","lastname":"O'Brien-Núñez","depositpaid":false,"bookingdates":{"checkin":"2027-02-01","checkout":"2027-02-03"},"email":"jose.obrien@example.com","phone":"+523312345678"}`
  - Response: **201** `{"bookingdates":{"checkin":"2027-02-01","checkout":"2027-02-03"},"bookingid":6,"depositpaid":false,"firstname":"José","lastname":"O'Brien-Núñez","roomid":2}`
  - Console: 0 errors
- **Bug / ticket:** none
- **Time:** 16:32:50–16:33:00
- **Method:** URL opened in the address bar. Real clicks. Names typed character by character (`pressSequentially`, 30 ms delay), including the accents, apostrophe and hyphen.
- **Notes:** **NOT VERIFIED:** the stored spelling as shown in Admin, because admin credentials are not used. The API response echoes the correct spelling.

## TC-019: Firstname with 2 characters is rejected
- **Result:** Fail
- **Actual:**
  - No "Booking Confirmed" (count 0).
  - The red box above the Price Summary has exactly one bullet: `size must be between 3 and 18`. The bullet **does not name the field "Firstname"**, which contradicts the oracle and AC8 ("Each message identifies the field it refers to").
  - The form fields are still shown and editable, and keep `Al`, `Gonzalez`, `maria.gonzalez@example.com`, `+523312345678`. "Reserve Now" is visible and enabled. No error page.
  - URL unchanged: `/reservation/1?checkin=2027-06-01&checkout=2027-06-03`.
  - Price Summary: `£100 x 2 nights £200`, `£25`, `£15`, `Total £240`.
- **Evidence:** [TC-019-1.jpg](evidence/2026-11-26/TC-019-1.jpg) · [TC-019-1.yml](evidence/2026-11-26/TC-019-1.yml)
  - Request: `{"roomid":1,"firstname":"Al","lastname":"Gonzalez","depositpaid":false,"bookingdates":{"checkin":"2027-06-01","checkout":"2027-06-03"},"email":"maria.gonzalez@example.com","phone":"+523312345678"}`
  - Response: **400** `{"errors":["size must be between 3 and 18"]}`
  - Console: `Failed to load resource: the server responded with a status of 400 (Bad Request) @ /api/booking`
- **Bug / ticket:** BUG-05 (PO-6)
- **Time:** 16:33:04–16:33:20
- **Method:** URL opened in the address bar. Real clicks. Test data typed character by character.
- **Notes:** all other oracle points pass. The only failing point is that the message doesn't name the field.

## TC-029: Submitting with all fields empty shows an error per field and creates no booking
- **Result:** Fail
- **Actual:**
  - Step 4: no "Booking Confirmed". The red box has 7 bullets: `Firstname should not be blank`, `Lastname should not be blank`, `size must be between 3 and 18`, `size must be between 11 and 21`, `must not be empty`, `size must be between 3 and 30`, `must not be empty`. Five of the seven don't name a field, and **no message names Email or Phone**. The oracle says "a message without a field name (for example "must not be empty") fails" (AC8). The form is still usable: 4 empty, enabled fields, and "Reserve Now" is visible and enabled. No error page. Price Summary: `£100 x 2 nights £200`, `£25`, `£15`, `Total £240`.
  - Step 5: the breadcrumb "Home" link leads to `http://localhost:3003/`.
  - Steps 6–7: dates `01/07/2027` → `03/07/2027`. `GET /api/room?checkin=2027-07-01&checkout=2027-07-03` → 200. "Our Rooms" lists `Single`, `Double`, `Suite`, so the Single card is still listed. This step passes.
- **Evidence:** red box [TC-029-1.jpg](evidence/2026-11-26/TC-029-1.jpg) · [TC-029-1.yml](evidence/2026-11-26/TC-029-1.yml) · home after Check Availability [TC-029-2.yml](evidence/2026-11-26/TC-029-2.yml)
  - Request: `{"roomid":1,"firstname":"","lastname":"","depositpaid":false,"bookingdates":{"checkin":"2027-07-01","checkout":"2027-07-03"},"email":"","phone":""}`
  - Response: **400** `{"errors":["Firstname should not be blank","Lastname should not be blank","size must be between 3 and 18","size must be between 11 and 21","must not be empty","size must be between 3 and 30","must not be empty"]}`
  - Console: `Failed to load resource: the server responded with a status of 400 (Bad Request) @ /api/booking`
- **Bug / ticket:** BUG-05 (PO-6)
- **Time:** 16:33:30–16:33:56 (room page loaded 16:33:30)
- **Method:** step 1 URL opened in the address bar, as written. Real clicks. Breadcrumb "Home" clicked, scoped to `nav[aria-label="breadcrumb"]`. Dates typed as in TC-001. **Deviation (evidence only):** the first screenshot was scrolled past the red box, so I repositioned the viewport with a read-only `window.scrollTo` and retook it, overwriting the same file. There is still one screenshot for this oracle point. No app state was changed.
- **Notes:** all other oracle points pass. Nothing was stored for 2027-07-01..03 (see Data check).

## TC-031: Booking the exact same dates again is rejected
- **Result:** Fail
- **Actual:**
  - Precondition: created through the UI at `/reservation/1?checkin=2027-02-08&checkout=2027-02-10` → `Booking Confirmed` `2027-02-08 - 2027-02-10` (bookingid 7).
  - Step 3: `GET /api/room?checkin=2027-02-08&checkout=2027-02-10` → 200 with rooms `2:Double`, `3:Suite`. "Our Rooms" lists `Double`, `Suite`; **the Single card is not listed**. This step passes.
  - Step 6: no "Booking Confirmed", but the **panel and the whole page are replaced by the error page** `This page couldn't load` / `Reload to try again, or go back.` / `Reload` / `Back`. In this dev build, the Next.js overlay `Runtime TypeError: Cannot read properties of undefined (reading 'length')` is shown on top (`src/components/reservation/BookingForm.tsx (211:44)`, `bookingErrors.length > 0`). No message says the dates are not available. The form is gone (0 fields) and there is no Price Summary (count 0). This contradicts the oracle ("No error page; form still usable; a clear message") and the verdict rule for error pages.
- **Evidence:** precondition confirmation [TC-031-1.yml](evidence/2026-11-26/TC-031-1.yml) · home after Check Availability [TC-031-2.yml](evidence/2026-11-26/TC-031-2.yml) · error page [TC-031-1.jpg](evidence/2026-11-26/TC-031-1.jpg), [TC-031-3.yml](evidence/2026-11-26/TC-031-3.yml)
  - Precondition request: `{"roomid":1,"firstname":"Maria","lastname":"Gonzalez","depositpaid":false,"bookingdates":{"checkin":"2027-02-08","checkout":"2027-02-10"},"email":"maria.gonzalez@example.com","phone":"+523312345678"}` → **201** `{"bookingdates":{"checkin":"2027-02-08","checkout":"2027-02-10"},"bookingid":7,"depositpaid":false,"firstname":"Maria","lastname":"Gonzalez","roomid":1}`
  - Step 5 request: `{"roomid":1,"firstname":"Lucia","lastname":"Ramirez","depositpaid":false,"bookingdates":{"checkin":"2027-02-08","checkout":"2027-02-10"},"email":"lucia.ramirez@example.com","phone":"+523398765432"}`
  - Step 5 response: **409** `{"error":"Failed to create booking"}`
  - Console: `Failed to load resource: the server responded with a status of 409 (Conflict) @ /api/booking` and `TypeError: Cannot read properties of undefined (reading 'length') at BookingForm (…_219pl_sdam116._.js:1161:47)`
- **Bug / ticket:** BUG-01
- **Time:** 16:34:04–16:34:40 (step 4 page loaded 16:34:28)
- **Method:** the precondition was created through the UI, as the case says. The case says only "valid data", so I used TC-001's data (Maria Gonzalez). Steps 1–3: real clicks and typing. Step 4: URL opened in the address bar, as written. Step 5: real clicks, test data typed character by character.
- **Notes:** the server correctly refused the double booking (409), and only one 2027-02-08..10 booking is stored for room 1. The failure is client-side.

## TC-035: Check Out before Check In on the home page
- **Result:** Fail
- **Actual:**
  - Steps 2–4: the fields accepted `15/03/2027` and `13/03/2027`, so the date picker did not prevent the selection. Clicking "Check Availability" sent `GET /api/room?checkin=2027-03-15&checkout=2027-03-13` → 200. **No message appeared** near the date fields: the availability section text is only `Check Availability & Book Your Stay / Check In / Check Out / Check Availability`, and there are no alert or invalid-feedback elements. "Our Rooms" lists `Single`, `Double`, `Suite`, with "Book now" links carrying `checkin=2027-03-15&checkout=2027-03-13`. This contradicts AC11.
  - Step 5: URL `http://localhost:3003/reservation/1?checkin=2027-03-15&checkout=2027-03-13`. Price Summary: **`£100 x -2 nights £-200`**, `Cleaning fee £25`, `Service fee £15`, **`Total £-160`**. The oracle says it "does not show negative nights or negative amounts". No error page.
- **Evidence:** home with reversed dates and no message [TC-035-1.jpg](evidence/2026-11-26/TC-035-1.jpg), [TC-035-1.yml](evidence/2026-11-26/TC-035-1.yml) · room page with negative Price Summary [TC-035-2.jpg](evidence/2026-11-26/TC-035-2.jpg), [TC-035-2.yml](evidence/2026-11-26/TC-035-2.yml) · no submit, so no POST · console 0 errors
- **Bug / ticket:** BUG-02 (AC11). See also BUG-01 and PO-7 for how the server answers reversed ranges.
- **Time:** 16:34:48–16:35:05 (room page loaded 16:35:02)
- **Method:** real clicks and typing as written. The Single card's "Book now" was clicked.
- **Notes:** **NOT VERIFIED:** "a booking with valid data must not reach Booking Confirmed". The case's steps stop at checking the URL and the Price Summary and don't include a submit, so I didn't submit. No 2027-03-13..15 booking was stored (see Data check).

## TC-038: "View Details" in Similar Rooms keeps the selected dates
- **Result:** Pass
- **Actual:**
  - Under "Similar Rooms You Might Like", the "View Details" links are `/reservation/2?checkin=2027-04-05&checkout=2027-04-07` (Double) and `/reservation/3?…` (Suite).
  - After clicking the Double card's link: URL `http://localhost:3003/reservation/2?checkin=2027-04-05&checkout=2027-04-07`, heading `Double Room`.
  - Calendar: 5 clicks on "Next" from `November 2026` reach `April 2027`. The "Selected" bar starts on 5 April and covers cells `05`, `06`, `07`. 5 and 6 are covered as required; 7 is not asserted (PO-4).
  - Price Summary: `£150 x 2 nights £300`, `Cleaning fee £25`, `Service fee £15`, `Total £340`.
  - No other dates were shown or booked.
- **Evidence:** [TC-038-1.jpg](evidence/2026-11-26/TC-038-1.jpg) · [TC-038-1.yml](evidence/2026-11-26/TC-038-1.yml) · console 0 errors
- **Bug / ticket:** BUG-03 not reproduced on this local copy
- **Time:** 16:35:17–16:35:25 (both pages loaded 16:35:17)
- **Method:** step 1 URL opened in the address bar, as written. Scrolled to Similar Rooms. Real click on the Double card's "View Details". Real clicks on "Next".
- **Notes:** outside the oracle, the check-out day (7 April) is also shaded (CAND-10 / PO-4). The verdict is unchanged.

## TC-043: "Return home" link after confirmation
- **Result:** Pass
- **Actual:**
  - Step 2: `Booking Confirmed` / `Your booking has been confirmed for the following dates:` / `2027-04-26 - 2027-04-28` / `Return home`. No red box.
  - Step 4: after clicking "Return home", URL `http://localhost:3003/`. The navigation shows `Shady Meadows B&B, Rooms, Booking, Amenities, Location, Contact, Admin`. "Check Availability & Book Your Stay" and "Our Rooms" are visible, with `Single`, `Double`, `Suite`. No error, and 0 console errors.
- **Evidence:** confirmation [TC-043-1.yml](evidence/2026-11-26/TC-043-1.yml) · home [TC-043-2.yml](evidence/2026-11-26/TC-043-2.yml)
  - Request: `{"roomid":1,"firstname":"Maria","lastname":"Gonzalez","depositpaid":false,"bookingdates":{"checkin":"2027-04-26","checkout":"2027-04-28"},"email":"maria.gonzalez@example.com","phone":"+523312345678"}`
  - Response: **201** `{"bookingdates":{"checkin":"2027-04-26","checkout":"2027-04-28"},"bookingid":8,"depositpaid":false,"firstname":"Maria","lastname":"Gonzalez","roomid":1}`
- **Bug / ticket:** none
- **Time:** 16:35:29–16:35:40
- **Method:** step 1 URL opened in the address bar. Real clicks. Test data typed character by character. "Return home" was clicked, not opened by href.
- **Notes:** the oracle's URL `https://automationintesting.online/` maps to `http://localhost:3003/`.

---

## Totals
| Pass | Fail | Blocked | Question |
|---|---|---|---|
| 7 (TC-001, 003, 004, 006, 008, 038, 043) | 4 (TC-019, 029, 031, 035) | 0 | 0 |

## Data check (read-only `curl`, 16:35:47)
- `/api/report/room/1`: seeded 2026-02-01..05, plus **2027-12-14..16** (TC-001), **2027-01-11..12** (TC-006), **2027-02-08..10** (TC-031 precondition), **2027-04-26..28** (TC-043).
- `/api/report/room/2`: seeded 2026-02-02..04, plus **2027-02-01..03** (TC-008).
- `/api/report/room/3`: seeded 2026-03-01..05 only.
- Total: 8 bookings = 3 seeded + 5 "Booking Confirmed" in this run (health-check recount: `bookings (rooms 1-3): 8`). **There is exactly one stored booking for each "Booking Confirmed".**
- Rejected or non-submitting cases stored nothing:
  - `/api/room?checkin=2027-06-01&checkout=2027-06-03` → [1,2,3] (TC-019)
  - `/api/room?checkin=2027-07-01&checkout=2027-07-03` → [1,2,3] (TC-029)
  - `/api/room?checkin=2027-12-21&checkout=2027-12-23` → [1,2,3] (TC-004)
  - `/api/room?checkin=2027-12-07&checkout=2027-12-10` → [1,2,3] (TC-003)
  - `/api/room?checkin=2027-04-05&checkout=2027-04-07` → [1,2,3] (TC-038)
  - No 2027-03 booking exists (TC-035).
- Booked ranges are unavailable only for the booked room: 12-14..16 → [2,3], 01-11..12 → [2,3], 02-01..03 → [1,3], 02-08..10 → [2,3], 04-26..28 → [2,3].
- **No double bookings:** room 1 has a single 2027-02-08..10 entry. The TC-031 retry was refused with 409.

## NEW-CANDIDATEs
- None. Every non-Pass maps to a known ticket: BUG-05 (TC-019, TC-029), BUG-01 (TC-031) and BUG-02 (TC-035). The outside-oracle observations map to CAND-10 (TC-001, TC-038) and CAND-16 (TC-006).

## Deviations
1. **All cases:** steps were driven with `browser_run_code_unsafe`, running Playwright `click()`, `pressSequentially()` and `keyboard.press()`, instead of the one-action MCP tools. These are still real input events. Read-only JavaScript was used for reading values and calendar geometry.
2. **TC-029:** I repositioned the viewport with a read-only `window.scrollTo` so the red box was in frame, and retook the screenshot over the same file. One screenshot remains for that oracle point.
3. **TC-031:** the precondition says "valid data" without values, so I used TC-001's test data (Maria Gonzalez).
4. **TC-035:** I didn't submit, because the steps don't include a submit. The "must not reach Booking Confirmed" point is NOT VERIFIED.
5. **Housekeeping:** during TC-004, a stray element PNG (`runs/evidence/2026-11-26/tc004-tmp.png`) was written by mistake. It broke the JPEG/viewport policy, so I deleted it right away and it is not cited.
6. **Environment commit:** `efe2deb` comes from `bugs/README.md`. The task did not give a commit, and it can't be confirmed from the UI.

---

## Triage (QA lead, 2026-11-26)
1. **TC-035 is split.** The current case becomes the typed-dates case: it stays in Smoke and its **Fail stands** (BUG-02, AC11). A new case for selecting the reversed range with the date picker only goes to Regression.
2. **Evidence gaps** (no URL in the snapshots, no saved network or console output, no pre-submit snapshot for TC-008, TC-038 navigation path): accepted. Fixed in `executor.md`.
3. **TC-031:** the screenshot showed the Next.js development error overlay, not the page a user sees. The run header must state that the app is a development build.
4. **BUG-03 is not closed by this run.** TC-038 passed, but the navigation through "View Details" was not evidenced. BUG-03 gets a re-check.
5. **TC-006 stays Pass**, linked to CAND-16 ("1 nights").
6. **App commit:** it must be read from the app's repo (`git rev-parse HEAD` in `~/Projects/restful-booker-platform`), not taken from `bugs/README.md`.
7. **Files:** the executor must never delete files (Deviation 5). A file written by mistake is logged and left for the QA lead.
8. **Partial Smoke coverage** is accepted as Smoke scope: Smoke is a short gate. AC5–AC7 and AC11 have more cases in Regression and Full, concurrency is in Regression (TC-033) and Full (TC-034), refresh and Back are in Full (TC-042, TC-044, TC-045), and no case yet covers 5xx responses.
