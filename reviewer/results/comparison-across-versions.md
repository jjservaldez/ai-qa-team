# Peer reviewer: results across prompt versions

- **Date:** 2026-11-24
- **Reviewer:** `peer-reviewer` subagent. Each review ran in its own fresh context, with the same ACs and UI map as inputs.
- **Question:** does the reviewer tell the versions apart? If the prompt improved from v1 to v3, the reviewer should flag fewer and less severe problems in v3.

## Numbers

| Version / run | Cases | Comments | Comments per case | Blockers | Major | Minor | Duplicates flagged |
|---|---|---|---|---|---|---|---|
| v1 run 1, pass a | 40 | 31 | 0.78 | 5 | 17 | 9 | 3 pairs |
| v1 run 1, pass b | 40 | 33 | 0.83 | 7 | 21 | 5 | 3 pairs |
| v2 run 1 | 44 | 36 | 0.82 | 6 | 12 | 18 | 1 |
| v2 run 2 | 42 | 32 | 0.76 | 4 | 18 | 10 | 0 |
| v3 run 1 | 48 | 28 | 0.58 | 2 | 15 | 11 | 0 |
| v3 run 2 | 46 | 23 | 0.50 | 1 | 13 | 9 | 0 |

## Reading

- **It does tell the versions apart.** Blockers go from 5–7 (v1) to 4–6 (v2) to 1–2 (v3). Comments per case drop from about 0.8 (v1, v2) to 0.50–0.58 (v3). Duplicates disappear after v1. That matches the human evaluation, in which v3 was the best version.
- **v2 is not clearly better than v1 by comment count.** It is better on duplicates and blockers, but it has as many comments per case. This fits what the human evaluation found: v2's new instructions fixed the oracles but introduced UI claims it could not know (L-17). The reviewer flagged several of those claims ("the calendar shows the dates as unavailable", "the calendar spans both months").
- **Both v3 run 1 blockers are expired dates.** The suite was generated on 2026-10-19, and by 2026-11-24 TC-001 and TC-004 are in the past. That is a test-data shelf-life problem (L-26), not a design defect at generation time. Counting only design defects, v3 run 1 has 0 blockers.
- **The reviewer rediscovered a known human finding without being told about it.** In both v2 runs it flagged the HTML-escaped XSS payload (`&lt;script&gt;`) as a blocker. The human review had found the same issue (L-18).

## Findings that appear in every version

These recur in v1, v2 and v3, so the generator prompt doesn't fix them yet. They are candidates for prompt v4.

1. **"No booking is created" or "only one booking" can't be observed.** There is no Admin access, and the calendar doesn't show bookings. A double submit or a stored booking would go unnoticed. Suggested oracle: count requests in DevTools Network, or check availability again from the home page.
2. **Stored XSS can't be detected from the guest UI.** Only the reflected check can run. The stored check stays Blocked until Admin access is available.
3. **Dates:** no date-allocation plan, ranges that collide, data that expires, and "today" without a time zone.
4. **Booked rooms are filtered out after "Check Availability",** so AC10 cases that click "Book now" on a booked room can't be executed. The submit attempt has to go through the direct room URL.
5. **Native browser validation vs. the red error box.** Whether a tooltip counts as a Pass is never decided.
6. **Conditions the generator ignores:** slow or dropped network, backend errors, refresh during a submit. These match the gap analysis against the 10 scenarios.

Points 3 and 1 match two of the three v4 rules the QA lead set in the v1 triage: fixed dates or unique ranges, and an oracle that separates a rejection from a crash.

## Limits of this comparison

- Only v1 has two passes. v2 and v3 have one pass per run, so the differences between runs of the same version are partly reviewer variation.
- Comment counts are a rough measure. A comment's weight depends on its content.
- Only v1 has a human triage (7 comments). The v2 and v3 comments have not been triaged, so their precision is unknown.
