# Peer review: execution results of the 2026-11-26 Smoke run (11 cases, executor agent)

I read the run report, the ACs, the Smoke rows of `execution-copy.csv`, all 7 JPEG screenshots and all 21 YAML snapshots I was given. No UI map was provided. The review uses the ACs, the case oracles and the evidence files as its only sources.

This is a review of a run, not of a test suite, so I applied the checks as follows:
- **Check 2 (ambiguous steps):** steps that two executors could run differently, with different verdicts as a result.
- **Check 3 (weak oracle):** an oracle point that the run could not exercise.
- **Check 4 (unsupported claims):** claims in the report that the cited evidence files don't back.
- **Check 8 (verdict vs. oracle/ACs):** whether the verdict follows the case oracle and the ACs.

## 1. Comments table

| Case | Check # | Severity | Comment | Reason / evidence | Suggested fix | Confidence |
|---|---|---|---|---|---|---|
| All (TC-001, 003, 019, 029, 035, 038, 043) | 4 | minor | URL oracle points pass or fail on the report's word alone. None of the snapshots records the page URL, so these can't be checked: TC-001 step 5, the TC-003 URL, TC-019 "URL unchanged", TC-029 step 5, TC-035 step 5, the TC-038 URL and TC-043 step 4. | Every `.yml` starts at the page root with no URL line, e.g. TC-001-2.yml:1, TC-019-1.yml, TC-038-1.yml:1. Indirect support exists: the "Book now" href in TC-001-1.yml:65, the "Double Room" heading in TC-038-1.yml:39, and the home content in TC-043-2.yml. | Capture the page URL with each snapshot (or in the screenshot), at least for cases with a URL oracle point. | high |
| All | 4 | minor | Request and response bodies, status codes and console messages exist only as text in the report. No network or console artifact was saved. The 201/400/409 statuses (including the TC-031 409 behind the "failure is client-side" note) and the "POST count 0" claims in TC-003, TC-004 and TC-035 can't be checked independently. | Report line 15 ("No video, no traces"). The evidence folder holds only `.jpg` and `.yml` files for this run. | Save the captured request/response pairs and console output as an artifact per case, e.g. `TC-031-net.json`. | high |
| TC-006 | 8 | minor | The verdict is Pass, but the Price Summary reads `£100 x 1 nights` and the oracle says "1 night". The executor treated this as wording only (CAND-16). That's a reasonable call, but it is a judgment against the literal oracle, and another executor could mark Fail. The `×` vs `x` and `=` notation is also accepted without comment in every case. | Oracle in TC-006 (csv line 65). TC-006-1.yml:204 shows `£100 x 1 nights`. | QA lead to confirm the verdict rule for plural and notation differences, and change the TC-006 oracle to assert the numbers only, or to treat "1 nights" as a defect. | medium |
| TC-008 | 4 | minor | Step 1 (Price Summary £150 × 2 = £300, Total £340) and "typed values read back from the fields" have no evidence file. TC-008-1.yml is only the confirmation panel. Half of the Pass verdict rests on the report text. | TC-008-1.yml:95-98 shows only "Booking Confirmed". No pre-submit snapshot is cited (report line 79). The request body in report line 80 supports the typed values. | Add a pre-submit snapshot (Price Summary plus filled fields) for TC-008. | high |
| TC-008 | 3 | minor | "No garbled characters" is close to trivially true on the page, because the confirmation panel never shows the names. The only proof of correct encoding is the API echo quoted in the report, which has no artifact (see the row above). | TC-008-1.yml:95-100 has no name text. Case Notes: the stored spelling needs Admin. | Keep it as "NOT VERIFIED on page". The QA lead should decide whether the API echo is enough for AC4 and AC5. | medium |
| TC-031 | 4 | minor | The screenshot cited as "error page" shows only the Next.js dev overlay (Runtime TypeError). It does not show the user-facing "This page couldn't load" page, which appears only in the snapshot. The Fail verdict holds either way. | TC-031-1.jpg shows the overlay only. TC-031-3.yml:73-78 has the error page. | Close the overlay and take a second screenshot of what a user sees, or state that the error page is evidenced only in the yml. | high |
| TC-031 | 8 | minor | The run was against a dev build, so the error rendering is dev-specific. The verdict (error page instead of a message, AC10/AC8) is correct, but how the crash looks to users in a production build can't be inferred from this run. | TC-031-3.yml:21 `Next.js 16.4.3 (stale) Turbopack`. Every snapshot has "Open Next.js Dev Tools". | Note in the bug that the reproduction is on a dev server. Re-check on a production build or the public site. | high |
| TC-035 | 2 | major | The verdict depends on how dates are entered. The oracle passes if "the date picker prevents the selection", but the executor typed the dates with keyboard input (`Ctrl/Cmd+A`, typing, `Escape`), which goes around the picker. A tester who picks 13/03 in the picker after choosing 15/03 might be blocked, and so would pass step 4 and never reach the negative Price Summary. "Set the test data dates" doesn't say how. | Report line 12 and line 139 ("the date picker did not prevent the selection"). Case TC-035 step 2 and oracle (csv lines 291-296). | Re-run steps 2–4 using only the picker. Change the case to name the input method, or to cover both (typed and picked) as separate checks. Until then, the "picker prevents" part of the Fail is not shown. The "no message" and "negative amounts" points still stand for typed input. | medium (needs verification in the app) |
| TC-035 | 3 | minor | The oracle includes "a booking with valid data must not reach Booking Confirmed", but the steps have no submit. The executor correctly marked it NOT VERIFIED, so this AC11 risk is never exercised in Smoke. | TC-035 steps 1–5 vs. the oracle (csv lines 291-296). Report lines 145 and 203. | Add a submit step to TC-035, or remove the clause and point to TC-048 (Regression), which does submit. | high |
| TC-038 | 4 | minor | The Pass, and the "BUG-03 not reproduced" note, rest on a single snapshot of the destination page. Nothing shows the source page (room 1) or that the page was reached through "View Details": the same page opened directly by URL would look identical. Because this result contradicts a known bug, the navigation path needs evidence. TC-001-2.yml:233 does show "View Details" hrefs carrying dates on this copy, which partly supports the claim. | Only TC-038-1.yml and TC-038-1.jpg are cited (report line 155). Both show room 2 only. | Add a snapshot of the room 1 page showing the "View Details" href before the click. Don't close BUG-03 on this run alone. I can't tell whether BUG-03 is environment-specific, because the bug file is out of scope. | medium |
| Run header | 8 | minor | The environment commit `efe2deb` is taken from another document (`bugs/README.md`), not from the running app. The report says so, but every result is then tied to an unconfirmed build. | Report lines 3 and 205. The UI only shows "v2.2" (TC-001-1.yml:205). | Record the commit from the checkout used by `run_locally.sh` (e.g. `git rev-parse HEAD` in the app repo) before the run. | high |
| Run (Deviation 5) | 4 | minor | A file in the evidence folder (`tc004-tmp.png`) was written and then deleted during the run. Nothing shows what it contained, and deleting files during a run is outside the "read-only except" statement in report line 13. | Report line 204. | Log stray artifacts and leave them for the lead, instead of deleting them. | low |

No comments on TC-001, TC-003, TC-004, TC-019, TC-029 or TC-043 beyond the cross-cutting rows above. Each claim I could check against the evidence matched:
- **TC-001:** TC-001-1.yml has the hrefs; TC-001-2.yml and the jpg show December 2027, the bar on 14–16 and £240; TC-001-3.yml shows the empty form and Cancel; TC-001-4.yml shows the confirmation.
- **TC-003:** TC-003-1.yml shows £675 and £715.
- **TC-004:** TC-004-1.yml has no textbox; TC-004-2.yml has 4 empty fields, Cancel and £240.
- **TC-019:** TC-019-1.yml:114 has the single unnamed bullet; the fields keep their values.
- **TC-029:** TC-029-1.yml:114-120 has 7 bullets; TC-029-2.yml lists Single.
- **TC-043:** TC-043-1.yml and TC-043-2.yml are consistent with the report.

The Fail verdicts on TC-019, TC-029 and TC-031 follow their oracles and AC8/AC10.

## 2. Suite-level findings

**Coverage of the ACs in this Smoke run**

| AC | Status | Note |
|---|---|---|
| AC1, AC2, AC3, AC9 | covered | Pass, with evidence (URL caveat above). |
| AC4 | covered | Positive: TC-006, TC-008. Negative: TC-019, TC-029. |
| AC5 | partly covered | Negative only through TC-029 (all fields empty). There is no Lastname length negative in Smoke (TC-023/024 are Regression). Applies, by suite design. |
| AC6 | partly covered | Negative only as "empty" in TC-029. Invalid format (TC-025/026) is not in Smoke. Applies: the email format rule is never exercised in Smoke. |
| AC7 | partly covered | Negative only as "empty" in TC-029. Length boundaries are not in Smoke. Applies, by suite design. |
| AC8 | covered | TC-019, TC-029 (both Fail). |
| AC10 | covered | TC-031 (Fail, crash). Partial overlap and two-session cases are not in Smoke. |
| AC11 | partly covered | TC-035 only. The verdict depends on input method, and the submit is never exercised (see table). |
| AC12 | covered | TC-038, one path only. Missing or invalid URL parameters (TC-039/040) are not in Smoke. |

**Conditions**

| Condition | Status | Reason |
|---|---|---|
| Slow or dropped network | does not apply to this run | The local server and no network shaping are not in scope for Smoke, and no case asks for it. |
| Backend error responses | applies | TC-031 shows that a 409 crashes the client. No Smoke case checks how the UI handles a 5xx or a timeout. |
| Time of day / time zone | does not apply here | All dates are fixed in 2027 and the server is local (CST). Only the number of "Next" clicks depends on the run date, and the cases phrase that as "until <month>". |
| Two sessions on the same data | applies | Not exercised in Smoke (TC-033 is Regression). It relates to the AC10 failure seen in TC-031. |
| Refresh or Back during or after submit | applies | Not exercised in Smoke (TC-042, 044 and 045 are Full). |
| Valid-looking but unusual data | partly applies | TC-008 covers accents, apostrophe and hyphen. Emoji, very long values and HTML/SQL input are not in Smoke. |
| Environment fidelity | applies | The run is against a local Next.js dev build (TC-031-3.yml:21), not the site named in the cases. Error rendering and BUG-03 reproduction may differ from production. The report says the results apply only to this copy (line 3). |

## 3. Summary

- **Cases reviewed:** 11 (TC-001, 003, 004, 006, 008, 019, 029, 031, 035, 038, 043), plus the run header and the deviations list.
- **Comments:** 12.
  - **By check:** #2: 1, #3: 2, #4: 6, #8: 3.
  - **By severity:** blocker 0, major 1 (TC-035 input method), minor 11.
- **Verdicts:** I found no verdict contradicted by the evidence. TC-035's "picker did not prevent" point and TC-038's "BUG-03 not reproduced" are weakly supported. TC-006's Pass is a judgment call the lead should confirm.

**What I could not check, and why:**
- **Page URLs:** they aren't recorded in any snapshot.
- **Network and console data:** request/response bodies, status codes, POST counts and console messages are not saved as artifacts.
- **Ticket mappings:** BUG-01/02/03/05, CAND-10/16 and PO-4/6/7 refer to files outside my inputs, so I couldn't confirm the mappings or what BUG-03 describes.
- **The Data check:** the `curl` output in report lines 181-194 isn't in the evidence.
- **The executor's rules:** its agent definition wasn't provided, so I couldn't judge whether `browser_run_code_unsafe` (Deviation 1) or deleting a file (Deviation 5) is allowed.
- **The date picker:** whether it blocks a reversed range when used by clicking needs verification in the app.
- **No UI map:** none was provided, so labels and layout were checked only against the case oracles and the evidence.

Files reviewed:
- /Users/jesusserna/Projects/ai-qa-team/runs/execution-2026-11-26-smoke-11-executor.md
- /Users/jesusserna/Projects/ai-qa-team/reviewer/inputs/story-and-acs.md
- /Users/jesusserna/Projects/ai-qa-team/test-suite/execution-copy.csv
- /Users/jesusserna/Projects/ai-qa-team/runs/evidence/2026-11-26/ (the 7 `.jpg` and 21 `.yml` files listed in the task)