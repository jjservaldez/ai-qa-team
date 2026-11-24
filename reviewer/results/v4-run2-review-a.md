# Peer review: runs/v4-run2.md (pass a)

- **Reviewer:** `peer-reviewer` subagent (.claude/agents/peer-reviewer.md), fresh context, Read tool only
- **Inputs given:** runs/v4-run2.md, reviewer/inputs/story-and-acs.md, reviewer/inputs/ui-map.md
- **Date:** 2026-11-24
- **Output below is unedited.**

---

I reviewed all 46 cases in /home/claude/ai-test-case-agent/runs/v4-run2.md against the ACs in /home/claude/ai-test-case-agent/reviewer/inputs/story-and-acs.md and the UI map in /home/claude/ai-test-case-agent/reviewer/inputs/ui-map.md. I opened no other files. I found 21 comments: 3 blockers, 10 major, 8 minor.

The biggest problems:
- **Three cases would pass a real defect:** TC-030, TC-034 and TC-042.
- **The negative-case template is ambiguous:** TC-017 to TC-023 say "Same steps as TC-013", and TC-013 step 3 says to leave Firstname empty.
- **Truncation note contradicts the expected result:** in TC-015, TC-018 and TC-023, if the field stops input at the limit, the note says Pass but the expected result says Fail.
- **Positive cases assume the dates are free:** the suite never checks this on a shared, persistent environment.

### 1. Comments table

| Case | Check # | Severity | Comment | Reason / evidence | Suggested fix | Confidence |
|---|---|---|---|---|---|---|
| TC-001 | 2 | minor | Step 2 says "type" the dates, but the fields are date pickers. The case doesn't say what to do if typing is blocked or reformatted. | UI map line 5: "format DD/MM/YYYY, date picker". Same wording in TC-013 step 5, TC-032 and TC-038. | Say "type in the field; if typing is not accepted, pick the dates in the date picker", and record which one was used. | low (needs verification in the app) |
| TC-001 | 5 | minor | The May/July fallback (8th–10th) changes every expected value, but steps 4, 6 and 9 hard-code -05/-07 and "starts on the 5th". The note also says the dates are always at least D+35. They can be D+33 (run on 31 Jan in a non-leap year, check-in 5 Mar). There is no collision, because other Room 1 cases start at D+80, so the range claim is just wrong. | TC-001 Notes vs. Expected steps 4, 6 and 9. | Write the expected values as "check-in day / check-out day from Test Data", not literal 05/07. Fix the range claim to D+33–D+70. | high |
| TC-002, TC-004, TC-005 | 7 | minor | They are linked to AC1 (dates chosen on the home page), but all three open the room URL directly. The home page is never used. | AC1 text. Step 1 of each case. | Remove AC1. Keep AC12 (TC-002) or AC9/AC2. | high |
| TC-004 | 6 | major | "First 30 Dec at least 150 days out" gives 30 Dec 2027 when run today (D+401), which is past TC-005's D+365. If a booking horizon exists (TC-005 only assumes there is none), TC-004 fails for a reason unrelated to the year boundary. Also, step 4 ends on the January view, but the expected result "starts on 30 Dec" can only be seen in the December view before the last Next. | TC-004 step 1. TC-005 Notes ("no maximum booking horizon" is an assumption). | Use a threshold that gives the nearest 30 Dec with no Room 2 collision, or make TC-004 depend on TC-005's result explicitly. Split step 4 into "December view: bar starts on the 30th" and "January view: bar continues". | medium |
| TC-006 | 6 | major | The case books the home page's default dates (today to tomorrow) on Double. Those are the dates every visitor to the public demo gets by default. Nothing checks that Double is free first, so a pre-existing booking would show up as a false Fail at step 5. | UI map line 5: prefilled with today and tomorrow. Step 1 says not to click "Check Availability". | Before step 1, run "Check Availability" for D→D+1 in a separate tab and confirm Double is listed. If it isn't, mark the case blocked, not failed. | low (needs verification in the app) |
| TC-015, TC-018, TC-023 | 2 | major | The note says "if the field stops input at 18/30/21 characters, that counts as Pass". But the tester then submits a value that is now valid. That gives "Booking Confirmed" and the Suite card not listed, which the inherited expected result (TC-013: no confirmation, Suite listed) calls a Fail. It also creates an unplanned booking. | TC-015/TC-018/TC-023 Notes vs. "Same as TC-013". | Add: "If the field truncates, record the stored length and stop before submitting (Pass). Otherwise submit and apply the TC-013 expected result." | high |
| TC-017 to TC-023 | 2 | major | "Same steps as TC-013." includes TC-013 step 3 "leave Firstname empty", but Test Data gives Firstname `Maria`. Testers who follow the steps literally get two errors, and the expected "error about X only" fails. TC-014–TC-016 say "with the data below", which partly avoids this. TC-017–TC-023 do not. | TC-013 step 3. Steps column of TC-017–TC-023. | Make TC-013 step 3 generic: "Fill in exactly the Test Data; leave empty only the field marked empty." | high |
| TC-025 (also TC-029) | 4 | minor | "The booking request has a 4xx status" (TC-025) and "at most one 2xx booking response" (TC-029) are not supported: the sources say nothing about the API, its status codes or which request is "the booking request". | The UI map has no network/API information. | Label both as assumptions. Identify the request (method and path) once it has been seen in the app. | medium |
| TC-027 | 3 | major | Step 1 (booking A) has no expected result. If A is not created, B's confirmation in step 2 passes without testing back-to-back at all. Separately, the AC11 link is irrelevant: no check-out is before or equal to its check-in here. | Expected column covers step 2 only. AC11 text. | Add "Step 1: Booking Confirmed with [D+56] - [D+58]; if not, the case is blocked." Drop AC11. | medium |
| TC-030 | 3 | blocker | The step 2 oracle is "no negative number of nights and no negative amount". A summary showing NaN, "undefined", £0 or a silently swapped positive 2-night total passes as written. TC-034 lists those as broken values, but TC-030 doesn't. | TC-030 Expected step 2 vs. TC-034 Expected step 2. | State the expected summary, for example "no nightly total offered; no NaN/undefined/Invalid Date/£0/negative values". If unknown, list the forbidden values and mark the rest an assumption. | high |
| TC-031 | 2 | major | "No total offered for 0 nights as a bookable stay" is undefined. Is "£150 × 0 = £0, £25, £15, total £40" a Pass or a Fail? Testers will differ. The Notes assumption ("0 nights and no bookable total") doesn't settle it either. | TC-031 Expected step 2 and Notes. | Say explicitly whether a fees-only total (£40) is a Fail. Add the NaN/undefined list from TC-034. | high |
| TC-032 | 2 | major | The listed outcomes don't cover everything. (a) The picker auto-moves Check Out after Check In: is that a Pass? (b) Rooms are listed with no message: step 1/2 fail, yet step 3 "if reached" implies the flow is allowed to continue. The tester can't tell whether a correct rejection in step 3 rescues the case. | TC-032 Expected. AC11. | List the verdict for each outcome: message → Pass; picker block or auto-correct → Pass (record it); rooms listed with no message → Fail on AC11, then still run step 3 and record it. | medium |
| TC-033 | 7 | minor | It is linked to AC11 and AC1, but D-10→D-8 has check-out after check-in, and no AC covers past dates (the Notes say so). The trace overstates AC support. | AC1, AC11 text. TC-033 Notes. | AC column: "none (assumption)". Keep the note. | high |
| TC-034 | 8 | blocker | "No prompt but nothing broken = question for the PO" softens AC12. With no dates in the URL there are no selected dates to keep, so AC12 requires the page to ask for them. A missing prompt is exactly the defect AC12 targets, and this rule would not mark it Fail. It also contradicts the case's own step 2 expected result ("A prompt asks the user to select dates"). | AC12. TC-034 Expected step 2 vs. Notes. | Make "no prompt" a Fail per AC12. Keep only the prompt's wording and placement as assumptions. | medium |
| TC-035 | 6 | major | Suppose TC-034 hits the realistic defect (it silently defaults to today/tomorrow and books Room 1). Then TC-035, also on Room 1 with no usable dates, gets rejected as "unavailable" in step 3. That reads as "nothing booked" and passes, so the defect is hidden by TC-034's leftover booking. | TC-034/TC-035 both use /reservation/1. AC10 rejection. | Use a different room for TC-035, or require the step 3 rejection to be a date prompt, not an "unavailable" message. | medium |
| TC-036 | 7 | minor | The category is "Security", but this is a negative/robustness case. The "room not found" message or redirect isn't in the sources and isn't labeled as an assumption. Also, a styled 404 page is both a "room not found" message and an "error page", so the Pass/Fail line is unclear. | UI map has no unknown-room behavior. TC-036 Expected step 2. | Category: Negative. Label the expected result as an assumption. Define "error page" (for example a raw stack trace, blank page or server error text) as distinct from a handled not-found page. | medium |
| TC-038 | 2 | major | "The previous page loads" is undefined. The confirmation replaces the panel on the room page (UI map line 18), so Back may land on the room page or on the home page. Step 4 assumes the home page with the dates still filled in. If the home page reloads with the default today/tomorrow, the tester clicks "Check Availability" on the wrong dates and Single is listed, giving a false Fail. | UI map lines 5 and 18. TC-038 steps 3–4. | Name the expected page after Back (or record which one appears). In step 4, retype D+115→D+117 before clicking "Check Availability". | medium |
| TC-040 | 4 | minor | What "Cancel" does (hides the form, "Reserve Now" visible again, the next click reopens it without submitting) is not in AC3 or the UI map, and it is not labeled as an assumption. | AC3 and UI map line 16 only say a Cancel button is shown. | Mark the step 3/4 expected results as assumptions to confirm with the PO. | high |
| TC-041 | 8 | minor | It calls a silent failure a Fail and requires a "clear message", but the ACs say nothing about network errors. Only the wording is marked as an assumption, not the requirement itself. Step 5 also gives no dates for the availability check. | ACs have no network-error criterion. TC-041 Notes and step 5. | Label "a message is shown" as an assumption. Add D+95→D+97 to step 5. | medium |
| TC-042 | 3 | blocker | "Exactly one booking exists overall" can't be observed. After F5, the in-flight request usually shows as cancelled in the Network tab, with no status, even if the server saved it. If the server saves both requests, step 3 shows "confirmed", step 4 shows Suite not listed, and the "two 2xx responses" Fail rule never triggers. The double booking passes. | TC-042 Expected steps 3–4 and Notes. | State that one-vs-two bookings can't be checked from the guest UI. Mark it "needs admin verification" or move it to a case with admin access. Keep only the checks that can be observed (page state, no error page). | medium |
| TC-045 | 3 | major | Lastname is never shown in the guest flow (the confirmation shows only dates, UI map line 18), so "no alert dialog" passes whether or not input is escaped. A stored XSS in the admin view slips through. The Notes admit the admin view isn't covered, but the title says the script "is not executed". | UI map lines 18 and 22. TC-045 Notes. | Retitle to "guest flow does not execute script; admin rendering not covered", or mark that part blocked until admin access exists. | high |

### 2. Suite-level findings

- **Shared, persistent data and re-runs: applies.** The cases book fixed D+N windows and never clean up, and admin credentials are not available (UI map line 22). Running again on a later day overlaps the earlier run's bookings (for example, TC-007 D+80–82 run today vs. D+79–81 run tomorrow). Other public users can also hold the dates. Only TC-001 checks that a room is free before booking. Add a precondition to every positive and AC10 case: check availability first, and if the room isn't free, mark the case blocked, not failed.
- **AC6 (email format) coverage is thin: applies.** Only empty (TC-019) and missing "@" (TC-020) are tested. Missing: no domain (`a@`), no local part (`@example.com`), spaces, two "@", `a@b` (no TLD), and a valid-but-unusual address (plus-tag, subdomain).
- **AC8, several invalid fields at once: applies.** No case submits with all fields empty or several invalid, so it is never checked that the red box lists all the errors (UI map line 17: "bulleted list").
- **Whitespace-only names: applies.** TC-024 pads a 2-character name, but no case submits a Firstname or Lastname of only spaces (for example 3 spaces) against "required" (AC4/AC5). Leading and trailing spaces in Email and Phone are also untested.
- **Phone content: applies, ACs silent.** AC7 only gives a length. Letters-only (`abcdefghijk`, 11 chars) is untested. It should be a case marked as an assumption or a question for the PO.
- **AC10 overlap shapes: applies.** Only "new range starts inside an existing one" (TC-026) and "new check-in = existing check-out" (TC-027) are covered. Missing: a new range that encloses an existing one, a new range that ends inside one, and new check-out = existing check-in.
- **AC11 on the home page with equal dates: applies.** TC-031 tests equal dates through the URL only. There is no home page case with Check In = Check Out.
- **AC1, dates changed after "Check Availability": applies.** No case changes the dates after "Check Availability" and then clicks "Book now" without re-checking, to see which dates reach the room page.
- **AC12, other paths: applies.** Breadcrumb "Rooms", the top-nav "Rooms"/"Booking" links (UI map line 4) and refresh on the confirmation panel are not covered.
- **Slow network: applies, covered** (TC-029, TC-042).
- **Dropped network: applies, covered** (TC-041).
- **Backend errors: applies, partly covered.** The 4xx conflict is covered (TC-025, TC-028). The 5xx gap is declared in "Not covered", which is reasonable without a proxy.
- **Time of day and time zones: applies, partly covered.** TC-006 records local vs. UK date, and TC-033 records the time. The suite never says which time zone "D" is computed in. In Guadalajara (UTC-6), the UK date is a day ahead from 18:00 local time. That matters for TC-006 and TC-033 and for anything near D.
- **Two sessions on the same data: applies, covered** (TC-028). Two tabs are enough, since guests don't log in.
- **Refresh/back during or after submit: applies, mostly covered** (TC-038, TC-039, TC-042). Missing: F5 on the "Booking Confirmed" panel.
- **Valid-looking invalid data: applies, partly covered.** Accents and apostrophes (TC-009), emoji (TC-012), SQL/script text (TC-045, TC-046) are covered. Very long values (for example 1,000 pasted characters) are not; only limit+1 is tested.
- **Mobile/responsive layout: does not apply.** The story, ACs and UI map describe desktop only ("panel on the right"), with no mobile criteria.

### 3. Summary

- **Cases reviewed:** 46 (TC-001 to TC-046).
- **Comments by check (21 total):**

| Check | Comments |
|---|---|
| #1 Duplicates | 0 |
| #2 Ambiguous steps | 6 |
| #3 Weak oracle | 4 |
| #4 Unsupported UI claims | 2 |
| #5 Unusable test data | 1 |
| #6 Hidden dependencies | 3 |
| #7 Traceability and category | 3 |
| #8 Expected result vs. ACs | 2 |

- **Comments by severity:** blocker 3 (TC-030, TC-034, TC-042), major 10, minor 8.
- **Second pass on checks 1–3:** I found no duplicates.
  - TC-003 and TC-006 are both one-night Double bookings, but one goes through the direct URL in a future month and the other through the home page defaults on the same day.
  - TC-009 and TC-010 cover different phone characters.
  - I recounted every length claim (18/19, 30/31, 11/10, 21/22, 16, 18, 25, 11), and every price total. All are correct.
  - I checked date allocations per room: no overlaps inside the suite.

**What I could not check:**
- **Behavior in the running app** (needs verification in the app):
  - whether the date fields accept typed input;
  - whether the form fields have maxlength;
  - native vs. app-side validation;
  - what Cancel does;
  - the API request path and status codes;
  - whether the demo data is reset;
  - whether the default dates are already booked.
- **How names are stored.** For TC-009, TC-012, TC-045 and TC-046 I couldn't check whether names are stored correctly (accents, emoji, script text). The guest UI never shows them back and there are no admin credentials, so these cases can only fail on a crash or visible error.
