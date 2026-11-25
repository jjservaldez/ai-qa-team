# Execution results: Smoke suite, 2026-11-25

## Environment
- App: restful-booker-platform, local copy, commit `efe2deb8ce02db541adbf9d3a6604caf5fbdaae6` (2026-10-23), served at http://localhost:3003. Started with `run_locally.sh` (no end-to-end tests, so data starts clean).
- Health check at 16:14 CST: `/api/room/1,2,3` returned 200, `/api/report/room/1` returned 200. Data: 3 rooms (Single £100, Double £150, Suite £225) and one sample booking in room 1, 2026-02-01..05.
- Browser: Claude desktop browser pane, viewport 1280×900.
- Executor: Claude agent driving the browser. Run window: 16:24:21 to 16:28:05 CST (3 min 44 s).
- The test cases were written for the public demo. The executor replaced `https://automationintesting.online` with `http://localhost:3003` in every URL, and changed nothing else.

## Method used by the executor
- Date fields on the home page: real click, then typed text, then Escape.
- Buttons and links: real clicks.
- Form fields: filled with the browser tool's form-fill action, which sets the value directly instead of sending keystrokes.
- Results were read from the page text and DOM: alert text, URL, panel text, and the calendar bar's position and width.
- Screenshots were taken for TC-001 (calendar and confirmation) only.
- After the run, the executor queried `/api/report/room/{id}` and `/api/room?checkin…&checkout…` to compare stored bookings with what the UI showed.

## Verdict rules used
- **Pass:** the application behaves as the expected result says.
- **Fail:** the application contradicts the expected result for behavior an AC requires, or shows an error page, crash or endless loading.
- **Blocked:** the case can't be executed for an environment reason.
- **Question:** the behavior differs from the expected result, but no AC covers it. The case's main checks are recorded separately.
- **Wording-only differences** (added after the review, QA lead decision): a difference only in wording, outside what the case verifies (for example "1 nights" instead of "1 night"), keeps the verdict and is recorded as a note.
- **No composite verdicts** (added after the review): each case gets one of Pass, Fail, Blocked or Question.
- **AC8 clarified** (QA lead decision, 2026-11-25): "an error message is shown for each invalid field, and each message identifies the field it refers to." Before, AC8 said only "error messages are shown", so BUG-05 wasn't tied to a specific AC.

## Data check after the run (API, not UI)
- Bookings created during the run: room 1: 2026-12-14..16, 2027-01-11..12, 2027-04-26..28. Room 2: 2027-02-01..03.
- That is 4 bookings, one for each "Booking Confirmed" seen. TC-019 and TC-029 created none.
- `/api/room?checkin=2026-12-14&checkout=2026-12-16` returned rooms 2 and 3 (room 1 excluded). For 2027-07-01..03 it returned rooms 1, 2 and 3.

---

## TC-001: Book a Single room end to end with dates chosen on the home page
- **Priority:** High
- **Preconditions:** Browser open. Single room free for 14/12/2026–16/12/2026.
- **Steps:**
  1. Open the home page.
  2. In "Check Availability & Book Your Stay", set Check In and Check Out to the test data dates.
  3. Click "Check Availability".
  4. In "Our Rooms", click "Book now" on the Single card.
  5. Check the URL in the address bar.
  6. In the "Book This Room" panel, click "Next" until December 2026 and check the calendar.
  7. Check the Price Summary.
  8. Click "Reserve Now".
  9. Type the contact data into Firstname, Lastname, Email and Phone.
  10. Click "Reserve Now" again.
  11. Check the "Book This Room" panel.
- **Test data:** Check In 14/12/2026, Check Out 16/12/2026, Maria / Gonzalez / maria.gonzalez@example.com / +523312345678
- **Expected result:**
  - Step 4: "Our Rooms" lists the Single card.
  - Step 5: the URL is …/reservation/1?checkin=2026-12-14&checkout=2026-12-16.
  - Step 6: the December calendar shows the "Selected" bar on 14 and 15 December, and not on other days.
  - Step 7: the Price Summary shows £100 × 2 nights = £200, Cleaning fee £25, Service fee £15, Total £240.
  - Step 8: a form with Firstname, Lastname, Email, Phone and a "Cancel" button appears.
  - Step 11: the panel is replaced by "Booking Confirmed", the text "Your booking has been confirmed for the following dates:", 2026-12-14 - 2026-12-16 and a "Return home" button. No red error box and no error page.
- **Result:** Question (CAND-10). Main flow (steps 4, 5, 7, 8, 11): Pass
- **Actual result:**
  - Steps 4, 5, 7, 8 and 11 went as expected: the URL matched; the Price Summary showed £100 x 2 nights = £200, £25, £15, Total £240; the form and "Cancel" appeared; "Booking Confirmed" showed 2026-12-14 - 2026-12-16 with "Return home"; there was no red box.
  - Step 6: the "Selected" bar on the December calendar covers 14, 15 and 16 December. The check-out day is included, not only the two nights.
- **Evidence:**
  - Screenshots of the calendar (bar across 14–16) and of the "Booking Confirmed" panel.
  - Bar position read from the DOM: it starts at the 14th and is 3 day-cells wide.
- **Bug ID:** CAND-10
- **Executed on:** 2026-11-25 16:24:21–16:25:25 CST · agent (browser pane) · local copy
- **Notes:** The step 6 oracle says only 14 and 15 should be marked. No AC says whether the check-out day should be shaded, so this needs the PO's answer before it is reported. The main flow passed. The verdict was first recorded as "Fail (step 6 only)" and changed to Question after the same calendar behavior showed up in two Regression cases.

## TC-003: Price Summary is correct for a 3-night Suite stay
- **Priority:** High
- **Steps:**
  1. Open the home page.
  2. Set Check In and Check Out to the test data dates.
  3. Click "Check Availability".
  4. Click "Book now" on the Suite card.
  5. Check the URL and the Price Summary in the "Book This Room" panel.
- **Test data:** Check In 07/12/2026, Check Out 10/12/2026
- **Expected result:** URL is /reservation/3?checkin=2026-12-07&checkout=2026-12-10. Price Summary: £225 × 3 nights = £675, Cleaning fee £25, Service fee £15, Total £715. The night count is exactly 3, not 4.
- **Result:** Pass
- **Actual result:** URL /reservation/3?checkin=2026-12-07&checkout=2026-12-10. Price Summary: £225 x 3 nights = £675, £25, £15, Total £715.
- **Evidence:** Page text captured.
- **Executed on:** 16:25:25–16:25:50

## TC-004: First click on "Reserve Now" shows the form and "Cancel" without booking
- **Priority:** High
- **Preconditions:** Open in the address bar: …/reservation/1?checkin=2026-12-21&checkout=2026-12-23
- **Steps:**
  1. Check the "Book This Room" panel before clicking.
  2. Click "Reserve Now" once.
  3. Check the panel.
- **Test data:** None
- **Expected result:**
  - Step 1: no form fields are visible, and "Reserve Now" is visible.
  - Step 3: empty Firstname, Lastname, Email and Phone fields and a "Cancel" button appear in the panel. "Reserve Now" is still visible. No "Booking Confirmed" and no red error box. The Price Summary still shows £100 × 2 nights = £200, £25, £15, Total £240.
- **Result:** Pass
- **Actual result:**
  - Before the click: no form fields, only "Reserve Now".
  - After one click: empty Firstname, Lastname, Email and Phone fields and "Cancel" appeared; "Reserve Now" was still visible; no "Booking Confirmed" and no red box; Price Summary £200, £25, £15, Total £240.
- **Evidence:** DOM check before and after the click.
- **Executed on:** 16:25:50–16:26:03

## TC-006: All fields at their minimum valid length are accepted
- **Priority:** High
- **Preconditions:** Open in the address bar: …/reservation/1?checkin=2027-01-11&checkout=2027-01-12
- **Steps:**
  1. Check the Price Summary.
  2. Click "Reserve Now".
  3. Type the test data.
  4. Click "Reserve Now".
  5. Check the panel.
- **Test data:** Firstname Ana (3), Lastname Lee (3), Email a@b.co, Phone 01234567890 (11)
- **Expected result:**
  - Step 1: £100 × 1 night = £100, £25, £15, Total £140.
  - Step 5: "Booking Confirmed" with 2027-01-11 - 2027-01-12. No red error box.
- **Result:** Pass
- **Actual result:** Price Summary £100 x 1 nights = £100, £25, £15, Total £140. "Booking Confirmed" with 2027-01-11 - 2027-01-12, no red box.
- **Evidence:** Page text captured.
- **Executed on:** 16:26:03–16:26:25
- **Notes:** Cosmetic: the label reads "1 nights" (plural). The amounts are correct.

## TC-008: Names with accents, apostrophe and hyphen are accepted
- **Priority:** High
- **Preconditions:** Open in the address bar: …/reservation/2?checkin=2027-02-01&checkout=2027-02-03
- **Steps:**
  1. Check the Price Summary.
  2. Click "Reserve Now".
  3. Type the test data.
  4. Click "Reserve Now".
  5. Check the panel.
- **Test data:** Firstname José, Lastname O'Brien-Núñez, Email jose.obrien@example.com, Phone +523312345678
- **Expected result:**
  - Step 1: £150 × 2 nights = £300, £25, £15, Total £340.
  - Step 5: "Booking Confirmed" with 2027-02-01 - 2027-02-03. No red error box, no garbled characters and no error page.
- **Result:** Pass
- **Actual result:** Price Summary £150 x 2 nights = £300, £25, £15, Total £340. "Booking Confirmed" with 2027-02-01 - 2027-02-03; no red box and no error page.
- **Evidence:** Page text captured.
- **Executed on:** 16:26:25–16:26:45
- **Notes:** The stored name is not visible in the UI, because the confirmation shows only the dates. It can be checked later through Admin.

## TC-019: Firstname with 2 characters is rejected
- **Priority:** High
- **Related bug:** BUG-05
- **Preconditions:** Open in the address bar: …/reservation/1?checkin=2027-06-01&checkout=2027-06-03
- **Steps:**
  1. Click "Reserve Now".
  2. Type the test data.
  3. Click "Reserve Now".
  4. Check the red box above the Price Summary, the form, the Price Summary and the URL.
- **Test data:** Firstname Al, Lastname Gonzalez, Email maria.gonzalez@example.com, Phone +523312345678
- **Expected result:** No "Booking Confirmed". The red box shows exactly one bullet, about Firstname length (3–18), and the bullet names the field ("Firstname"). The form fields are still shown and editable, "Reserve Now" can still be clicked, and there is no error page. The URL is unchanged. Price Summary: £100 × 2 nights = £200, £25, £15, Total £240.
- **Result:** Fail
- **Actual result:** No "Booking Confirmed". The form stayed editable, "Reserve Now" stayed enabled, the URL was unchanged, and the Price Summary showed £200, £25, £15, Total £240. The red box showed one bullet, "size must be between 3 and 18", which does not name the field.
- **Evidence:** Alert text read from the DOM.
- **Bug ID:** BUG-05
- **Executed on:** 16:26:45–16:27:05
- **Notes:** Known bug, reproduced on the local copy.

## TC-029: Submitting with all fields empty shows an error per field and creates no booking
- **Priority:** High
- **Related bug:** BUG-05
- **Steps:**
  1. Open in the address bar: …/reservation/1?checkin=2027-07-01&checkout=2027-07-03.
  2. Click "Reserve Now".
  3. Leave all fields empty and click "Reserve Now".
  4. Check the red box, the form and the Price Summary.
  5. Click "Home" in the breadcrumb.
  6. Set the test data dates and click "Check Availability".
  7. Check "Our Rooms".
- **Test data:** Check In 01/07/2027, Check Out 03/07/2027
- **Expected result:**
  - Step 4: no "Booking Confirmed". The red box lists errors for Firstname, Lastname, Email and Phone, and each message names its field. A message without a field name (for example "must not be empty") fails. The form is still usable, there is no error page, and the Price Summary shows £200, £25, £15, Total £240.
  - Step 7: the Single card is still listed, because no booking was created.
- **Result:** Fail (step 4)
- **Actual result:**
  - Step 4: no "Booking Confirmed"; the form stayed usable; Price Summary £240. The red box showed 7 messages: "size must be between 11 and 21", "size must be between 3 and 18", "Firstname should not be blank", "size must be between 3 and 30", "Lastname should not be blank", "must not be empty", "must not be empty". 5 of the 7 don't name a field.
  - Step 7: the Single card was still listed for 01–03/07/2027, so no booking was created.
- **Evidence:** Alert text read from the DOM. `/api/report/room/1` shows no booking for 2027-07-01.
- **Bug ID:** BUG-05
- **Executed on:** 16:27:05 to about 16:27:45
- **Notes:** Known bug, reproduced on the local copy. The breadcrumb "Home" link the executor clicked had href "/". The page also has a second "Home" link with href "#".

## TC-043: "Return home" button after confirmation
- **Priority:** Medium
- **Preconditions:** Single free for 2027-04-26 to 2027-04-28.
- **Steps:**
  1. Open …/reservation/1?checkin=2027-04-26&checkout=2027-04-28.
  2. Click "Reserve Now", type the test data, and click "Reserve Now".
  3. Click "Return home".
  4. Check the URL and the page.
- **Test data:** Maria / Gonzalez / maria.gonzalez@example.com / +523312345678
- **Expected result:**
  - Step 2: "Booking Confirmed" with 2027-04-26 - 2027-04-28.
  - Step 4: the URL is the site root (…/). The home page shows the navigation, the availability section and "Our Rooms", with no error.
- **Result:** Pass
- **Actual result:** "Booking Confirmed" with 2027-04-26 - 2027-04-28. "Return home" led to http://localhost:3003/, which showed the navigation, the availability section and "Our Rooms", with no error.
- **Evidence:** Page text captured.
- **Executed on:** 16:27:45–16:28:05

---

## Changes after the peer review (2026-11-25 16:49, QA lead triage)
- **TC-001:** "Pass – step 6 = Question" → **Question (CAND-10)**. The main flow is recorded as Pass, following the no-composite rule.
- **TC-006:** stays **Pass**, under the wording-only rule; "1 nights" is recorded as a note.
- **TC-019, TC-029:** stay **Fail**. AC8 was clarified, so BUG-05 now breaks AC8.
- **TC-029:** Email check settled (see the review file). Every field gets a message, so there is no new candidate.
- **TC-008:** stays **Pass** for acceptance. Whether the stored name is garbled is **not verified**: the UI shows only dates and the run had no admin access.
- **Method for later runs:** type real keystrokes where the input itself is under test (accents, emoji, spaces, script or SQL text); store evidence for each oracle point; write down the method per case when it differs from the written steps.
