# Peer review: runs/v5-run2.md (pass a)

- **Reviewer:** `peer-reviewer` subagent (.claude/agents/peer-reviewer.md), fresh context, Read tool only
- **Inputs given:** runs/v5-run2.md, reviewer/inputs/story-and-acs.md, reviewer/inputs/ui-map.md
- **Date:** 2026-11-24
- **Output below is unedited.**

---

## Review of /home/claude/ai-test-case-agent/runs/v5-run2.md

Sources used: /home/claude/ai-test-case-agent/reviewer/inputs/story-and-acs.md (AC1–AC12) and /home/claude/ai-test-case-agent/reviewer/inputs/ui-map.md. I opened no other files.

I recounted every piece of length-sensitive test data and it is correct: TC-006 (3/3/11), TC-007 (18/30/21), TC-008 (15/16, phone 16), TC-012/013/015/016/021/022 (2/19/2/31/10/22), TC-041 (28) and TC-043 (16). I also recomputed every price and they are correct, including −£410 in TC-025. The per-room date allocations do not overlap.

### 1. Comments table

| Case | Check # | Severity | Comment | Reason / evidence | Suggested fix | Confidence |
|---|---|---|---|---|---|---|
| TC-001, TC-037 | 7 | minor | Both cases link AC10, but neither tries to book dates that are already taken. TC-001 step 13 and TC-037 step 6 only show that the booking exists, which is evidence for AC1 and AC9. | AC10 is about a second booking being refused. TC-029, TC-030 and TC-031 are the cases that actually test it. | Remove AC10 from both, or mark it as "supporting evidence only". | high |
| TC-008 | 3 | major | Five risky inputs go into one booking: accents, apostrophe, hyphen, emoji and a +52 phone. If the booking is refused, or gets a Question under the Verdict rules, the tester can't tell which value caused it, and the other four are left without a result. | Test Data in TC-008. The Notes only cover a refusal that cites a content rule. | Split the case into one risky value per case (for example, accents and apostrophe in one, emoji in another, +52 phone in a third). Or add: "on rejection, re-run with one risky field at a time". | medium |
| TC-008 | 3 | minor | Step 4 only checks what the input fields show. The confirmation does not show the name (UI map: the panel shows only the dates), so a server that stores "Núñez 😀" garbled would still pass. Unlike TC-009 and TC-041, the Notes don't state this limit. | UI map, "On success…" line. TC-008 step 4 and Notes. | Add a note that stored values can't be checked without admin access, so this case only proves that the input is accepted. | high |
| TC-008 | 2 | minor | It doesn't say how to enter ñ, ú and the emoji. Testers on a UK or US keyboard will paste, use the OS emoji picker, or use dead keys, and each fires different input events. | Step 3: "type the test data". | Say "paste each value from the Test Data column", or name one input method. | medium |
| TC-012, TC-014, TC-015, TC-017, TC-018, TC-019, TC-020, TC-021 | 2 | major | "Same steps as TC-011" brings in TC-011 step 4, "leave Firstname empty", which contradicts these cases' data (Firstname Maria or Al). A tester who follows it literally leaves Firstname empty as well. That produces an extra Firstname error and a Fail on "no message for the other fields". In TC-014, TC-011 step 7 ("click into Lastname") also points at the field that is supposed to stay empty. | TC-011 steps 4 and 7 against the Test Data of each listed case. | Make TC-011 step 4 generic: "Type the test data exactly as listed; leave fields marked (empty) blank." Make step 7 "click into any non-empty field". | high |
| TC-012, TC-015, TC-021 | 8 | minor | "length message (3–18)", "(3–30)" and "(11–21)" can be read as "the message must state the range". A message like "Firstname is invalid" would then be failed, although the Verdict rules only require that the message names the field or problem. | Verdict rules, "Message wording". ACs give no wording. | Change to "a message about Firstname's length; the range need not be stated". | medium |
| TC-013, TC-016, TC-022 | 3 | minor | When the browser cuts the value at the maximum, the case is Pass and nothing is submitted. So server-side rejection of over-length values is never tested: a backend that accepts 19 characters would go undetected. The cases accept this, but the "Not covered" section does not list it. | Verdict rules, truncation clause. Step 5 of TC-013. | Add the limit to "Not covered" (it needs API access, such as Postman, which is outside the suite's scope). | medium |
| TC-023 | 2 | minor | If a browser "required" bubble blocks step 3, it names only one field. The title "shows every error" and the step 4 expectation (one message per field) can't be met, and the Notes don't say whether steps 5–7 still run. | Notes: "record it and apply the Verdict rules". | Add: "If a bubble appears, record which field it names, mark step 4 Pass under the Verdict rules, and continue with steps 5–7." | medium |
| TC-024, TC-025, TC-026, TC-034, TC-035 | 2 | major | It is unclear where the date-error message should appear. TC-024 says the red error box, and marks that as an assumption. TC-025, TC-026, TC-034 and TC-035 give no location. The Verdict rules say a message passes "if it appears where the case says", so with no location, testers will judge a toast, an alert() or text under the calendar differently. | Verdict rules, "Message wording". UI map: the red box is described only for "Validation errors". | Say in each case which locations are accepted, for example "red error box or any visible message in the Book This Room panel". | high |
| TC-027, TC-038 | 7 | minor | Both cases link AC1, but they open the room URL directly and never use the home page dates. | AC1: "Dates chosen on the home page…". Step 1 of each case. | Remove AC1. TC-038 is covered by AC12 and AC2. | high |
| TC-027 | 6 | minor | There is no availability precondition for Single D−10→D−8. If another user already booked those dates, a "not available" refusal will be recorded as a Question about past dates. | Preconditions only say "record time and time zone". The Verdict rules' Blocked rule relies on an availability check. | Record the exact refusal text. If it says the dates are taken rather than in the past, mark the case Blocked and shift the dates. | medium |
| TC-028 | 8 | major | The 23:00–01:00 exclusion uses the device's local time, but the Notes admit the server may use UK time. A tester far from UK time (for example UTC−6 in the evening) has a device "today" that is already yesterday in the UK for hours. A refusal for "past date" would then be recorded as a Question about same-day bookings. Step 2 ("Check In is D") also assumes the prefill uses the device date. | TC-028 Notes. Verdict rules: the time zone definition is an assumption. UI map: prefilled with "today", source not stated. | Also exclude a window around UK midnight, and record UK time next to local time. Mark the prefill source as needing verification in the app. | medium |
| TC-029, TC-030, TC-031 | 6 | minor | Each case first makes its own setup booking (TC-029 step 2, TC-030 step 1, TC-031 step 3). If that booking fails, the case is recorded as Fail against AC10, although the defect is AC9. TC-030 step 1 also packs three actions into "Book with set A". | Steps as cited. Verdict rules don't cover a failed setup step. | Add: "If the setup booking is not confirmed, record Fail under AC9 and mark the AC10 check Blocked." Spell out the three actions in TC-030 step 1. | medium |
| TC-032, TC-039 | 2 | major | "Wait for the panel to settle" (TC-032) and "wait for the reload" (TC-039) have no time limit. The Verdict rules' 30-second rule for endless loading applies only without throttling, so under Slow 3G testers will disagree on when a spinner counts as endless loading (Fail). | Verdict rules, Fail definition ("…without throttling"). | Give an explicit limit under throttling (for example 120 s). Or switch throttling off after the click and apply the 30 s rule. | high |
| TC-034, TC-035 | 3 | minor | The TC-034 Notes say any default booking would be D→D+1 on Suite, but no step checks that range. Neither case ends with an availability check, so a booking created in the background while an error is shown would slip through. | TC-034 Notes ("If a defect books default dates…"). No availability-check step in either case. | Add a precondition and a final availability check for D→D+1: Suite in TC-034, Single in TC-035. Expect the room to be listed. | high |
| TC-036 | 3 | major | "A clear message that the room can't be found" and "No error page" conflict. A branded "404 – Room not found" page from the app can be read as either one, so testers can reach opposite verdicts. No AC covers room IDs that don't exist, and the AC12 link doesn't fit. | Expected Result of TC-036. AC12 covers dates, not invalid room IDs. | Define Pass as "an app page that says the room doesn't exist and offers navigation". Define Fail as "a browser or server default error, a stack trace, a blank page, or a booking form". Change the AC link to "none (assumption)". | high |
| TC-037 | 2 | major | The "previous page" is not defined. Depending on browser history, Back lands on the home page or on the room page, and the room page may still show the filled form. The case gives no expected landing page and doesn't say what to do if the filled form reappears. Step 2's expected result (£340) also has no matching "read Price Summary" action. | Steps 2 and 4–5. The UI map doesn't say whether confirmation changes the URL or history. | State the expected landing page, or have the tester record it. Add: "if the filled form is shown, click Reserve Now once and expect a 'not available' message". Add "Read Price Summary" to step 2. | medium |
| TC-040 | 2 | minor | Step 6 assumes the form keeps its values after the offline failure. If the fields are cleared, testers will either retype or click with empty fields, and get different results. | Step 6. | Add: "If any field is empty, retype the test data first, and record that the values were lost." | medium |
| TC-041 | 3 | major | Step 4 runs Ctrl+F for "onerror" in the Elements panel, which also matches text nodes and attribute values. If the app correctly shows the name as escaped text, or an input's value attribute still holds the string, the tester may mark Fail. Also, once "Booking Confirmed" replaces the form, the name is not on the page at all (the admin area is out of reach), so step 4 checks almost nothing. | UI map, success panel shows only dates. Expected Result "no img element with an onerror attribute". | Say "Fail only if the match is an `<img>` element node with an onerror attribute; text matches are Pass". Run the search before submitting, while the form is filled, and again after. | high |

### 2. Suite-level findings

**Coverage gaps**
- **AC12, other routes to the room page (applies).** The UI map lists the top navigation (Rooms, Booking) and the room-page breadcrumb (Home / Rooms). No case reaches a room page through them, or returns home through the breadcrumb and checks the dates.
- **AC4/AC5, names made only of spaces (applies).** TC-009 covers spaces around a name. "   " (3 spaces) or a mix like " A " could count as "present" and wrongly pass the required and length checks.
- **AC6, other invalid formats (applies).** Only a missing "@" (TC-018) and a missing local part (TC-019) are tested. Not tested: "maria@" (no domain), "maria@example" (HTML5 accepts it, so the result would be a Question), two "@", and spaces inside the address.
- **AC7, what Phone may contain (applies, as a Question).** Only length is tested. 11 letters, or a mix of digits and letters, is not tried.
- **AC10, back-to-back stays (applies).** TC-030 avoids them on purpose, but no case records the behaviour as a Question. Overlap shapes are also missing: a new range that fully contains an existing one, or one that shares the same end date.
- **AC2, longer stays (applies, minor).** The longest stay tested is 3 nights. A stay of 14 nights or more, or one across a month boundary with more nights, would catch errors in counting nights.
- **AC11 on the home page with same-day dates (applies, minor).** Zero-night stays are tested only through the URL (TC-026), not from the home page date fields.
- **Very long Email (applies, as a Question).** No AC limits Email length, so a 255+ character address is untested.

**Conditions**
- **Slow or dropped network (applies, covered).** TC-032, TC-039 and TC-040. There is no time limit under throttling (see comment above).
- **Backend errors (does not apply, as the suite states).** DevTools can't make the server return a 5xx without a proxy tool. Whether Chrome's response override feature could do it needs verification in the app.
- **Time of day and time zones (applies, partly covered).** TC-028 covers only device midnight, not UK midnight. The Verdict rules also don't say whether D stays fixed when a run goes past midnight. Later cases would then shift their dates by a day.
- **Two sessions on the same data (applies, partly covered).** TC-031 covers a stale tab, with one tab submitting after the other. Truly simultaneous submits can't be done reliably by hand.
- **Refresh or Back during and after submit (applies, covered).** TC-037, TC-038 and TC-039. Back while the submit is still in progress is not covered (minor).
- **Valid-looking but risky data (applies, covered).** TC-008, TC-009, TC-041 and TC-043. The open points are the multi-field mixing in TC-008, and the fact that stored values can't be seen (an admin limit).
- **Shared public demo data (applies).** Another user could book a success-case range between the precondition check and the final check, which would make "not listed" a false proof. The risk is low. The sources don't say whether the site resets its data periodically, which needs verification in the app.
- **"Cancel" behaviour and admin-side checks (do not apply).** No AC defines what Cancel does, and the tester has no admin credentials (UI map, Admin section).

### 3. Summary

- **Cases reviewed:** 43 (TC-001 to TC-043), plus the Verdict rules and the "Not covered" section.
- **Comments:** 19 rows.
- **By check:** #1: 0, #2: 7, #3: 6, #4: 0, #5: 0, #6: 2, #7: 2, #8: 2.
- **By severity:** blocker 0, major 8, minor 11.
- **Second pass on checks 1–3:**
  - No duplicates. TC-029 and TC-031 differ in a way that matters: one reloads the page after the first booking, the other uses a page loaded before it. TC-018 and TC-019 test different parts of email validation. TC-035 and TC-042 overlap only in the check for dates that can't be read.
  - No UI claims without a source. The red box for date errors is already marked as an assumption in TC-024.
  - No unusable test data.
- **What I could not check, and why:**
  - Whether the Check In/Check Out prefill and the "today" rule use the device's time zone or UK time.
  - Whether confirmation adds a history entry, which decides where Back goes in TC-037.
  - Whether the inputs have maxlength or type=email attributes, which decides whether the truncation and bubble branches happen at all.
  - Whether the demo data resets periodically.

  All of these need verification in the app, which I can't access.
