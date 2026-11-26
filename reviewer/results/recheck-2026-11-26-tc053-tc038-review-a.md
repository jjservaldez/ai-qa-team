# Peer review: re-check of TC-053 and TC-038 (executor run, 2026-11-26)

Scope: `/Users/jesusserna/Projects/ai-qa-team/runs/recheck-2026-11-26-tc053-tc038-executor.md`, checked against `/Users/jesusserna/Projects/ai-qa-team/reviewer/inputs/story-and-acs.md`, the TC-038 and TC-053 rows of `/Users/jesusserna/Projects/ai-qa-team/test-suite/execution-copy.csv`, and the 16 evidence files listed for this re-check in `/Users/jesusserna/Projects/ai-qa-team/runs/evidence/2026-11-26/`. No UI map was provided, so the ACs and the evidence were the only sources about the application.

My agent definition is written for reviewing test cases. This task reviews execution results, so I applied checks 1–8 to the two case rows and added a check **E**: does the reported result match the evidence and the oracle?

**Bottom line:** the evidence supports both verdicts, TC-053 **Fail** and TC-038 **Pass**. The serious problem is in the TC-053 case itself: its oracle would pass a realistic defect.

### 1. Comments table

| Case | Check # | Severity | Comment | Reason / evidence | Suggested fix | Confidence |
|---|---|---|---|---|---|---|
| TC-038 | E | minor | The Pass applies only to the local copy at commit `efe2deb`. The case targets automationintesting.online and is linked to BUG-03. A reader of the Totals line ("Pass 1 (TC-038)") could take this as BUG-03 being fixed or not reproducible. | Report line 3 ("Results apply only to this local copy"), line 40 ("BUG-03 not reproduced on this local copy"), line 46 (Totals with no environment qualifier). CSV TC-038 Related bug = BUG-03. | Label the result "Pass (local only)" in the Totals line as well, and do not use it as evidence against BUG-03 until it is run on the demo host. | high |
| TC-038 | 2 / 8 | major | The oracle clause "Fail if other dates (for example today/tomorrow) are shown" is ambiguous. On the destination page the calendar opens on the current month (November 2026), and the current day appears highlighted. One tester could read that as "today shown" and mark Fail; another would mark Pass. The executor's statement "No today/tomorrow dates were shown" depends on the second reading and goes further than the evidence. | TC-038-3.yml line 106: calendar opens on `November 2026` after the click. TC-053-3.jpg shows how the room-page calendar looks on its opening month (26 November highlighted, no Selected bar). Report line 38. TC-001 step 6 also relies on "click Next until…", so opening on the current month is known behaviour, but TC-038 does not say it is acceptable. | Reword the case: only the URL, the Selected bar and the Price Summary count as "shown dates". The calendar opening on the current month with today marked is not a failure. | medium |
| TC-038 | 7 / 3 | minor | The case links AC1 ("are the dates that get booked") and its oracle says "Fail if … booked without the user selecting them". The case never submits, so neither can be checked. A defect where the Double page displays 5–7 April but books other dates would pass this case. | CSV TC-038 steps 1–4 (no Reserve Now). Report line 38 ("nothing was booked"); TC-038-network.txt shows no `POST /api/booking`. | Either remove AC1 and the "booked" clause, or add a submit step with an expected "Booking Confirmed" of 2027-04-05 - 2027-04-07. That needs its own free-dates precondition and data. | medium |
| TC-053 | 3 / 2 / 8 | blocker | **Weak oracle.** Branch 1 passes if "Check Out does not end up as 13/03/2027". The evidence shows that after step 2 Check Out is already `27/11/2026`, which is before Check In `15/03/2027`. Realistic defect: the picker disables days before Check In but never corrects the existing value. Check Out then stays 27/11/2026, branch 1 is met, and the case passes while the fields and the "Book now" links still hold a reversed range. Step 5's "If both dates were set" is ambiguous in exactly this situation: both fields hold values. Testers could also disagree on whether to evaluate step 2, because the case gives no expectation after Check In moves past Check Out. | TC-053-2.yml line 37 (Check In `15/03/2027`), line 40 (Check Out `27/11/2026`), line 65 (href `checkin=2027-03-15&checkout=2026-11-27`). Report line 16 and Notes line 25. AC11. | Branch 1 should require that, after step 3, Check Out is after Check In (or empty, with a prompt) and that the "Book now" hrefs do not carry `checkout` earlier than `checkin`. Add an expected result for step 2: after Check In moves past the current Check Out, Check Out is adjusted or cleared, or a message appears. Reword step 5 as "If Check Out is not after Check In, click Check Availability…". | high |
| TC-053 | 7 | minor | The oracle checks for negative nights and amounts in the Price Summary, which is AC2 behaviour. The case links only AC11, while TC-048 (the same Price Summary check, reached through the URL) links both AC11 and AC2. The confirmed `£100 x -2 nights … Total £-160` is therefore traced only to AC11 in the report. | CSV TC-053 AC ID = `AC11`. CSV TC-048 AC ID = `AC11, AC2`. TC-053-6.yml lines 204–215. Report line 22. | Add AC2 to TC-053's AC links, and to the BUG-02 reference in the result if the triage agrees. | high |
| TC-053 | E | minor | Report line 18 says there are "no `.alert` … elements". Every snapshot nevertheless contains an `alert` node at page root. It is empty, and probably the Next.js route announcer, but the report does not say so. A reviewer reading the YAML could think an alert was overlooked. | TC-053-1.yml line 226, TC-053-2.yml line 226, TC-053-3.yml line 283, TC-053-6.yml line 309: `- alert [ref=…]` with no text. | Add one line to the report: the root `alert` node is empty (route announcer), and the check was by CSS class `.alert` / `.invalid-feedback`. | medium (what this node is needs verification in the app) |

Verdict check (no comment raised):
- **TC-053 Fail is supported by the evidence.**
  - TC-053-3.yml lines 41–97: the date picker is open under Check Out, and every March cell is a plain `gridcell … [cursor=pointer]` with no disabled marker.
  - TC-053-1.jpg: no greyed-out days.
  - TC-053-4.yml line 40: Check Out = `13/03/2027`.
  - TC-053-5.yml line 65: the Single card's "Book now" link carries the reversed dates.
  - TC-053-6.yml lines 204–215 and TC-053-3.jpg: negative Price Summary.
  - TC-053-network.txt: no `POST /api/booking`.
- **TC-038 Pass is supported by the evidence.**
  - TC-038-2.yml lines 231–232 (ref `f35e307`): the Double card's link href.
  - TC-038-network.txt: the click led to `/api/room/2` and `/api/report/room/2`.
  - TC-038-3.yml line 39: heading `Double Room`.
  - TC-038-4.yml line 106: calendar on `April 2027`; lines 134–150: a `Selected` bar in the 04–10 row; lines 204–216: Price Summary `£300 / £25 / £15 / £340`.
  - TC-038-3.jpg: the bar visually spans 05–07, which matches the report and the PO-4 note.

### 2. Suite-level findings (limited to the two cases and the ACs they cover)

| Finding | Applies? | Reason |
|---|---|---|
| AC11 coverage by entry path | Does not apply as a gap | Typed dates are covered by TC-035, the picker by TC-053, URL tampering by TC-048, and same-day dates by TC-036. |
| Check In moved past an existing Check Out (the intermediate state in TC-053 step 2) | Applies | No case gives an expected result for it. TC-053-2.yml shows the app silently leaves a reversed range. |
| Reversed dates passed on through "Similar Rooms" | Applies | On the reversed-date room page, both "View Details" links carry `checkin=2027-03-15&checkout=2027-03-13` (TC-053-6.yml lines 232, 245). AC12 ("keeps the selected dates") is technically met, but invalid dates spread to other rooms. No case covers it, and the report did not record it. |
| AC12 from a room page without dates (Similar Rooms, then "View Details") | Applies | TC-038 only starts from a URL with valid dates; TC-039 covers the dateless page but not the Similar Rooms path from it. |
| Backend accepts a reversed availability query | Applies | `GET /api/room?checkin=2027-03-15&checkout=2027-03-13` returned 200 and listed all rooms (TC-053-network.txt line 7, TC-053-5.yml). No case covers API-level AC11 rejection; TC-048 covers only the booking submit. |
| Slow or dropped network, backend errors on room-page load | Applies | Both cases depend on `/api/room/{id}` and `/api/report/room/{id}` (network files). No case says what the room page shows if these fail. |
| Time of day and time zones | Applies (not triggered here) | The run was at about 23:22 UTC (17:22 CST), close to midnight UTC. Both cases use fixed 2027 dates, so they are not affected. Prefilled-date cases (TC-002) would be, and the run shows the prefill follows local time (TC-053-1.yml lines 37, 40). |
| Two sessions acting on the same data | Does not apply | Neither case submits a booking. |
| Refresh or Back on the reversed-date room page, or Back to the home page fields | Applies | Not covered. It is unknown whether Back restores `15/03/2027` / `13/03/2027` in the home page fields or the refreshed page recomputes the negative total. |
| Valid-looking but bad data (apostrophes, emoji, long values) | Does not apply | Neither case types any input. |

### 3. Summary

- **Cases reviewed:** 2 (TC-053, TC-038). Verdicts checked: TC-053 Fail is confirmed by the evidence; TC-038 Pass is confirmed by the evidence, for the local copy only.
- **Comments by check number:**
  - Check 3 (with 2/8 folded in): 1
  - Check 2/8: 1
  - Check 7: 2
  - Check E (execution result vs. evidence): 2
- **Comments by severity:** blocker 1, major 1, minor 4.

What I could not check, and why:
- **TC-053 cell details.** The `aria-disabled=false` value and the class string for 13 March (report line 17) appear in no evidence file. The snapshot (no disabled marker) and TC-053-1.jpg (no greyed-out days) support the same conclusion.
- **TC-038 calendar geometry.** The figures x=905, 138 px and `flex-basis: 42.8571%` (report line 36) appear in no evidence file. TC-038-3.jpg supports the conclusion visually.
- **Health check, commit hash and post-run data check.** Report lines 2–3 and 48–52 have no evidence file in scope. The claim that no booking was stored rests on the report and on the absence of `POST /api/booking` in both network files.
- **The URL of the TC-053 room page.** TC-053-6.yml has no URL. The URL comes from the report and TC-053-network.txt line 8, and is consistent with the "View Details" hrefs in that snapshot.
- **The report's reference to `bugs/README.md`** (line 40) is outside my allowed inputs and was not opened.
- **The empty root `alert` node** in the snapshots needs verification in the app.