# Triage: peer review of v1 run 1 (pass a)

- **Triaged by:** Jose Serna (QA lead), 2026-11-24
- **Review triaged:** `v1-run1-review-a.md` (31 comments)
- **Scope of this triage:** the 7 highest-priority comments, meaning all blockers plus the comments that contradict the earlier human review. The other 24 comments were not triaged.

## Recall against the earlier human review

The earlier review of v1 (`evaluation/reviews/v1-run1-review.csv`, human decisions with an AI peer-review column) flagged 11 problems:
- 3 duplicates: TC-007, TC-029, TC-040
- 5 weak oracles: TC-014, TC-015, TC-016, TC-017, TC-037
- 3 ambiguity or verification gaps: TC-002, TC-032, TC-036

**The reviewer found all 11 (recall 11/11).** It also added 20 comments that were not in the earlier review.

## Triaged comments

| # | Case(s) | Reviewer severity | Comment (short) | Decision | Note |
|---|---|---|---|---|---|
| 1 | TC-014, 015, 016, 017, 037 | blocker | Weak oracle: "booking not created" also passes when the page crashes | **Accepted, refined** | The expected result must separate two outcomes: rejected with a clear message (Pass) and the page crashes or errors (Fail, high severity). They are different bugs with different severity. |
| 2 | TC-026 | blocker | Same room as TC-001 with overlapping dates, so it fails under AC10 with no defect | **Accepted** | Not related to the environment outage. Each case must create its own preconditions (its own room and date range) instead of depending on another case. |
| 3 | TC-033 | blocker | Stored XSS can't be detected: the Lastname is never shown and there is no Admin access | **Accepted** | Split into TC-033a, reflected (no script runs in the booking panel or the error box; executable now), and TC-033b, stored (Blocked until Admin access, for example on a local copy of the app). The earlier review had marked this case "Agree". |
| 4 | TC-035 | blocker | Three invalid fields in one submit; if the server validates only one, the case still passes | **Accepted** | One invalid value per case. The earlier review had marked this case "Agree". |
| 5 | TC-036 | blocker | Duplicate booking can't be verified without Admin | **Accepted** | Use DevTools Network to count the booking requests. Matches the earlier review. |
| 6 | TC-030 | major | "A URL copied earlier" already carries dates, so the no-dates scenario is never tested | **Accepted** | Use `/reservation/1` with no query string. The earlier review had marked this case "Agree". |
| 7 | TC-030 | major | "Shows valid dates or asks" accepts a page that picks dates the user never chose (against AC12) | **Accepted** | Expected result: the page asks for dates before a booking can be made. |

**Precision on the triaged subset: 7/7 accepted** (two with refinements from the QA lead).
**Contradictions:** in 4 of the 7, the reviewer disagreed with an earlier "Agree", and the QA lead sided with the reviewer every time.

## Rules for prompt v4

These are general rules. None of them describes a known bug.

1. **The oracle distinguishes the outcomes.** For any rejected action, "rejected with a clear message and the page still usable" is a different result from "error page, crash or endless loading".
2. **One invalid value per case.** All other fields stay valid, so every validation rule is tested on its own.
3. **Dates and independence:**
   - Valid bookings use dates at least 30 days after the execution date, with a date range unique to each case.
   - Cases about past or invalid dates use explicit dates on purpose.
   - Every case creates its own preconditions and never depends on another case having run.

## Consistency: pass a vs. pass b

Pass b (`v1-run1-review-b.md`) ran on 2026-11-24 with the same three inputs, in a new context.

| | Pass a | Pass b |
|---|---|---|
| Comments | 31 | 33 |
| Blockers | 5 | 7 |
| Earlier human review findings (11) | 11/11 | 11/11 |
| The 7 triaged comments, found again | n/a | **6/7** |

- **The one triaged comment that pass b did not repeat:** TC-035, "three invalid fields in one submit". Pass b raised other points on TC-035 (validation attributes not in the UI map, Lastname has no value), but not this one.
- **Same finding, different severity:**
  - TC-030 "URL already has dates": major in pass a, blocker in pass b.
  - TC-014 hidden dependency: major in pass a, blocker in pass b.
  - TC-037 weak oracle: blocker in pass a, major in pass b.

  The findings are stable, but the severity labels are not.
- **New in pass b, not in pass a:**
  - "No case covers which dates get booked when the guest changes the selection on the room page calendar" (AC1). The reviewer found this from the UI map alone, and it is the scenario behind a real bug found during exploration (BUG-06).
  - Pick a day of the month above 12, so a day/month swap can't go unnoticed.
  - Price Summary format not backed by the UI map.
  - Test data management as a suite-level gap.

**Reading:** the important findings are consistent (11/11 in both passes, 6/7 of the triaged ones repeated). Each pass also adds a few findings of its own, so two passes find more than one. Severity varies between passes, so the QA lead's severity call should prevail.

## Next

- Reviews of v2 and v3 (run 1 and run 2), to check whether the reviewer tells the versions apart.
