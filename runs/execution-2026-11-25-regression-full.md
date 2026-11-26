# Execution results: Regression (16) and Full (28) suites, 2026-11-25

## Environment
- Same as the Smoke run (`runs/execution-2026-11-25-smoke.md`):
  - App: restful-booker-platform, local copy, commit `efe2deb`, at http://localhost:3003.
  - Browser: Claude desktop browser pane, viewport 1280×900.
  - Executor: Claude agent.
  - URLs changed from `https://automationintesting.online` to `http://localhost:3003`; nothing else changed.
- Data was **not** reset between suites. Smoke ran first and left 4 bookings (room 1: 2026-12-14..16, 2027-01-11..12, 2027-04-26..28; room 2: 2027-02-01..03). Every case uses its own date range.
- Run windows (CST):
  - Regression: 16:31:19–16:35:48 (4 min 29 s)
  - Full: 16:50:44–16:59:39 (8 min 55 s; includes a 25 s wait in TC-039)
- Between the two suites, the Smoke peer review was triaged, at 16:41–16:49.

## Method
- **Home page dates:** real click, then typed text, then Escape. **Links and buttons:** real clicks, unless a case note says otherwise.
- **Regression:** from TC-017 on, form fields were set through DOM input events (no keystrokes). The submit was a DOM `click()` from the same script.
- **Full:** fields were set the same way, except where the input itself is under test:
  - real keystrokes for TC-005 Firstname;
  - TC-016 (all fields);
  - TC-018, TC-022, TC-046 and TC-047 (the field under test).
  - TC-034 used a real double-click.
- **Evidence:** page text and DOM read by script (alert bullets, Price Summary, URL, calendar bar position and width), network log and console where noted, and screenshots for TC-038 (calendar) and TC-039 (spinner). After a run, bookings were checked through `/api/report/room/{id}` and `/api/room?checkin…&checkout…`.
- **Reload:** in the browser pane, F5 had no effect, so reloads used `location.reload()` (TC-044, TC-045).

## Verdict rules (as of 16:49, after the Smoke review triage)
- **Pass:** the application behaves as the case's expected result says.
- **Fail:** it contradicts the expected result for behavior an AC requires, or shows an error page, a crash or endless loading (more than 30 s).
- **Blocked:** the case can't be run because of the environment.
- **Question:** the behavior differs from the expected result, but no AC covers it. The main checks are recorded separately.
- **Wording only:** a difference only in wording, outside the oracle, keeps the verdict and goes in a note.
- **No composite verdicts.**
- **AC8 clarified:** "an error message is shown for each invalid field, and each message identifies the field it refers to."
- **Applied in Full, not written down before:** a known bug seen outside a case's oracle is noted with its ID ("outside oracle") and does not change the verdict.

## Data check after Full (API)
- 32 bookings in total: 3 seeded, plus 4 from Smoke, 5 from Regression and 20 from Full. Each matches one "Booking Confirmed" seen, except TC-034: 1 stored, but the user saw an error page.
- Rejected cases stored nothing: 2027-06-07, 06-10, 06-19, 06-22, 05-17 and 2026-11-26 have no booking.
- Regression: 5 bookings created (TC-017, the TC-031 and TC-032 preconditions, TC-033 tab A, TC-049). No booking after any error page, and no double booking in TC-033.

---

# REGRESSION

## TC-017: Names made only of digits (BUG-04)
- **Steps:** /reservation/1?checkin=2027-01-25&checkout=2027-01-26 → Reserve Now → data → Reserve Now → check panel.
- **Data:** 12345 / 67890 / maria.gonzalez@example.com / +523312345678
- **Expected:** no "Booking Confirmed". A red box with a bullet that names Firstname or Lastname and says a name can't be only digits. The form is still usable and there is no error page.
- **Result:** Fail.
- **Actual:** "Booking Confirmed" 2027-01-25 - 2027-01-26, with no message.
- **Evidence:** page text; the report API shows 2027-01-25..26.
- **Bug:** BUG-04.
- **Time:** 16:31:19–16:31:22.
- **Notes:** from here on, fields were set by DOM input events. No AC says names must contain letters; earlier, L-08 classified this as an "AC gap".

## TC-020: Firstname with 19 characters is rejected (BUG-05)
- **Steps:** /reservation/1?checkin=2027-06-04&checkout=2027-06-06 → Reserve Now → data → Reserve Now → check the red box, form, Price Summary and URL.
- **Data:** Abcdefghijklmnopqrs (19) / Gonzalez / maria.gonzalez@example.com / +523312345678
- **Expected:** no "Booking Confirmed". The red box shows exactly one bullet, about Firstname length (3–18), and the bullet names the field. The form is usable, there is no error page, the URL is unchanged, and the Price Summary is £200, £25, £15, Total £240.
- **Result:** Fail.
- **Actual:** no confirmation. Form usable. URL unchanged. £200 / £25 / £15 / £240. One bullet: "size must be between 3 and 18" (no field name).
- **Evidence:** alert text from the DOM. The input has no maxlength; the 19-character value was confirmed in the field.
- **Bug:** BUG-05.
- **Time:** 16:31:31–16:31:33.

## TC-023: Lastname with 2 characters is rejected (BUG-05)
- **Steps/data:** /reservation/1?checkin=2027-06-13&checkout=2027-06-15 · Maria / Li / maria.li@example.com / +523312345678
- **Expected:** no confirmation. Exactly one bullet, about Lastname length (3–30), naming the field. Form usable, no error page, £240.
- **Result:** Fail.
- **Actual:** no confirmation. Form usable. £240. One bullet: "size must be between 3 and 30".
- **Evidence:** alert text from the DOM.
- **Bug:** BUG-05.
- **Time:** 16:31:42–16:31:44.

## TC-024: Lastname with 31 characters is rejected (BUG-05)
- **Steps/data:** /reservation/1?checkin=2027-06-16&checkout=2027-06-18 · Maria / Abcdefghijklmnopqrstuvwxyzabcde (31) / maria.gonzalez@example.com / +523312345678
- **Expected:** as TC-023, for the 3–30 rule.
- **Result:** Fail.
- **Actual:** no confirmation. Form usable. £240. One bullet: "size must be between 3 and 30".
- **Bug:** BUG-05.
- **Time:** 16:31:51–16:31:53.

## TC-027: Phone with 10 characters is rejected (BUG-05)
- **Steps/data:** /reservation/1?checkin=2027-06-25&checkout=2027-06-27 · Maria / Gonzalez / maria.gonzalez@example.com / 0123456789 (10)
- **Expected:** no confirmation. Exactly one bullet about Phone length (11–21), naming Phone. Form usable, no error page, £240.
- **Result:** Fail.
- **Actual:** no confirmation. Form usable. £240. One bullet: "size must be between 11 and 21".
- **Bug:** BUG-05.
- **Time:** 16:32:00–16:32:02.

## TC-028: Phone with 22 characters is rejected (BUG-05)
- **Steps/data:** /reservation/1?checkin=2027-06-28&checkout=2027-06-30 · Phone 0123456789012345678901 (22)
- **Expected:** as TC-027.
- **Result:** Fail.
- **Actual:** no confirmation. Form usable. £240. One bullet: "size must be between 11 and 21".
- **Bug:** BUG-05.
- **Time:** 16:32:09–16:32:11.

## TC-031: Booking the exact same dates again is rejected (BUG-01)
- **Precondition:** a Single booking exists for 2027-02-08..10. Created via /reservation/1?checkin=2027-02-08&checkout=2027-02-10 with valid data (Maria).
- **Steps:** home → dates 08/02/2027–10/02/2027 → Check Availability → check "Our Rooms" → open /reservation/1?checkin=2027-02-08&checkout=2027-02-10 → Reserve Now, data, Reserve Now → check the panel.
- **Data:** Lucia / Ramirez / lucia.ramirez@example.com / +523398765432
- **Expected:**
  - Step 3: the Single card is not listed.
  - Step 6: no "Booking Confirmed"; a clear message says the dates are not available; no error page; form usable; £240.
- **Result:** Fail.
- **Actual:**
  - Precondition created.
  - Step 3: Single not listed (Book-now links only for rooms 2 and 3).
  - Step 6: the whole page was replaced by "This page couldn't load – Reload to try again, or go back".
- **Evidence:** network POST /api/booking → 409 Conflict. Console: "Uncaught TypeError: Cannot read properties of undefined (reading 'length') at BookingForm".
- **Bug:** BUG-01.
- **Time:** 16:32:19–16:32:47.

## TC-032: Partially overlapping dates are rejected (BUG-01)
- **Precondition:** a Single booking exists for 2027-02-15..17. The executor created it through the UI; the case gave no creation step.
- **Steps/data:** /reservation/1?checkin=2027-02-16&checkout=2027-02-18 → Reserve Now, data (Lucia…), Reserve Now → panel.
- **Expected:** no confirmation; a clear "dates not available" message; no error page; form usable; £100 × 2 nights = £200, £25, £15, Total £240.
- **Result:** Fail.
- **Actual:** £240 before submitting. After submitting: "This page couldn't load" error page. No booking for 02-16.
- **Evidence:** error page text; report API.
- **Bug:** BUG-01.
- **Time:** 16:32:58–16:33:09.

## TC-033: Two tabs booking the same room and dates: only the first succeeds (BUG-01)
- **Steps:** tab A and tab B both open /reservation/3?checkin=2027-03-01&checkout=2027-03-03 → both: Reserve Now, type data → A submits → B submits without refreshing → check both.
- **Data:** A: Maria / Gonzalez / maria.gonzalez@example.com / +523312345678. B: Lucia / Ramirez / lucia.ramirez@example.com / +523398765432.
- **Expected:**
  - A: "Booking Confirmed" 2027-03-01 - 2027-03-03.
  - B: no confirmation; a clear "not available" message; no error page; £225 × 2 nights = £450, £25, £15, Total £490.
- **Result:** Fail.
- **Actual:**
  - A: confirmed 2027-03-01 - 2027-03-03.
  - B: "This page couldn't load".
  - Only 1 booking stored.
- **Evidence:** page text in both tabs; /api/report/room/3.
- **Bug:** BUG-01.
- **Time:** about 16:33:15–16:33:36.
- **Notes:** data integrity is fine. Tab B's Price Summary was not recorded before submitting. Tab B was opened as a background tab.

## TC-035: Check Out before Check In on the home page (BUG-01, BUG-02)
- **Steps:** home → Check In 15/03/2027, Check Out 13/03/2027 → Check Availability → check → if "Book now" is shown, open Single and check URL and Price Summary.
- **Expected:** a clear message near the date fields says Check Out must be after Check In, or the picker prevents the selection. No error page. If a room page opens: no negative nights or amounts, and valid data must not reach "Booking Confirmed".
- **Result:** Fail.
- **Actual:**
  - The pickers accepted 15/03/2027 → 13/03/2027. No message. All 3 rooms listed (links with checkin=2027-03-15&checkout=2027-03-13).
  - Single page: "£100 x -2 nights", "£-200", £25, £15, Total "£-160".
- **Evidence:** page text.
- **Bug:** BUG-01, BUG-02.
- **Time:** about 16:33:40–16:34:00.
- **Notes:** the Single page was opened through its Book-now href (the same URL), not with a click. Submitting was not tried in this case; TC-048 covers it.

## TC-036: Same-day Check In and Check Out, 0 nights (BUG-01, BUG-02)
- **Steps:** home → 17/03/2027 – 17/03/2027 → Check Availability → message? → if possible, Single → Price Summary → Reserve Now, valid data, Reserve Now.
- **Expected:**
  - Step 3: a clear message, or the picker prevents the selection.
  - Step 4: the Price Summary doesn't show "0 nights" or a fees-only total (£40). Submitting does not reach "Booking Confirmed" and does not show an error page; a clear message explains why.
- **Result:** Fail.
- **Actual:**
  - No message; all rooms listed.
  - Single page: "£100 x 0 nights", £0, £25, £15, Total £40.
  - Submit: "This page couldn't load".
- **Evidence:** page text.
- **Bug:** BUG-01, BUG-02.
- **Time:** about 16:34:05–16:34:27.
- **Notes:** opened via the href.

## TC-038: "View Details" in Similar Rooms keeps the selected dates (BUG-03)
- **Steps:** /reservation/1?checkin=2027-04-05&checkout=2027-04-07 → "Similar Rooms You Might Like" → "View Details" on Double → check URL, room name, calendar (Next to April 2027) and Price Summary.
- **Expected:** the Double page opens. Either the URL is /reservation/2?checkin=2027-04-05&checkout=2027-04-07, "Selected" is on 5 and 6 April 2027, and the Price Summary is £150 × 2 nights = £300, £25, £15, Total £340; or a clear prompt asks to select dates. Fail if other dates (for example today/tomorrow) are shown or booked without the user selecting them.
- **Result:** Question (CAND-10).
- **Actual:**
  - Real click on View Details.
  - URL /reservation/2?checkin=2027-04-05&checkout=2027-04-07. "Double Room". £150 x 2 nights = £300, £25, £15, Total £340.
  - April 2027 calendar: "Selected" covers 5, 6 AND 7 April.
- **Evidence:** URL, page text, calendar bar from the DOM.
- **Time:** 16:34:40–16:34:53.
- **Notes:** **BUG-03 is not reproduced on the local copy**; the dates are kept. First recorded as "Pass – calendar = Question" and changed to Question at 16:49 under the no-composite rule. Months were advanced with DOM clicks on "Next".

## TC-048: Reversed dates via URL tampering (BUG-01, BUG-02)
- **Steps:** /reservation/1?checkin=2027-03-22&checkout=2027-03-20 → Price Summary → Reserve Now, data, Reserve Now → panel.
- **Expected:**
  - Step 2: no negative nights and no negative or zero-night total shown as payable.
  - Step 4: no confirmation; a clear message says Check Out must be after Check In; no error page; form usable.
- **Result:** Fail.
- **Actual:**
  - "£100 x -2 nights", £-200, Total £-160.
  - Submit: "This page couldn't load".
- **Bug:** BUG-01, BUG-02.
- **Time:** 16:34:30–16:34:37.
- **Notes:** the timestamps overlap TC-036's "about" window; the order was 035, 036, 048, 038.

## TC-049: Clicking a date in the room calendar keeps price, calendar, URL and booking consistent (BUG-06)
- **Steps:** /reservation/2?checkin=2027-09-06&checkout=2027-09-09 → Next until September 2027 → check → click 20 September once → check calendar, URL and Price Summary → Reserve Now, data, Reserve Now → panel.
- **Expected:**
  - Step 2: "Selected" on 6, 7 and 8 September; £150 × 3 nights = £450, £25, £15, Total £490.
  - Step 4: calendar, URL and Price Summary all describe the same stay. Fail if the total doesn't match the dates in the URL and calendar.
  - Step 6: "Booking Confirmed" shows the same dates the Price Summary showed just before submitting.
- **Result:** Fail.
- **Actual:**
  - Step 2: "Selected" covers 6–9 (check-out day included); £450 / £490.
  - Step 4: real mouse click on 20 September. The calendar and the URL still say 6–9 September, but the Price Summary changed to "£150 x 1 nights" = £150, Total £190.
  - Step 6: "Booking Confirmed" 2027-09-06 - 2027-09-09 (3 nights).
- **Evidence:** page text before and after the click; the report API shows 2027-09-06..09.
- **Bug:** BUG-06.
- **Time:** 16:35:09–16:35:28.
- **Notes:** step 2 has the CAND-10 shading too; it is outside the main check.

## TC-050: Each error message names the field it refers to (BUG-05)
- **Steps/data:** /reservation/1?checkin=2027-09-20&checkout=2027-09-22 · Al / Gonzalez / maria@ / 0123456789
- **Expected:** no confirmation. Three bullets, one each for Firstname, Email and Phone, each naming its field; no bullet for Lastname. A bullet with no field name fails.
- **Result:** Fail.
- **Actual:** no confirmation. Bullets: "must be a well-formed email address", "size must be between 3 and 18", "size must be between 11 and 21".
- **Bug:** BUG-05.
- **Time:** about 16:35:30–16:35:37.
- **Notes:** "maria@" is rejected as malformed.

## TC-052: "Amenities" navigation link goes to the amenities section (BUG-07)
- **Steps:** home → click "Amenities" in the top navigation → check URL and page.
- **Expected:** the page scrolls to a visible Amenities section, or opens an amenities page. Fail if the URL changes to /#amenities and nothing changes on screen.
- **Result:** Fail.
- **Actual:** real click. URL changed to /#amenities. scrollY stayed 0. The page has no element with id "amenities"; the ids present are booking, rooms, location and contact.
- **Evidence:** URL, scroll position, DOM ids.
- **Bug:** BUG-07.
- **Time:** 16:35:40–16:35:48.

---

# FULL

## TC-002: Book a Double room for today using the prefilled home page dates
- **Steps:** home → check the prefilled dates → Book now on Double → URL → calendar → Price Summary → Reserve Now, data, Reserve Now → panel.
- **Expected:**
  - Check In = today, Check Out = tomorrow.
  - URL /reservation/2?checkin=D&checkout=D+1.
  - The calendar opens on the current month, today is highlighted, and there is a "Sel…" bar on today.
  - £150 × 1 night = £150, £25, £15, Total £190.
  - "Booking Confirmed" with D - D+1 and "Return home".
- **Result:** Question (CAND-10).
- **Actual:**
  - Prefilled 25/11/2026 and 26/11/2026. URL matches.
  - November calendar, today highlighted. The "Selected" bar covers 25 AND 26.
  - £150 x 1 nights = £150, Total £190.
  - Confirmed 2026-11-25 - 2026-11-26.
- **Evidence:** page text; calendar from the DOM; server Date header 22:50 GMT.
- **Time:** 16:50:44–16:51:01.
- **Notes:** the main flow passed.

## TC-005: "Cancel" closes the form without booking
- **Steps/data:** /reservation/1?checkin=2026-11-26&checkout=2026-11-28 → Reserve Now → type Firstname Maria → Cancel → check → Reserve Now again → check.
- **Expected:**
  - Step 4: form fields and Cancel hidden; Reserve Now visible; no confirmation; no red box; Price Summary unchanged (£200, £25, £15, Total £240); URL unchanged.
  - Step 6: form and Cancel appear again. No booking created.
- **Result:** Pass.
- **Actual:** as expected. The form reappears empty. The report API has no 2026-11-26 booking.
- **Time:** 16:51:01–16:51:20.
- **Notes:** real keystrokes for Firstname; real clicks for Reserve Now and Cancel; the second Reserve Now was a DOM click.

## TC-007: All fields at their maximum valid length are accepted
- **Data:** Abcdefghijklmnopqr (18) / Abcdefghijklmnopqrstuvwxyzabcd (30) / maria.gonzalez@example.com / 012345678901234567890 (21), on /reservation/1?checkin=2027-01-13&checkout=2027-01-14.
- **Expected:** "Booking Confirmed" 2027-01-13 - 2027-01-14. No red box, no truncation error, no error page.
- **Result:** Pass.
- **Actual:** field lengths 18 / 30 / 26 / 21 confirmed in the inputs; confirmed 2027-01-13 - 2027-01-14.
- **Time:** 16:51:20–16:51:32.

## TC-009: International phone format is accepted
- **Data:** Oliver / Smith / oliver.smith@example.co.uk / +44 (20) 7946-0958 (18), on /reservation/1?checkin=2027-01-06&checkout=2027-01-07.
- **Expected:** confirmed 2027-01-06 - 2027-01-07; no Phone error.
- **Result:** Pass.
- **Actual:** confirmed; no red box.
- **Time:** 16:51:32–16:51:42.

## TC-010: Email with a plus sign and multi-level domain is accepted
- **Data:** maria.gonzalez+trip@mail.example.co.uk, on /reservation/1?checkin=2027-01-08&checkout=2027-01-09.
- **Expected:** confirmed 2027-01-08 - 2027-01-09; no Email error.
- **Result:** Pass.
- **Actual:** confirmed.
- **Time:** 16:51:42–16:51:51.

## TC-011: Booking across a month boundary
- **Steps:** home 30/11/2026–02/12/2026 → Check Availability → Double → URL → calendar Nov then Dec → Price Summary → book.
- **Expected:**
  - URL /reservation/2?checkin=2026-11-30&checkout=2026-12-02.
  - "Selected" on 30 November and 1 December only.
  - £150 × 2 nights = £300, £25, £15, Total £340.
  - Confirmed 2026-11-30 - 2026-12-02.
- **Result:** Question (CAND-10).
- **Actual:**
  - URL matches.
  - The bar covers 30 Nov, 1 Dec AND 2 Dec, in both month views.
  - £340.
  - Confirmed.
- **Time:** 16:51:51–16:52:21.

## TC-012: Booking across a year boundary
- **Steps:** home 30/12/2026–02/01/2027 → Single → URL, Price Summary → book.
- **Expected:**
  - URL /reservation/1?checkin=2026-12-30&checkout=2027-01-02.
  - £100 × 3 nights = £300, £25, £15, Total £340.
  - Confirmed 2026-12-30 - 2027-01-02, with the year 2027 on the end date.
- **Result:** Pass.
- **Actual:** as expected.
- **Time:** 16:52:21–16:52:46.

## TC-013: Booking about one year in the future
- **Steps:** home 11/10/2027–13/10/2027 → Suite → URL, Price Summary → Next until October 2027 → book.
- **Expected:**
  - URL /reservation/3?checkin=2027-10-11&checkout=2027-10-13.
  - £225 × 2 nights = £450, £25, £15, Total £490.
  - "Selected" on 11 and 12 October 2027.
  - Confirmed 2027-10-11 - 2027-10-13.
- **Result:** Question (CAND-10).
- **Actual:** URL and price match. The bar covers 11, 12 AND 13. Confirmed.
- **Time:** 16:52:46–16:53:13.
- **Notes:** months advanced with DOM clicks.

## TC-014: Dates changed without clicking "Check Availability" are passed to the room page
- **Steps:** home 10/05/2027–12/05/2027 → do not click Check Availability → Book now on Single → URL, Price Summary.
- **Expected:** URL /reservation/1?checkin=2027-05-10&checkout=2027-05-12 (not today/tomorrow); £100 × 2 nights = £200, £25, £15, Total £240.
- **Result:** Pass.
- **Actual:** as expected; real click on Book now.
- **Time:** 16:53:13–16:53:31.

## TC-015: Back-to-back booking is allowed
- **Precondition:** Double 2027-02-22..24, created through the UI.
- **Steps/data:** /reservation/2?checkin=2027-02-24&checkout=2027-02-26 · Lucia…
- **Expected:** £150 × 2 nights = £300, £25, £15, Total £340; confirmed 2027-02-24 - 2027-02-26.
- **Result:** Pass.
- **Actual:** as expected; both bookings are stored.
- **Time:** 16:53:31–16:53:49.

## TC-016: Firstname with an emoji is handled without errors
- **Data:** Ana😀 / Gonzalez / ana.gonzalez@example.com / +523312345678, on /reservation/1?checkin=2027-01-15&checkout=2027-01-16.
- **Expected:** confirmed 2027-01-15 - 2027-01-16; no error page, no garbled text.
- **Result:** Pass.
- **Actual:** all fields typed with real keystrokes; the input value is "Ana😀" (4 code points). Confirmed; no error page.
- **Time:** 16:53:49–16:54:15.
- **Notes:** "no garbled text" was NOT VERIFIED for the stored value; the UI shows only dates.

## TC-018: Leading and trailing spaces don't count toward Firstname length
- **Data:** Firstname "  Al  " (2 spaces, Al, 2 spaces) / Gonzalez / maria.gonzalez@example.com / +523312345678, on /reservation/1?checkin=2027-01-18&checkout=2027-01-20.
- **Expected:** no confirmation. A red box with one bullet about Firstname length. Form still usable, no error page. £240.
- **Result:** Question (CAND-11).
- **Actual:** Firstname typed with real keystrokes; the value is "  Al  ". The booking was CONFIRMED, with no message.
- **Time:** 16:54:15–16:54:31.
- **Notes:** no AC says names are trimmed; this is PO question 5. TC-022 shows the blank check does trim spaces, so the two rules are inconsistent.

## TC-021: Empty Firstname is rejected
- **Data:** empty / Gonzalez / maria.gonzalez@example.com / +523312345678, on /reservation/1?checkin=2027-06-07&checkout=2027-06-09.
- **Expected:** no confirmation. The red box shows a bullet saying Firstname is required, and no bullets for Lastname, Email or Phone. Form usable, no error page, £240.
- **Result:** Pass.
- **Actual:** no confirmation. Bullets: "size must be between 3 and 18" and "Firstname should not be blank". Form usable, £240.
- **Bug:** BUG-05 (outside the oracle).
- **Time:** 16:54:31–16:54:42.
- **Notes:** the unnamed size bullet is about Firstname. Under the clarified AC8 it does not identify its field, but this case's oracle doesn't check that.

## TC-022: Firstname made only of spaces is rejected
- **Data:** 3 spaces, typed with real keystrokes; other fields valid; /reservation/1?checkin=2027-06-10&checkout=2027-06-12.
- **Expected:** no confirmation. A Firstname error (required or length). Form usable, no error page, £240.
- **Result:** Pass.
- **Actual:** one bullet: "Firstname should not be blank". Form usable, £240.
- **Time:** 16:54:42–16:54:58.

## TC-025: Email without "@" is rejected
- **Data:** maria.gonzalez.example.com, on /reservation/1?checkin=2027-06-19&checkout=2027-06-21.
- **Expected:** no confirmation. Exactly one bullet saying the email format is invalid. Form usable, no error page, £240.
- **Result:** Pass.
- **Actual:** one bullet: "must be a well-formed email address". Form usable, £240.
- **Time:** 16:54:58–16:55:13.

## TC-026: Email without a domain is rejected
- **Data:** maria@, on /reservation/1?checkin=2027-06-22&checkout=2027-06-24.
- **Expected:** as TC-025.
- **Result:** Pass.
- **Actual:** one bullet: "must be a well-formed email address".
- **Time:** 16:55:13–16:55:17.

## TC-030: Several invalid fields at once, then corrected, books successfully
- **Data:**
  - Invalid: Al / Li / maria@ / 0123456789.
  - Valid: Maria / Gonzalez / maria.gonzalez@example.com / +523312345678.
  - Page: /reservation/1?checkin=2027-07-04&checkout=2027-07-06.
- **Expected:**
  - Step 3: no confirmation. The red box lists four errors (Firstname, Lastname, Email, Phone) together, not only the first one. £240.
  - Step 5: the red box is gone; "Booking Confirmed" 2027-07-04 - 2027-07-06. No "already booked" error, which proves step 2 created nothing.
- **Result:** Pass.
- **Actual:**
  - Step 3: four bullets: "size must be between 3 and 30", "must be a well-formed email address", "size must be between 3 and 18", "size must be between 11 and 21". £240.
  - Step 5: red box gone; confirmed.
- **Bug:** BUG-05 (outside the oracle).
- **Time:** 16:55:17–16:55:29.

## TC-034: Double-clicking the submit button creates only one booking
- **Steps/data:** /reservation/2?checkin=2027-03-08&checkout=2027-03-10 → Reserve Now, data → double-click Reserve Now quickly → panel.
- **Expected:** one "Booking Confirmed" panel with 2027-03-08 - 2027-03-10. No "dates not available" error after the confirmation, and no error page.
- **Result:** Fail.
- **Actual:** real double-click. The page was replaced by "This page couldn't load". Network: POST /api/booking → 201 Created and POST /api/booking → 409 Conflict. The report API shows exactly 1 booking for 2027-03-08..10.
- **Evidence:** network log, error page text, report API.
- **Bug:** BUG-01.
- **Time:** 16:55:29–16:55:49.
- **Notes:** the booking was created, but the user sees an error page.

## TC-037: Booking dates in the past
- **Steps/data:** home 10/10/2026–12/10/2026 → Check Availability → Single → Reserve Now, valid data, Reserve Now.
- **Expected:** no "Booking Confirmed" for past dates; a clear message says the dates are not valid; no error page.
- **Result:** Question (CAND-08).
- **Actual:** the dates were accepted and all rooms listed, with no message. £240. The booking was CONFIRMED 2026-10-10 - 2026-10-12 and stored.
- **Time:** 16:55:49–16:56:18.
- **Notes:** no AC forbids past dates; this is PO question 2. The Single page was opened through its href.

## TC-039: Room URL without date parameters
- **Steps/data:** /reservation/1 → panel and Price Summary → Reserve Now, data, Reserve Now → panel.
- **Expected:**
  - Step 2: the page loads with no error; a clear prompt asks to select dates; the Price Summary shows no "NaN", "undefined" or negative values.
  - Step 4: no "Booking Confirmed" for dates the user never selected; a clear message asks for dates.
- **Result:** Fail.
- **Actual:** the room details load, but the "Book This Room" panel shows only a spinner. It was still spinning 25 s later (16:56:59), with no Reserve Now and no Price Summary. Every API call for the page returned 200. Steps 3–4 could not be run.
- **Evidence:** screenshot of the spinner; DOM after 25 s; network log.
- **Bug:** CAND-12 (new).
- **Time:** 16:56:18–16:56:59.
- **Notes:** endless loading counts as Fail under the rules. The case's own expected result does not mention a spinner.

## TC-040: Room URL with invalid date parameters
- **Steps/data:** /reservation/1?checkin=abc&checkout=xyz → page → Reserve Now, data, Reserve Now.
- **Expected:** no error page or blank page. The Price Summary shows no "NaN", "Invalid Date" or negative values. A clear prompt asks to select dates. No "Booking Confirmed".
- **Result:** Fail.
- **Actual:** the Price Summary shows "£100 x NaN nights", "£NaN" and Total "£NaN", with no prompt. Submitting shows a red box, "Failed to create booking": no confirmation and no crash.
- **Bug:** CAND-13 (new).
- **Time:** 16:56:59–16:57:14.

## TC-041: Room URL with a non-existent room ID
- **Steps:** /reservation/99?checkin=2027-04-12&checkout=2027-04-14 → page.
- **Expected:** a clear "room not found" message or a redirect home. No crash, no blank page, no panel with a missing price. No way to book.
- **Result:** Fail.
- **Actual:** "This page couldn't load". GET /api/room/99 → 500 Internal Server Error.
- **Evidence:** network log, page text.
- **Bug:** CAND-14 (new).
- **Time:** 16:57:14–16:57:23.

## TC-042: Browser Back after a confirmed booking doesn't rebook or break
- **Steps:** home 19/04/2027–21/04/2027 → Check Availability → Single → book → browser Back → check → Check Availability → "Our Rooms".
- **Expected:**
  - Step 2: confirmed 2027-04-19 - 2027-04-21.
  - Step 4: the home page loads normally, with no resubmission prompt and no error page.
  - Step 5: Single is not listed for 19/04/2027–21/04/2027.
- **Result:** Pass.
- **Actual:** confirmed. Back (browser navigation) went to the home page with no error. The date fields had reset to today, so the executor typed 19/04–21/04 again and clicked Check Availability. Only Double and Suite were listed.
- **Time:** 16:57:23–16:58:10.

## TC-044: Refreshing after confirmation doesn't resubmit
- **Steps:** /reservation/1?checkin=2027-05-03&checkout=2027-05-05 → book → refresh → page.
- **Expected:**
  - Step 2: confirmed 2027-05-03 - 2027-05-05.
  - Step 4: the page reloads without a resubmission prompt or an error page; the refresh triggers no second "Booking Confirmed"; the Price Summary, if shown, is £240.
- **Result:** Pass.
- **Actual:** confirmed. F5 had no effect in the pane, so the page was reloaded with location.reload() (navigation type "reload"). After the reload: the room page, £240, no confirmation, no error. Exactly 1 booking for 05-03.
- **Time:** 16:58:10–16:58:34.
- **Notes:** after the reload, the page offers "Reserve Now" again for dates the user has just booked.

## TC-045: Refresh mid-flow (form filled, not submitted) creates no booking
- **Steps:** /reservation/1?checkin=2027-05-17&checkout=2027-05-19 → Reserve Now, type data, no submit → refresh → URL, calendar, Price Summary → home with the same dates → Check Availability.
- **Expected:**
  - Step 4: URL unchanged; £100 × 2 nights = £200, £25, £15, Total £240; no "Booking Confirmed".
  - Step 5: Single is still listed.
- **Result:** Pass.
- **Actual:** reloaded with location.reload(). URL unchanged, £240, no confirmation. Step 5 was checked through `/api/room?checkin=2027-05-17&checkout=2027-05-19`, which returned rooms 1, 2 and 3, not through the home page UI.
- **Time:** 16:58:34–16:58:46.

## TC-046: Script and HTML in name fields aren't executed or rendered
- **Data:** `<b>Ana</b>` / `<script>alert('XSS')</script>` / ana.test@example.com / +523312345678, on /reservation/2?checkin=2027-05-24&checkout=2027-05-26.
- **Expected:** no alert at any point. No bold or HTML-formatted text anywhere on the page. Either confirmed 2027-05-24 - 2027-05-26 (input stored as plain text) or a clear validation message. No error page.
- **Result:** Pass.
- **Actual:** both names typed with real keystrokes. window.alert was hooked before typing and recorded 0 calls. The DOM has no `<b>` element and no script containing "XSS". Confirmed.
- **Time:** 16:58:46–16:59:06.
- **Notes:** this is a weak oracle (L-31). The names are never displayed back in the UI, and stored XSS was not verified because that needs the admin view.

## TC-047: SQL-style input in Lastname is handled as text
- **Data:** Smith' OR '1'='1 (typed with real keystrokes), on /reservation/1?checkin=2027-08-02&checkout=2027-08-04.
- **Expected:** confirmed 2027-08-02 - 2027-08-04. No database error, stack trace, error page or technical message.
- **Result:** Pass.
- **Actual:** confirmed; no technical text on the page.
- **Time:** 16:59:06–16:59:22.

## TC-051: The same dates on a different room can be booked
- **Precondition:** Single 2027-09-13..15, created through the UI.
- **Steps/data:** /reservation/2?checkin=2027-09-13&checkout=2027-09-15 · Lucia…
- **Expected:** £150 × 2 nights = £300, £25, £15, Total £340; confirmed 2027-09-13 - 2027-09-15.
- **Result:** Pass.
- **Actual:** as expected. The report API shows 2 bookings starting 09-13 (rooms 1 and 2).
- **Time:** 16:59:22–16:59:39.

---

## Totals
- **Regression:** 1 Question (TC-038) and 15 Fail.
- **Full:** 19 Pass, 5 Question and 4 Fail.
- **New candidates in this run:**
  - CAND-11: spaces count toward the Firstname length.
  - CAND-12: endless spinner when the URL has no dates.
  - CAND-13: £NaN when the URL has invalid dates.
  - CAND-14: a missing room returns 500 and an error page.
- **CAND-10** (the calendar shades the check-out day) shows up in TC-001, 002, 011, 013, 038 and 049.

---

## Changes after the peer review (2026-11-25 19:59, QA lead triage)
- **TC-017:** Fail → **Question (BUG-04 · PO-1)**. No AC requires letters. The ticket stays open with status "Needs PO decision".
- **TC-052:** Fail → **Question (BUG-07 · PO-5)**. No AC in this story covers navigation. The ticket stays open.
- **TC-021, TC-030:** stay **Pass**. Their oracles predate the AC8 clarification. BUG-05 is linked as observed. The AC8 clarification itself goes to the PO (PO-6); if confirmed, both oracles are updated in the next suite version.
- **TC-034:** added **CAND-15**: the submit button isn't disabled, so a double-click sends two POSTs. This is separate from BUG-01.
- **TC-040:** CAND-13 linked to **BUG-02**, as the likely same root cause.
- **Already answered:** none of the four inputs has a maxlength (checked at 16:31). The TC-039 spinner was still present about 40 s after page load.
- **Totals after triage:**
  - Regression: 3 Question, 13 Fail.
  - Full: 19 Pass, 5 Question, 4 Fail.
- **Re-checks offered but not run yet:**
  - TC-045 step 5 through the UI.
  - TC-009 phone typed with real keystrokes.
  - POST status for TC-036 and TC-048.
  - TC-033 tab B in the foreground.

---

## Re-checks requested by the peer review (2026-11-26, 14:29–14:31 CST)

Same local instance (commit `efe2deb`), not reset: it held 32 bookings beforehand. The health check returned 200 on `/api/room/1–3` and `/api/report/room/1`. Cases that create bookings used new dates, because the original ones were already booked.

| Case | What the reviewer asked for | Result |
|---|---|---|
| TC-045 | Check step 5 in the UI, not through the API | Home page, dates 17/05/2027–19/05/2027 typed, real click on Check Availability: **Single is listed** (Book-now links for rooms 1, 2 and 3). The **Pass is confirmed** through the UI. |
| TC-009 | Type the phone with real keystrokes | All fields typed for real on `/reservation/1?checkin=2027-11-01&checkout=2027-11-02` (new dates). The input holds `+44 (20) 7946-0958`. "Booking Confirmed" 2027-11-01 - 2027-11-02, no red box. The **Pass is confirmed**. |
| TC-036 | Capture the POST status | `POST /api/booking` → **409**, body `{"error":"Failed to create booking"}`, then the error page. **BUG-01 confirmed** on this path. |
| TC-048 | Capture the POST status | `POST /api/booking` → **409**, with the same body, then the error page. **BUG-01 confirmed**. |
| TC-033 | Tab B in the foreground; record B's Price Summary and POST | New dates, Suite 2027-11-08..10. Tab B was in the foreground (`visibilityState` "visible") with Price Summary £225 x 2 nights = £450, £25, £15, Total £490. Tab A was confirmed. In tab B, a real click on Reserve Now → `POST /api/booking` **409**, the same body, then the error page. 1 booking stored. **The Fail is confirmed.** |

**What the re-checks add to the evidence:**
- **The server rejects invalid date ranges** (same day, reversed) **and overlaps with the same response: 409 and `{"error":"Failed to create booking"}`.** So:
  - BUG-02 is a **client-side** problem: the Price Summary shows negative or zero nights. No invalid booking is stored.
  - Returning 409 (Conflict) for a validation error is questionable. 400 would fit better. This is a note for the PO and the developers, not a new candidate yet.
  - BUG-01's cause is now specific. The frontend reads `.length` from the error response, but this body has a single `error` string instead of a list of errors. That matches the console TypeError seen in TC-031.
- No verdict changed. The four provisional points from the review are now settled: TC-045, TC-009, TC-036/TC-048 linkage, and TC-033.
