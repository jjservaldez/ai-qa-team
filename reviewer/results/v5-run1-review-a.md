# Peer review: runs/v5-run1.md (pass a)

- **Reviewer:** `peer-reviewer` subagent (.claude/agents/peer-reviewer.md), fresh context, Read tool only
- **Inputs given:** runs/v5-run1.md, reviewer/inputs/story-and-acs.md, reviewer/inputs/ui-map.md
- **Date:** 2026-11-24
- **Output below is unedited.**

---

## Peer review: v5-run1, 45 cases plus the verdict rules

Inputs read: the test cases (/home/claude/ai-test-case-agent/runs/v5-run1.md), the story and ACs (/home/claude/ai-test-case-agent/reviewer/inputs/story-and-acs.md) and the UI map (/home/claude/ai-test-case-agent/reviewer/inputs/ui-map.md). I opened no other files.

### 1. Comments table

| Case | Check # | Severity | Comment | Reason / evidence | Suggested fix | Confidence |
|---|---|---|---|---|---|---|
| Verdict rules, decision 1 | 8 | major | Decision 1 says a check is Pass when maxlength cuts a typed value "down to a valid one". Read literally, this also covers a valid value cut by a maxlength that is too small, for example a 30-char Lastname cut to 20. That cut is a defect, but the rule calls it Pass. TC-009 step 4 says "no value is cut", and decision 1 "applies to every case", so two testers can give opposite verdicts. | Decision 1 vs. TC-009 step 4 and AC4/AC5/AC7 (the max lengths are valid). | Limit decision 1 to values that are invalid as typed. State that cutting a value that is valid as typed is Fail. | medium |
| Verdict rules, Blocked + all AVAIL preconditions | 3 | major | Every failed AVAIL precondition is Blocked, which blames "someone else". An availability-filter defect that hides a free room would therefore be logged as Blocked and never as a defect. There is also no rule for picking replacement dates, so testers will improvise different dates or stop. | Blocked definition. UI map: "Our Rooms… lists only the rooms available". Admin is not accessible, so the cause can't be confirmed. | Add a fallback: shift all of the case's dates by a fixed offset (for example +7) and retry once. If the room is still not listed, open the room URL and try to book. A clean AC10 rejection confirms Blocked; a confirmation means the filter is wrong (Fail). | medium |
| Suite, date allocations | 5 | major | The allocations are relative to the execution day (D+n). Bookings made in one run stay on the shared demo, so a rerun or retest on a later day collides with them. Example: a run on day X books Single X+40→X+43, and TC-001 on day X+1 needs Single X+41→X+44, so it is Blocked. Almost every booking case overlaps the previous day's run. | Notation "D+n"; CONF step 3 proves bookings persist; no admin access to delete them. Whether the demo resets its data is not in the sources. | Anchor allocations to a fixed run-start date recorded once per cycle, or add a per-run offset. Say how retests choose dates. | medium (needs verification of whether the demo resets data) |
| TC-002 (also TC-015, TC-045) | 7 | minor | These cases link AC1, but they enter dates through the room URL, not the home page. AC1 is about home-page dates. | AC1 wording; TC-002 steps 1–3, TC-015 step 1, TC-045 step 1. | Remove AC1 from these cases (TC-045 is calendar display, not AC1). | high |
| TC-003 | 2 | minor | "Payload shows José exactly as typed": DevTools "view source" can show `José`, which is a correct JSON escape. A tester using that view could mark Fail. | Step 5 + expected result. | Say to use the parsed Payload view, and that `\uXXXX` escapes are acceptable. | low |
| TC-006 | 2 | minor | Step 5 ("Click Reserve Now, type V, click Reserve Now") assumes the form closed on refresh. If the form and its values survive F5, the first click submits right away. Testers will do different things. | Step 5; the note says survival of typed values is not specified. | Add the branch: if the form is still open after F5, clear and retype V, then click Reserve Now once. | medium |
| TC-010 | 5 | minor | The case doesn't say how to enter the emoji (OS emoji picker, paste, or type). Pasting can skip the key events that client validation relies on. | Test data `Zoë 😀`. | Name the input method, for example the OS emoji picker (Win+. / Ctrl+Cmd+Space). | low |
| TC-018 | 6 | major | Step 3 clicks Book now on the Single card after Check Availability, but there is no AVAIL(Single, 2nd–11th of M) precondition. If any guest holds a night in that 9-night range, the card is missing and no Blocked path applies. Testers may then pick another room, mark Fail, or stop. | Preconditions: only "M = …"; UI map: the list shows only available rooms. | Add precondition AVAIL(Single, 02/M, 11/M) lists Single, else Blocked (plus the fallback rule above). | high |
| TC-019 | 6 | minor | Steps 3–5 ("Type Firstname Maria, clear Lastname…") assume that a failed submit keeps the entered values. If the form resets, testers will either retype everything or leave other fields empty, and R2 ("names only the emptied field") then gives different results. | Steps 3–5; value retention after an error is not in the UI map or the ACs. | Add: "Before each submit, make sure every field except the one under test holds its V value." | medium |
| TC-024 | 3 | major | R2 requires the message to say Firstname is "required or missing". If the app trims the value and reports a length error ("size must be between 3 and 18"), that is a clean, correct rejection, but a literal tester marks it Fail. | Expected result; AC4 sets both rules (required and 3–18). | Change R2 to "names Firstname (required or length)". | medium |
| TC-025 (also TC-026, TC-027) | 8 | minor | The expected R2 text "dates are unavailable / already booked" is an assumption, but it is not labeled as one. The ACs give no message text, and a generic "error" message could be marked Fail by one tester and Pass by another. | AC10 has no message; TC-019 labels its texts as assumptions but these cases do not. | Mark the text as an assumption and state the minimum: a message that refers to the dates or availability. | medium |
| TC-026 | 6 | minor | If TC-026's second booking (Suite D+66→D+68) wrongly succeeds and the app treats the check-out day as booked, TC-005's Suite D+68→D+70 is Blocked through no fault of TC-005. | Allocations TC-026 / TC-005; the back-to-back assumption in TC-013. | Run TC-005 before TC-026, or move TC-005 so it doesn't border D+68. | low |
| TC-029 | 2 | major | Step 4 is conditional ("If a Single card… is shown"), but there is no branch for when no card is shown. If Check Availability just lists no rooms and shows no message, one tester stops and marks Fail. Another counts "no rooms" as the message, and a third opens the URL. | Steps 3–5; the expected result allows the message "at the latest in the red box after step 5". | State it: if no card is shown and no message names the date rule, the verdict is Fail; an empty room list alone is not the clear message. | medium |
| TC-032 | 8 | minor | R2 expects "past dates can't be booked". On the shared demo the past range may already be booked, so a rejection could be an AC10 rejection, and the case doesn't say what verdict that gets. It also links AC1/AC9, but the behavior is an assumption that no AC covers (decision 3). | Expected result; decision 3; no AVAIL is possible for past dates. | Record the message. Any clean rejection is Pass/Question per decision 3. Change the AC link to "none (assumption)". | medium |
| TC-033 (also TC-034, TC-041) | 2 | minor | "The panel asks the user to select dates": the UI map shows no way to pick dates on the room page. If the app redirects to the home page date fields instead, testers will disagree on whether that meets "the panel asks". | UI map room page (the calendar only shows the "Selected" bar); AC12 "asks the user to select them". | Accept either a message in the panel or a redirect to the home page date fields; anything else is Fail. | medium |
| TC-036 | 8 | major | The rules contradict each other. Decision 4 defines endless loading (Fail) as "no visible result after 10 s", and step 4 waits exactly 10 s. The note says "no visible feedback at all is Question". The same observation gets Fail from one tester and Question from another. | Decision 4; TC-036 step 4 and note. | Pick one. For example: nothing visible after 10 s = Fail (decision 4), and a clean message other than the expected one = Question. | high |
| TC-037 | 3 | major | Realistic defect: the interrupted request was stored, so the Suite is booked but the guest saw no confirmation (a silent booking). The case records AVAIL "for information only", so it still passes. | Note; AC9 (confirmation shown on a valid booking); CONF step 3 shows AVAIL is the agreed proof that a booking exists. | If the final AVAIL no longer lists the Suite while the reloaded page shows no confirmation, record it as Question with the request status, not just as information. | medium |
| TC-038 | 8 | minor | The expected result requires that Back shows the home page. The panel swap is not a page navigation, so Back may land elsewhere (for example the room page or the anchor). The case marks this an assumption, but decision 3 doesn't cover it, so testers will differ on Fail vs. Question. | Note "Assumption: Back returns to the home page"; UI map: the panel is replaced in place. | The core oracle is "no new booking request and no error page". Treat landing on a different page as Question. | medium |
| TC-039 | 3 | major | The Lastname is never rendered on the guest side, because the panel is replaced and the name shows only in admin (note). So steps 3–4 (alert, `img[onerror]` count) can't detect stored XSS, and the case passes even if admin is vulnerable. The title "stored as text" and the High priority claim more than the case checks. "Payload holds the Lastname as plain text" is also unclear if the client HTML-encodes it (`&lt;img…`). | Note; UI map: admin credentials are not provided. | Retitle it to what is checked (submit succeeds, no injection on the guest page, data not in the URL). Say whether an HTML-encoded payload is Pass, and list admin rendering as not covered. | high |
| TC-044 | 2 | minor | The pass conditions don't cover a Double page that shows no dates, no price and no prompt. Its only Fail example is "other dates without asking", so testers may disagree. | Expected result; AC12. | Add: no dates and no prompt is Fail. | medium |
| TC-045 | 4 | minor | Steps 4–5 expect "Today shows the current month" and "Back shows the previous month". The UI map lists the buttons but not what they do (unsupported, though plausible). | UI map: "calendar with Today / Back / Next buttons". | Mark the button behavior as an assumption. | medium |

### 2. Suite-level findings

**Coverage gaps**
- **AC1, applies.** No case types dates on the home page and then clicks Book now without clicking Check Availability, or uses Book now with the untouched defaults. Both are realistic paths where the room page could receive stale dates or the defaults.
- **AC12, applies.** Untested paths to a room page: the breadcrumb or top-nav "Rooms"/"Booking" links, and "Return home" followed by Book now on another room (are the old dates kept?). Covered paths: home Book now, direct URL, refresh, View Details.
- **AC8, applies.** No case submits with several invalid or empty fields at once to check that the red box lists every error. TC-019 tests one field at a time.
- **AC4–AC8 server-side enforcement, applies.** Decision 1 accepts browser blocking or maxlength as Pass, and no case gets past client validation. Ways to try it: remove `maxlength`/`required` in DevTools Elements, or use Edit and Resend if it is available. As written, "the booking is not created" (AC8) is only shown for the client layer.
- **AC6, applies.** There are no valid-but-unusual emails (plus addressing, an apostrophe, subdomains, uppercase). Under decision 2 a rejection of these would be Fail. There are also no invalid emails that the browser accepts (for example `maria@example`, or a trailing space), which are the ones that reach the app's own validation.
- **AC7, applies (product question).** Letters-only or 11+ symbols phone numbers are valid under AC7 as written, and decision 2 makes rejecting them Fail. No case tests this, so the conflict will surface during execution.

**Conditions**
- **Slow network, applies.** Covered by TC-028 and TC-037.
- **Dropped network, applies.** Covered by TC-036, but its verdict rule contradicts decision 4 (see the TC-036 comment).
- **Backend 5xx, does not apply with the tester's tooling.** I agree with the "Not covered" reasoning: DevTools can block a request but can't produce a server 5xx.
- **Time of day / time zones, applies (partly covered).** TC-017 and TC-032 only record the time zone. No case runs near midnight, or with the device time zone set away from the UK server (for example UTC−10), to check the prefilled "today" and same-day/past handling. Needs verification in the app.
- **Two sessions on the same data, applies.** Covered by TC-027.
- **Refresh/back during or after submit, applies (partly covered).** TC-006 covers before submit, TC-037 during and TC-038 Back after. Not covered: F5 after "Booking Confirmed" (resubmission, or a stale confirmation shown again).
- **Valid-looking data, applies (partly covered).** Names are covered (accents, apostrophe, emoji, symbols, spaces). Not covered: emails (see above) and very long pasted values (for example 1,000 characters) to check truncation or error handling beyond the +1 boundary.
- **Shared demo data reset, needs verification in the app.** The sources don't say whether the site resets bookings. That decides how serious the cross-day collision comment is.

### 3. Summary

- **Cases reviewed:** 45, plus the verdict rules and the shared notation.
- **Comments: 21.**
  - By check: #1 = 0, #2 = 5, #3 = 4, #4 = 1, #5 = 2, #6 = 3, #7 = 1, #8 = 5.
  - By severity: blocker 0, major 9, minor 12.
- **Duplicates:** none. Partial overlaps (the calendar bar in TC-007/TC-018/TC-045, AC3 in TC-001/TC-043) test different things.
- **Test data:** I hand-counted every stated length (TC-004, 008, 009, 020, 021, 022, 039, 040, 042) and every price total. All of them are correct.
- **What I could not check:**
  - The booking request's name and payload fields, and whether the error box echoes input (needs the running app).
  - Whether the room page lets users pick dates.
  - Whether Chrome's address bar handles the unencoded `<img …>` URL in TC-041 as written.
  - Whether the demo resets its data.
  - Anything shown only in admin: stored names and server-side booking count.
