# Peer review: runs/execution-2026-11-25-smoke.md (pass a)

- **Reviewer:** `peer-reviewer` subagent, fresh context, Read tool only. This is the first review of execution results rather than of test-case design.
- **Inputs:** runs/execution-2026-11-25-smoke.md, reviewer/inputs/story-and-acs.md, reviewer/inputs/ui-map.md
- **Checks given in the task prompt:**
  - E1: the verdict follows from the evidence
  - E2: the evidence is enough for the claim
  - E3: bug linkage
  - E4: consistency across cases
  - E5: method risk
  - E6: run-level issues
- **Date:** 2026-11-25
- **Output below is the reviewer's text, unchanged.** Line references point to the execution file as it was at review time.

---

## Execution review: Smoke run 2026-11-25 (8 cases)

I read three inputs, all present:
- /home/claude/ai-test-case-agent/runs/execution-2026-11-25-smoke.md
- /home/claude/ai-test-case-agent/reviewer/inputs/story-and-acs.md
- /home/claude/ai-test-case-agent/reviewer/inputs/ui-map.md

I opened no other files and edited nothing.

The main problem: the run does not apply its own verdict rules the same way everywhere. TC-001 was downgraded to Question because "no AC covers it". By that same rule, TC-019 and TC-029 should be Question too, unless someone records which AC BUG-05 breaks.

### 1. Comments table

| Case | Check | Severity | Comment | Reason / evidence | Suggested fix | Confidence |
|---|---|---|---|---|---|---|
| TC-001 | E1 | major | The headline verdict "Pass – step 6 = Question" is a composite. The rules don't define one. The Question rule says the case is Question and the main checks are recorded separately. A tally of headline verdicts will count TC-001 as Pass. | Verdict rules, Question rule (line 22). TC-001 Result (line 54). | Record the case as **Question**, with "main flow steps 4, 5, 7, 8, 11: Pass" as a separate note. | medium |
| TC-001 | E4 | major | The reason given for changing Fail to Question is that the same calendar behavior "showed up in two Regression cases". That isn't a verdict-rule criterion. The cases aren't part of this run and the file includes no evidence from them. The rule-based reason (no AC covers calendar shading) only appears as a separate sentence. Also, the original "Fail (step 6 only)" broke the Fail rule, which needs an AC. | Notes (line 63). Fail rule (line 20). | Give the rule-based reason only. Drop the Regression reference, or name the cases and attach their evidence. | high |
| TC-001 | E3 / E6 | major | CAND-10 is a plausible candidate, but it may come from the environment. The UI map, which describes the live demo, says the selected **nights** are shown as the "Selected" bar, and shortens it to "Sel…" for a single night. That points to nights-only on the demo. The local copy shades the check-out day as well. If the demo shades nights only, this is a difference between the local build (commit efe2deb, 2026-10-23) and the demo, not a product question. | ui-map.md line 14. Actual step 6 (line 57). Environment (lines 4, 8). | Repeat step 6 on https://automationintesting.online before sending CAND-10 to the PO. Write in CAND-10 which environment shows the behavior. | medium |
| TC-001 | E5 | minor | Step 9 says "Type the contact data", but the values were set by form-fill, not typed. The booking was created, so the values did reach the server. Only the stored dates were checked through the API, not the stored names, email or phone. | Method (line 13). Data check (lines 24–27). | Write in the case that step 9 was done by form-fill. Check stored contact data if a source allows it (see TC-008). | high |
| TC-004 | E1 | minor | The expected Price Summary includes "£100 × 2 nights". The actual result lists only "£200, £25, £15, Total £240". The rate × nights line was probably seen but isn't recorded. | Expected (line 90) vs actual (line 94). | Record the full Price Summary line. | medium |
| TC-006 | E4 / E3 | major | The label says "1 nights" where the expected result says "1 night". That is a difference from the expected result with no AC covering wording. The run marks it Pass with a "cosmetic" note and raises no candidate. TC-001 step 6 is the same kind of difference (no AC) and got Question plus CAND-10. | Expected (line 109). Notes (line 115). Question rule (line 22). AC2 covers the amounts, not the grammar. | Do one of two things: raise a cosmetic candidate and mark the step Question as in TC-001, or add a rule that wording-only differences in non-oracle text keep a Pass. Then apply the choice to both cases. | high |
| TC-006, TC-003, TC-008, TC-043 | E2 | major | The only evidence is "Page text captured", with no file, path or excerpt. Nobody can audit these Pass verdicts later; it comes down to the executor's word. DOM text also doesn't prove what was visible on screen. | Evidence lines 77, 113, 132, 192. Method: screenshots for TC-001 only (line 15). | Attach the captured text or a screenshot of each oracle point (Price Summary, "Booking Confirmed" panel, URL). For the four confirmed bookings, cite the API data check, which already exists. | high |
| TC-008 | E1 | major | The expected result asks for "no garbled characters". The actual result doesn't mention garbling, and the executor's note admits it can't be seen in the UI. So the main reason this case exists, that accented/apostrophe/hyphen names are stored correctly, was not verified. Only "booking accepted" (AC9) was verified. Pass overstates what was checked. | Expected (line 129). Actual (line 131). Notes (line 134). The data check only compares dates. | Keep Pass for acceptance, and record "garbled-character check: not verified". Check the stored name through an admin or booking API on the local copy, if that is allowed. The UI map says admin credentials are not given to the tester, so this may stay open. | high |
| TC-008 | E5 | major | The values José and O'Brien-Núñez were set directly, not typed. That skips the keyboard path, where accents, dead keys and smart-quote apostrophes usually break. A manual tester typing the same data could get a different result. | Method (line 13). Test data (line 126). | Repeat the case with real keystrokes, or mark it "input via form-fill; keyboard path not covered". | medium |
| TC-019 | E1 / E4 | major | Fail is recorded only because the bullet doesn't name the field. The Fail rule needs behavior "an AC requires". AC8 only requires that error messages are shown and that no booking is created, and both happened (one bullet; the API shows no booking). The run used "no AC covers it" to downgrade TC-001 but not here. Under the stated rules this is Question, unless BUG-05 was accepted against a specific AC. | Fail rule (line 20). Question rule (line 22). AC4, AC8. Actual (line 148). Data check (line 26). | Change to **Question**. Or record which AC BUG-05 breaks, or add a rule: "a case reproducing a known, accepted bug is Fail". Apply the same rule to TC-029. | medium |
| TC-019 | E2 | minor | The expected result places the red box "above the Price Summary". The evidence is DOM text only, so position and visibility weren't checked. | Step 4 (line 144). Evidence (line 149). UI map line 17. | Add a screenshot of the panel. | medium |
| TC-029 | E1 / E4 | major | Same rule problem as TC-019. Messages that don't name the field are not an AC requirement under AC8. | Expected (line 167). Fail rule (line 20). | Make it Question, or use the same known-bug rule as TC-019. | medium |
| TC-029 | E1 / E3 | major | The actual result can't show that Email got any error. The seven messages map to Phone (11–21), Firstname (3–18 and blank), Lastname (3–30 and blank) and two "must not be empty". Those two could belong to Email and Phone, or both to one field. If Email has no message, AC6 and AC8 back a real Fail and a new candidate, separate from BUG-05. The expected result checks errors for all four fields, and the executor didn't settle it. | Actual (line 171). Expected (line 167). AC6, AC8. | Submit with only Email empty and the other fields valid, and record the messages. Or read which input each message is attached to. | medium (needs verification in the app) |
| TC-029 | E5 | minor | The executor had to choose between two "Home" links (hrefs "/" and "#") and wrote down which one. A manual tester could click the "#" link and see a different step 5 result. The UI map lists only the breadcrumb "Home". | Notes (line 176). ui-map.md line 11. | Pin step 5 to the breadcrumb link. Ask the lead whether the "#" Home link should become a candidate. | medium |
| TC-029 | E6 | minor | The time window is "about 16:27:45". Every other case has exact timestamps. | Line 175. | Record exact times. | high |
| TC-043 | E5 | minor | The contact data was set by form-fill, not typed as step 2 says. This has no effect on the oracle, which is the URL and the home page after "Return home". | Method (line 13). | Mention the method in the case note. | high |

### 2. Run-level findings

- **Local build vs demo (applies, major).** The cases and the UI map describe the public demo. The run used a local build from 2026-10-23, and the only change was swapping the URLs. Version differences are possible: the calendar shading (CAND-10), the wording of error messages, the "1 nights" label. Anyone comparing this run with a manual run on the demo needs the commit and an explicit "results may differ by environment" line. For any candidate, record whether it reproduces on the demo.
- **The verdict rules have no clause for known bugs (applies, major).** The rules don't say how to treat a case that reproduces an already-filed bug (BUG-05) when no AC strictly requires the expected behavior. That gap is what makes TC-019 and TC-029 inconsistent with TC-001. Add the rule and re-apply it.
- **Evidence is not stored (applies, major).** Only TC-001 has screenshots. The other seven rely on DOM text with no artifact attached. A manual run normally keeps screenshots, so the evidence levels are not comparable.
- **Input method (applies, major).** Form-fill sets values without keystrokes, so the inputs never went through keyboard, IME or autocorrect behavior, and the steps say "Type". This matters most for TC-008. Bookings were created, so the values reached the server, but the stored contact fields were never checked.
- **DOM vs what is visible (applies, minor).** A message being absent from the DOM proves it wasn't shown. A message being present doesn't prove the user could see it. Only TC-001 has visual proof.
- **Data integrity check (applies, positive with one limit).** The API check matches the UI: 4 bookings for 4 "Booking Confirmed" panels, none from TC-019 or TC-029, and room 1 excluded for 14–16/12. It checks dates only, not names, email or phone.
- **"Data starts clean" (applies, minor).** The data starts seeded: there is one sample booking, room 1, 2026-02-01..05. It doesn't overlap any test dates.
- **Re-running (applies, major for future runs).** The run left bookings for TC-001, TC-006, TC-008 and TC-043 in place. Re-running on the same instance without a reset would hit AC10 (already booked) and give false Fails. Record "reset data before re-run". The dates are absolute; they run through 2027-07 and stay valid until then.
- **Timing (applies, minor).** 3 min 44 s for 8 cases, with no gaps between them, is the agent's speed, not a manual estimate. Preconditions such as "Single free for…" were not checked at run time, only by the health check at 16:14 and the API check after the run. The post-run API queries fall outside the run window.
- **Health-check notation (applies, minor).** `/api/room/1,2,3` is unclear: one call with a list, or three calls?
- **Browser not identified (applies, minor).** "Claude desktop browser pane" gives no engine or version. Record them so the run can be reproduced.
- **Time zone (does not apply).** All timestamps are CST, and no case depends on the time of day.
- **Coverage (out of scope for this review, noted for the lead).** No Smoke case ran for AC10, AC11 or AC12, or for the Lastname, Email and Phone negative paths. That is only fine if those ACs are covered by the Regression run.

### 3. Summary

**Verdicts I agree with:** TC-003 Pass, TC-004 Pass, TC-043 Pass.

**Verdicts I would change or qualify:**
- **TC-001:** Pass (composite) → **Question**, with the main flow recorded as passed.
- **TC-006:** Pass → **Question**, or Pass under an explicit "wording-only differences" rule. Either way it must be handled the same as TC-001.
- **TC-008:** keep **Pass** for acceptance, and mark the garbled-character check "not verified".
- **TC-019:** Fail → **Question** under the stated rules, unless BUG-05 is tied to an AC or a known-bug rule is added.
- **TC-029:** Fail → **Question** on the same basis. It would become a **Fail** with a new candidate if Email turns out to have no error message (AC6, AC8).

**Counts:** 16 table rows. Rows tagged with two checks count once under each, so the check counts add up to more than 16.
- By severity: blocker 0, major 10, minor 6.
- By check: E1 6, E2 2, E3 3, E4 5, E5 4, E6 2.

There are no blockers. The verdict changes come from inconsistent rule application, not from evidence that contradicts the verdicts.

**What I could not check:**
- Whether the demo shades the check-out day. That needs the public demo.
- Which field each "must not be empty" message belongs to. That needs the app.
- The stored names, email and phone for TC-008 and the other bookings. The UI shows only dates, and the UI map says admin credentials are not provided.
- The "page text captured" artifacts, because none are attached.
- Whether BUG-05 was accepted against a specific AC. Its report is not among my inputs.

---

## Follow-up check by the executor (16:44, after the review)

To settle the TC-029 Email question, the executor submitted twice on …/reservation/1?checkin=2027-10-04&checkout=2027-10-06:
- Only Email empty (the other fields valid): one bullet, "must not be empty".
- Only Phone empty (the other fields valid): "size must be between 11 and 21" and "must not be empty".

So Email does get an error, and all four fields get one when the form is empty. **No new candidate.** TC-029 stays tied to BUG-05 only. Neither submit created a booking.
