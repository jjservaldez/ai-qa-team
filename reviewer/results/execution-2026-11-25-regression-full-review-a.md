# Peer review: runs/execution-2026-11-25-regression-full.md (pass a)

- **Reviewer:** `peer-reviewer` subagent, fresh context, Read tool only. Checks E1–E6, the same as in the Smoke execution review.
- **Inputs:** runs/execution-2026-11-25-regression-full.md, reviewer/inputs/story-and-acs.md (with AC8 clarified), reviewer/inputs/ui-map.md
- **Date:** 2026-11-25, about 17:45 CST
- **The reviewer's text follows unedited.** Line references point to the execution file as it was at review time.

---

## Review of execution results: Regression (16) and Full (28) suites, 2026-11-25

I read all three inputs:
- /home/claude/ai-test-case-agent/runs/execution-2026-11-25-regression-full.md
- /home/claude/ai-test-case-agent/reviewer/inputs/story-and-acs.md
- /home/claude/ai-test-case-agent/reviewer/inputs/ui-map.md

I opened no other file. The run report points to `runs/execution-2026-11-25-smoke.md` for environment details and mentions L-08, L-31 and BUG-01..07. I could not check any of those.

Two recorded verdicts are probably wrong under the run's own rules: TC-017 and TC-052 should be Question, not Fail.

### 1. Comments table

| Case | Check | Severity | Comment | Reason / evidence | Suggested fix | Confidence |
|---|---|---|---|---|---|---|
| TC-005, TC-012, TC-014, TC-015, TC-051 | E2 | minor | The actual result is only "as expected" and lists no values. TC-005 step 4 alone has six checks: form hidden, Cancel hidden, Reserve Now visible, no red box, Price Summary £240, URL unchanged. TC-012 has a URL, a price breakdown and a year check. None of these values is recorded, so the Pass rests on the executor's word. TC-015 and TC-051 at least add an API check. | Report lines 255, 302, 321, 329, 490 | Record the observed URL, Price Summary lines and panel text, as was done for TC-020. | high |
| TC-007, TC-009 | E5 | major | Both Passes are about what an input accepts: maximum lengths 18/30/21, and a phone with "+", spaces, "( )" and "-". The values were set through DOM input events, not typed. A programmatic value skips maxlength truncation, input masks and keystroke filters. "Field lengths confirmed in the inputs" reads back what the script set, so it doesn't show that a user can type these values. TC-020 found no maxlength, but only on Firstname. | Method, report lines 17–21; TC-007 actual line 263; TC-020 evidence line 62 | Re-run TC-007 (Lastname, Phone) and TC-009 (Phone) with real keystrokes, or record the maxlength, pattern and mask attributes of each input. Until then, treat both Passes as provisional. | medium |
| TC-016 | E1 | minor | Pass is recorded, but one expected check ("no garbled text") is marked NOT VERIFIED. The rules have no state for "partly unverifiable", so a reader will assume the whole expected result held. | Report line 338; rules lines 26–34 | Record the check as not executable through the UI, verify the stored value another way (admin view or authenticated API), or move it into the case as an assumption. | high |
| TC-017 | E4 | blocker | The Fail breaks the run's own rules. Fail requires an AC that the behavior contradicts, or an error page. "12345" and "67890" are 5 characters, which is valid under AC4 and AC5. No AC requires letters, and the report's own note says L-08 called this an "AC gap". No error page appeared. TC-018 (spaces) and TC-037 (past dates) have the same kind of finding and are recorded as Question. Calling it BUG-04, not a candidate or a PO question, has the same problem. | AC4, AC5; rules lines 28–30; note line 54; TC-018 line 343; TC-037 line 406 | Change the verdict to Question. Reclassify BUG-04 as a PO question or AC gap, or tie it to an AC the PO adds. | high |
| TC-021 | E4 | minor | Pass with BUG-05 "outside oracle" is consistent with the rule and with TC-030. But the same observation, an unnamed "size must be between 3 and 18" bullet, is a Fail in TC-020 and TC-050. The only reason is that TC-021's oracle was written before AC8 was clarified the same day. The "outside oracle" rule itself was made up during Full and written down afterwards. | AC8 (clarified 2026-11-25); rules line 34; TC-020 line 61 | The QA lead should decide whether to update the TC-021 and TC-030 oracles to the clarified AC8. If they do, both become Fail (BUG-05). Either way, record the rule's adoption time in the report. | medium |
| TC-024, TC-028 | E5 | major | These cases send values over the maximum (Lastname 31, Phone 22) through DOM events. The "no maxlength" check was done only for Firstname (TC-020). If the Lastname or Phone input has maxlength 30 or 21, a tester typing the value would get it truncated to a valid value and a "Booking Confirmed". A manual run could then reach a different result. | Report line 62 (Firstname only); method line 17 | Record the maxlength of the Lastname and Phone inputs, or re-run the field under test with keystrokes, as Full did for TC-018 and TC-022. | low |
| TC-024, TC-027, TC-028, TC-040, TC-048, TC-050 | E2 | minor | No evidence line. The verdicts depend on exact bullet text or exact Price Summary strings ("£NaN", "£-160"). TC-020 and TC-023 state "alert text from the DOM", but these cases state no source. | Report lines 75–97, 180–190, 209–216, 423–429 | Add the evidence source (DOM text, screenshot) for each case. | high |
| TC-030 | E1 | major | The expected result for step 3 lists four errors by field: "(Firstname, Lastname, Email, Phone)". None of the three size bullets names a field. The executor matched them to fields by their numeric ranges. That works for 3–18 and 11–21, but a literal reader can't confirm a "Firstname error" from the page. Two testers could reach Pass and Fail. Under the clarified AC8, the attribution is the very thing at issue. | Expected line 384; actual line 388; AC8 | The QA lead should decide whether the field list in step 3 is part of the oracle. If it is, the verdict is Fail (BUG-05). If not, reword the case to "four bullets, one per invalid field". | medium |
| TC-032, TC-036, TC-048 | E2 | minor | The error page is linked to BUG-01 without network evidence. Only TC-031 and TC-034 captured the POST status (409) and the console TypeError. In TC-036 and TC-048, the server may have rejected the 0-night or reversed range with a different status (for example 400), which would point to a different defect path. | TC-031 evidence line 111; TC-032 line 120; TC-036 line 163; TC-048 has no evidence line | Capture the POST /api/booking status and the console for each error-page case before you confirm the BUG-01 link. | medium |
| TC-033 | E1 | minor | The expected result for tab B includes a Price Summary (£490), but the note says it was not recorded. Tab B was also a background tab, and its fields were set by script, which may be throttled there. The Fail still stands, because the error page alone triggers Fail. B's page text shows the error page, but there is no B network capture showing 409. | Expected line 130; notes line 139 | Record B's Price Summary and B's POST status. Run B in the foreground. | high |
| TC-034 | E3 | minor | BUG-01 explains the error page after the 409. It doesn't explain why the client sent two POSTs: the submit is not disabled or debounced after the first click. The server's 409 kept the data intact, but the user sees an error after a booking that worked and may book again. No candidate covers this. | Actual line 397: 201 then 409 | Add a candidate for the double submit, separate from BUG-01. | medium |
| TC-035 | E3 | minor | BUG-01 is linked, but nothing was submitted in this case, so the BUG-01 behavior (error page on a rejected POST, as seen in TC-031) was never seen here. The expected check "valid data must not reach Booking Confirmed" was skipped (E1). The note hands it to TC-048, but TC-048 enters by URL tampering, not by the home-page path this case is about. | Notes line 151; expected line 143 | Either drop BUG-01 from this case or run the submit step. Record the skipped check explicitly. | medium |
| TC-035, TC-036, TC-037 | E5 | minor | The Single page was opened from its Book-now href, not clicked. The UI map and AC1 describe the click path. A click handler that adds or changes state would be bypassed. This doesn't affect the Fails (negative and zero nights show on the page anyway) or TC-037's Question. | Notes lines 151, 166, 409; UI map line 10 | Use a real click. If the href is used, say so in the verdict basis. | low |
| TC-038 | E6 | major | "BUG-03 is not reproduced on the local copy" is a statement about the environment. The UI map describes the public demo, and BUG-03 was presumably found there. Someone comparing this run with a manual run could close BUG-03. The CAND-10 shading (check-out day shaded) also contradicts the UI map ("selected nights are shown as a Selected bar") and may itself be specific to the local copy. | Notes line 178; environment lines 5–8; UI map line 14 | Mark BUG-03 as "not reproduced on commit efe2deb; verify on the demo". Check CAND-10 on the demo too. The Question verdict is consistent with the rules. | medium |
| TC-039 | E1 | major | The Fail is justified as "endless loading", but the rule defines that as more than 30 s, and the spinner was observed for 25 s. The start point is also unclear: the case ran 16:56:18–16:56:59 (41 s), so 25 s may not have been counted from page load. The Fail may still hold under AC12, because no prompt to select dates appeared, but the report doesn't argue that. | Rules line 28; actual line 417; notes line 421 | Re-run with a page-load timestamp and a wait over 30 s, or restate the basis as an AC12 contradiction. Keep Fail as provisional. | high |
| TC-039, TC-041 | E3 | minor | CAND-12 (spinner) and CAND-14 (500 for room 99) are new and were seen only on the local copy. The TC-038 expected result says that on the demo a missing-dates path can show default today/tomorrow dates, so the no-dates behavior may differ there. These may be artifacts of this environment. | TC-038 expected line 170; environment lines 5–8 | Confirm both on the demo before filing. Note the environment on each candidate. | low |
| TC-040 | E3 | minor | CAND-13 (£NaN for invalid date parameters) looks like the same root cause as BUG-02 (negative or zero nights in the Price Summary): the summary is calculated from URL dates without validating them. It may be a duplicate or should at least be linked. | TC-035, TC-036, TC-048 actuals (BUG-02); TC-040 actual line 427 | Link CAND-13 to BUG-02, or merge them after a root-cause check. | medium |
| TC-042 | E5 | minor | "Back (browser navigation)" doesn't say whether the browser button or history.back() was used. The pane already lacked a working F5. The executor also found the home-page dates reset to today and retyped them. That deviation from the steps is recorded, but not as an observation for the PO, since no AC covers it. | Actual line 447; method line 24 | State the Back mechanism. List the date reset as an observation or PO question. | medium |
| TC-045 | E2 | major | Step 5 ("Single is still listed" on the home page) was checked through `/api/room?...`, not through the UI the expected result describes. The API returning rooms 1–3 doesn't prove the "Our Rooms" section listed Single, because the client could filter differently. Part of the Pass rests on a substitute. | Actual line 466; expected line 464 | Re-run step 5 through the home page UI. Until then, record step 5 as verified by API only. | high |
| TC-049 | E4 | minor | The note says the CAND-10 shading in step 2 is "outside the main check". It isn't: the step 2 expected result says "Selected on 6, 7 and 8 September", and the actual result is 6–9. This doesn't change the Fail, but it misdescribes how the case was scored, and it uses the "outside oracle" idea before that rule existed. | Expected line 196; actual line 201; notes line 207 | Say that step 2 also deviated (CAND-10) and that the Fail comes from step 4 and step 6. | high |
| TC-050 | E1 | minor | The actual result doesn't say which bullets break the clarified AC8. "must be a well-formed email address" arguably names its field (email). The two size bullets don't. TC-025 and TC-026 pass with that same email bullet, so this matters for consistency. | Actual line 213; TC-025 line 368 | State per bullet whether it identifies its field. | medium |
| TC-052 | E4 | blocker | Fail breaks the run's own rules. No AC covers the top navigation: AC1–AC12 are all about booking. There was no error page, no crash and no endless loading. Under the rules, behavior that differs from the expected result with no AC covering it is a Question. The expected result's "Fail if..." clause can't override that rule. The observation itself (dead /#amenities link, no id "amenities") is well evidenced. | ACs; rules lines 28–30; UI map line 4 (nav exists, no behavior specified) | Change the verdict to Question. BUG-07 can stay filed, outside this story's scope. | high |

### 2. Run-level findings

- **Rules changed between the suites (major, applies).**
  - Regression ran 16:31–16:35, but its verdicts are presented under rules dated 16:49.
  - Only TC-038 is shown as re-labelled. TC-017 and TC-052 were not re-checked against the Question rule.
  - The "outside oracle" rule was made up during Full and written down afterwards.
  - Fix: state which Regression verdicts were re-checked under the 16:49 rules, and when each rule was adopted.
- **Environment is not the one the UI map describes (major, applies).**
  - Local copy, commit `efe2deb`, vs the public demo.
  - BUG-03 did not reproduce. CAND-10, CAND-12 and CAND-14 may be local-only.
  - This run's results can't be compared one-to-one with a manual run on the demo. Every bug and candidate should carry the environment.
  - The environment section only refers to the Smoke report, which I wasn't given, so I couldn't verify it.
- **Input method differs between the suites (major, applies).**
  - Regression set every field by DOM events, including the fields under test (TC-020 to TC-028, TC-050).
  - Full used keystrokes for the field under test (TC-016, TC-018, TC-022, TC-046, TC-047).
  - The bullets look like server-side validation messages, so the Fails are robust. Passes on script-set fields (TC-007, TC-009, TC-010, TC-030 step 5) are weaker.
- **Data not reset between suites (applies, no collision found).**
  - I checked every booked or attempted range per room against the Smoke bookings and against each other. There are no overlaps apart from the intended ones (TC-015, TC-031, TC-032, TC-033).
  - The totals reconcile: 3 + 4 + 5 + 20 = 32. The verdict counts also match (Regression 1 Question / 15 Fail; Full 19 Pass / 5 Question / 4 Fail).
  - A re-run on the same instance will collide with every confirmed booking, because all dates are fixed. Reset the data first.
  - TC-002 and TC-005 depend on the run date. TC-011 (2026-11-30) and TC-037 ("past") will expire or change meaning.
- **Data check wording (minor, applies).**
  - "2026-11-26 has no booking" is ambiguous, because TC-002 booked room 2 for 2026-11-25..26. Say "room 1, check-in 2026-11-26".
  - Regression cases rejected by validation (TC-020 to TC-028, TC-050) are not listed one by one. Only the total count covers them.
- **Timing and time zone (does not apply as a problem).** The server Date of 22:50 GMT matches 16:50 CST (UTC-6), so "today" in TC-002 is right. TC-036 and TC-048 have overlapping "about" windows, but the order is stated.
- **location.reload() instead of F5 (low risk, applies).** For an SPA with no POST navigation, the reload type is the same ("reload"), so TC-044 and TC-045 are unlikely to be affected. Still, say this was not a real F5.
- **DOM clicks on Next and on submit (low risk).** The results come from server responses and rendered state, which the click mechanism doesn't change. The exceptions that matter were done with real input: TC-034 (real double-click) and TC-049 (real date click).
- **Text-only judgments (minor, applies).** "Clear message" and layout checks rest on page text read by script. There are screenshots only for TC-038 and TC-039. TC-035's "near the date fields" was moot here, because no message appeared.
- **Comparing with a manual run (applies).** An agent with no think time ran 44 cases in about 13 minutes, with background tabs and script-set fields. Timing-sensitive behavior (TC-033 concurrency, TC-034 double-click) may differ when a person does it.

### 3. Summary

- **Cases reviewed:** 44 (Regression 16, Full 28).
- **Verdicts I agree with (37):** TC-002, 005, 010, 011, 012, 013, 014, 015, 016, 018, 020, 021, 022, 023, 024, 025, 026, 027, 028, 031, 032, 033, 034, 035, 036, 037, 038, 040, 041, 042, 044, 046, 047, 048, 049, 050, 051.
- **Provisional until re-checked (5):**
  - TC-007, TC-009: a typed input may behave differently.
  - TC-030: the field attribution may be part of the oracle; possible Fail.
  - TC-039: under the 30 s threshold.
  - TC-045: step 5 was checked by API only.
- **Verdicts I would change (2):**
  - TC-017: Fail to Question.
  - TC-052: Fail to Question.
- **Comments by check:** E1 5, E2 4, E3 4, E4 4, E5 4, E6 1 (22 rows).
- **Comments by severity:** blocker 2, major 6, minor 14.
- **What I could not check:**
  - Whether the BUG-01..07 linkages match the bug definitions. I don't have the bug list, so I inferred BUG-01 as "error page on a rejected POST" from TC-031.
  - The Smoke report environment and the L-08 and L-31 references, which are outside my inputs.
  - Whether the local copy matches the public demo (CAND-10/12/14, BUG-03). That needs the demo.
  - Input attributes (maxlength, masks) on Lastname and Phone. That needs the app.
  - Whether the stored values in TC-016 and TC-046 are intact or escaped. That needs the admin view or an authenticated API.

---

## Facts the executor already had that answer some comments (added after the review)
- **maxlength:** at 16:31 the executor read the attributes of all four booking inputs. Firstname, Lastname, Email and Phone all have maxlength=-1 (none), type=text and required=false. No input truncates its value. This settles the TC-024 and TC-028 comment and part of the TC-007 and TC-009 comment. The run file mentioned only Firstname.
- **TC-039 timing:** the page was opened at about 16:56:19, and the spinner was still there at 16:56:59, about 40 s after page load. The 25 s wait was only the last check. The run passed the 30 s threshold.
