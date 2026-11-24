# Peer review: runs/v3-run2.md (pass a)

- **Reviewer:** `peer-reviewer` subagent (.claude/agents/peer-reviewer.md), fresh context, Read tool only
- **Inputs given:** runs/v3-run2.md, reviewer/inputs/story-and-acs.md, reviewer/inputs/ui-map.md
- **Date:** 2026-11-24
- **Output below is unedited.**

---

## Review of /home/claude/ai-test-case-agent/runs/v3-run2.md (46 cases)

I checked every case against /home/claude/ai-test-case-agent/reviewer/inputs/story-and-acs.md and /home/claude/ai-test-case-agent/reviewer/inputs/ui-map.md. I read no other files.

The four most important findings:
- **TC-029 is a blocker.** It can't detect a duplicate booking, which is the only thing it exists to test.
- **Negative cases don't check that no booking was created.** TC-011 to TC-022 never verify AC8's "booking is not created".
- **Assumed behaviour is written as expected results with no clear pass/fail rule.** This affects TC-018, TC-022, TC-027, TC-032, TC-033, TC-034 and TC-036.
- **Re-running the suite on the shared demo will fail.** Every confirmed booking permanently uses up its dates.

### 1. Comments table

| Case | Check # | Severity | Comment | Reason / evidence | Suggested fix | Confidence |
|---|---|---|---|---|---|---|
| TC-001 (also TC-003, TC-004, TC-046) | 5 | major | The fixed Next-click counts (5, 6, 16, 5) only work in the month the suite was written (Oct 2026). Run in Nov 2026 they are one click too many, so a tester who counts clicks lands on the wrong month and sees no "Selected" bar. | Run header: date 2026-10-19. UI map line 14: the calendar "always opens on the current month". | Drop the counts. Keep "click Next until <month year> is shown", or say the count depends on the run date. | high |
| TC-004 | 8 | minor | Step 5 says the bar "covers 28 and 29 February". It doesn't say whether the bar may also cover 1 March (check-out). TC-001 flags this as an assumption; TC-004 doesn't, so testers who see the bar on 1 March may score differently. | TC-001 Notes; the UI map doesn't say whether the check-out day is drawn. | Add the same assumption note as TC-001, or state the expected result for 1 March. | medium |
| TC-006 | 4 | minor | The expected "£2,100" assumes a thousands separator. The UI map shows no price format above three digits, so "£2100" could be marked Fail. | UI map lines 15 and 24. | Accept either format, or mark the format as an assumption. | low (needs verification in the app) |
| TC-011 (pattern for TC-011 to TC-022) | 3 | major | AC8 says an invalid booking "is not created". These cases only check that "Booking Confirmed" is absent. A defect that shows the red error box but still saves the booking would pass. Only TC-024 checks persistence, and only for email. Also, all of these cases use Double 2027-08-12 to 14, so one silently saved booking makes every later case fail with a misleading error. | AC8; TC-024 is the only case with a follow-up booking check. | Add a final step: home page, Check Availability 12/08/2027 to 14/08/2027, Double is still listed. Or give each case its own dates. | high |
| TC-013, TC-016 to TC-021 | 3 | major | Only TC-012 says "no other field errors". The others only require a message about the target field. A validator that flags every field, or the wrong extra field, would pass. | Compare the expected results of TC-012 and TC-013/TC-016 to TC-021. | Add "no message for the other three fields" to each. | medium |
| TC-015 | 5 | major | The 21-character phone "+52 (33) 1234-5678 99" contains spaces, parentheses and a hyphen. AC7 only defines length. If the app rejects non-digit characters, the case fails for a format reason and never tests the 21-character limit. | AC7; the Notes assume "spaces count". | Use a 21-character value made of "+" and digits only (for example "+" plus 20 digits). Keep the punctuation version as a separate format case. | medium |
| TC-018 | 2, 4 | major | The Notes accept a browser tooltip "only if the message is clear". The expected result requires the red box. Testers will score a tooltip differently, and "clear" is subjective. The UI map only describes the red box. | UI map line 17. | Choose one oracle: red box (per the UI map), or tooltip = Fail with a note for the PO. | high |
| TC-021 | 3 | major | This mirrors TC-015. A 22-character value with punctuation could be rejected by a format check while the length check is broken, so a length defect slips through unless the tester reads the message wording, which is itself assumed. | AC7; the TC-012 Notes say "Error text assumed". | Use 22 characters of "+" and digits only. | medium |
| TC-022 (also TC-027, TC-034) | 8 | major | The expected result states assumed behaviour as fact (trimmed → error). The Notes then say "If accepted, log as a question for the PO", which leaves no Pass/Fail rule. TC-027 ("confirm with PO if rejected") and TC-034 ("If booked, raise to PO") have the same problem. | AC4 says nothing about whitespace. AC10 says nothing about the check-out day. No AC covers past dates. | For each case, state which outcome means Pass, Fail or Blocked/Question. | high |
| TC-029 | 3 | blocker | The title promises "creates only one booking", but no step can detect two records. A race condition that saves two bookings shows one confirmation, and Double is unlisted either way. The Notes admit this. | Notes; UI map line 22 (no admin access). | Retitle and reduce the oracle to what the UI can show (one confirmation, no error). Or get admin/API access to count bookings. | high |
| TC-029 | 2 | minor | The success panel replaces the form, so the second click of the double-click may land on "Return home" and navigate away. Step 3's expected result doesn't cover that, so testers may score it differently. | UI map line 18. | State what happens if the second click lands on "Return home". | low (needs verification in the app) |
| TC-031 | 2 | major | Step 1 "Set" doesn't say whether to type or use the picker. The expected result accepts "the date picker prevents selecting it", so a tester using the picker passes without testing typed input. The "If a Book now is clicked" check isn't a step, so some testers will do it and others won't. | UI map line 5: the fields accept typing and a picker. | Say to type the dates. Add an explicit step: click "Book now" on Single and check the URL and Price Summary. | high |
| TC-032 | 3 | major | "No ... £40-only total shown as a valid price" and "page asks to select valid dates or shows a message" are subjective. If the summary shows 0 or -2 nights next to an active Reserve Now button, one tester fails it and another defers to step 3. The message behaviour isn't in the sources, and the Notes don't mark it as an assumption. | AC11 doesn't define the UI response. Notes are empty. | Write concrete fail conditions (any night count ≤ 0, or any total ≤ £40, means Fail) and mark the expected message as an assumption. | medium |
| TC-033 | 3 | major | The same problem as TC-032: "does not present 0 nights with a £40 total as bookable" is subjective. The message "Check Out must be after Check In" is unsupported and not marked as an assumption. | AC11; the UI map has no such message. | Same fix as TC-032. | medium |
| TC-034 | 7 | minor | It's linked to AC1 and AC11, but neither covers past dates. The Notes admit it's an assumption. | AC1, AC11. | Set the AC to "none (assumption)". | high |
| TC-036 | 8 | major | This oracle conflicts with TC-035. TC-036 passes if the page "shows clearly which dates are selected". Since the calendar always highlights today and draws a Selected bar, a silent today/tomorrow default passes TC-036, but TC-035 explicitly rejects it. With no dates in the URL there are no "selected dates", so AC12 requires the page to ask for them. | AC12; TC-035 expected result; UI map line 14. | Align with TC-035: a silent default to today/tomorrow is a Fail, or a question for the PO. | medium |
| TC-036 | 6 | minor | If step 3 confirms, it books the Suite for dates near today on the shared demo. Re-runs on the same day, or bookings by other demo users, turn step 3 into an "unavailable" result that the expected result doesn't cover. | TC-001 Notes acknowledge the demo is shared. | Add the unavailable outcome, or stop before the final submit. | medium |
| TC-038 | 7 | minor | AC12 covers keeping dates, not invalid room IDs. The Notes say the handling is assumed but the AC link implies coverage. | AC12. | Set the AC to "none (assumption)". | high |
| TC-039 | 2 | major | Where Back goes depends on browser history before step 1 ("Open" the URL: new tab, or typed into a tab that already had a page?). The confirmation is shown inside the panel, so Back may leave the site or go to the room page. Testers will get different results. | UI map line 18. | Start from the home page, click "Book now" on Double, book, then press Back. State that it runs in a fresh tab. | medium |
| TC-040 | 2 | minor | If the browser shows a "confirm resubmission" prompt, the case doesn't say whether to accept or cancel it, and the UI can't show whether a new booking was created. | UI map line 22. | Specify: accept the prompt, then check the outcome. Or add a check on the home page. | low |
| TC-041 | 7 | minor | AC8 (invalid fields) isn't exercised: all data is valid and nothing is submitted. | AC8. | Remove AC8 from the links. | high |
| TC-043 | 7 | minor | AC12 is about reaching a room page, and this case leaves one. "No booking created" can't be observed and isn't checked. | AC12. | Re-link the case (UX/navigation, no AC). Remove the unobservable claim or add a check on the home page. | high |
| TC-044 (also TC-045) | 3 | major | Per the UI map the guest flow never displays Lastname (the confirmation shows only dates), so stored XSS would only run in Admin, which the tester can't reach. The case passes no matter how the input is stored. Step 3 "observe" has no target. TC-045 has the same limit: it only catches visible error or trace text. | UI map lines 18 and 22. | Retitle as "reflected/guest-side only", or get admin access. Say exactly what to check in step 3. | medium |

Duplicates (check 1): none found after a second pass. TC-002 and TC-041 both check the Suite 2-night £490 summary, but they test different things.

### 2. Suite-level findings

- **AC1/AC12 gap: applies.** No case changes the home-page dates and clicks "Book now" without clicking "Check Availability". TC-007 always clicks it and TC-008 keeps the defaults. This is a realistic path where the old dates get passed (UI map line 10).
- **AC4 to AC7 "required" per field: applies.** Required fields are only tested all at once (TC-011). No case leaves just Email or just Phone empty, so a single missing required check would pass.
- **AC6 format coverage is thin: applies.** Only "no @" and "no domain" are tested. Spaces, a double "@" and a missing TLD (a@b) are not.
- **AC8 persistence: applies.** See the TC-011 comment. Only TC-024 checks it.
- **Re-runs on the shared demo: applies.** All confirmed bookings (TC-001, TC-003 to TC-005, TC-007, TC-014, TC-015, TC-023 to TC-030, TC-039, TC-040, TC-042, TC-044, TC-045) permanently use up their dates. A second run fails with "unavailable", and only TC-001 has a fallback. Whether the demo resets its data needs verification in the app.
- **Slow or dropped network: applies.** No case covers submitting while offline or throttled. The risks are a confirmation shown when nothing was saved, or a spinner that never ends. This can be tested with DevTools throttling.
- **Backend errors: applies.** No case covers a failed POST (for example, blocking the request in DevTools). The risk is "Booking Confirmed" shown, or a blank panel, after a 5xx.
- **Time of day and time zones: applies.** TC-008 and TC-036 depend on "today". Near midnight, or when the browser and server time zones differ (UK site, tester possibly in UTC-6), the prefilled dates, the highlighted day and acceptance of today as check-in can disagree. Not covered. Needs verification in the app.
- **Two sessions on the same data: covered** by TC-030.
- **Refresh or Back during a submit: applies.** Only after-submit cases exist (TC-039, TC-040). Nothing covers refreshing while the request is in flight.
- **Valid-looking but tricky data: partly applies.** Accents, an apostrophe and a hyphen are covered (TC-023). Not covered: emoji (they can count as 2 characters, which moves the AC4/AC5 limits), very long values far beyond the maximum (for example 1000 characters, not just max+1), and whitespace in Lastname, Email or Phone (TC-022 covers Firstname only).
- **Guest count: does not apply.** The booking form has no guest field (UI map line 16). "Max 2 Guests" is display only.
- **Contact form and Admin: do not apply.** They're outside this story. Admin is unreachable, which is why TC-029 and TC-044 are limited.

### 3. Summary

- **Cases reviewed:** 46 (TC-001 to TC-046).
- **Comments by check:** 1: 0, 2: 5, 3: 7, 4: 1, 5: 2, 6: 1, 7: 4, 8: 3 (23 in total).
- **Comments by severity:** blocker 1, major 13, minor 9.
- **What I could not check:**
  - Actual error texts, how Cancel behaves, how the calendar draws the check-out day, price formatting, what Back, refresh and double-click do, and whether the demo data resets. The sources don't describe these, so they need verification in the app.
  - Duplicate bookings and how injected input is stored. There are no admin credentials (UI map line 22).
