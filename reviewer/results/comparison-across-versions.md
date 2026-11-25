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
| v4 run 1 | 46 | 17 | 0.37 | 1 | 11 | 5 | 0 (one near-duplicate noted) |
| v4 run 2 | 46 | 21 | 0.46 | 3 | 10 | 8 | 0 |
| v5 run 1 | 45 | 21 | 0.47 | 0 | 9 | 12 | 0 |
| v5 run 2 | 43 | 19 | 0.44 | 0 | 8 | 11 | 0 |

## Reading

- **It does tell the versions apart.** Blockers go from 5–7 (v1) to 4–6 (v2) to 1–2 (v3). Comments per case drop from about 0.8 (v1, v2) to 0.50–0.58 (v3). Duplicates disappear after v1. That matches the human evaluation, in which v3 was the best version.
- **v2 is not clearly better than v1 by comment count.** It is better on duplicates and blockers, but it has as many comments per case. This fits what the human evaluation found: v2's new instructions fixed the oracles but introduced UI claims it could not know (L-17). The reviewer flagged several of those claims ("the calendar shows the dates as unavailable", "the calendar spans both months").
- **Both v3 run 1 blockers are expired dates.** The suite was generated on 2026-10-19, and by 2026-11-24 TC-001 and TC-004 are in the past. That is a test-data shelf-life problem (L-26), not a design defect at generation time. Counting only design defects, v3 run 1 has 0 blockers.
- **The reviewer rediscovered a known human finding without being told about it.** In both v2 runs it flagged the HTML-escaped XSS payload (`&lt;script&gt;`) as a blocker. The human review had found the same issue (L-18).

## v4 vs. v3 (added 2026-11-24)

v4 changed only the instructions (see `prompts/CHANGELOG.md`). Same model (Opus 5.5, effort Medium), new chat outside any project, two runs.

- **Fewer comments per case:** 0.37–0.46 in v4 against 0.50–0.58 in v3.
- **Blockers did not drop:** 1–3 in v4 against 1–2 in v3 (and both v3 run 1 blockers were expired dates). By blocker count alone, v4 is not better.
- **What v4 did fix.** None of these appear in either v4 run:
  - expired or colliding dates;
  - cases that depend on another case having run;
  - either/or oracles;
  - HTML-escaped data.

  The reviewer confirmed that the date allocations don't overlap within each suite. v4 also added environment-failure cases (offline, slow network, refresh during submit), and both runs explained their gaps in the "Not covered" section.
- **What the v4 blockers are.** They are subtler than before:
  - an XSS payload (`<script>`) that would not run even if the bug existed (run 1);
  - a price oracle that misses NaN and £0 (run 2, TC-030);
  - a double booking still unobservable after a refresh (run 2, TC-042).
- **A side effect of the new instructions (L-17 again).** The rules "say whether browser blocking counts as Pass" and "use 'question for the product owner' when the ACs don't decide" created new contradictions:
  - Truncation is called Pass in the notes but Fail in the inherited expected result (run 2).
  - "No prompt = question for the PO" softens AC12 into a non-failure (run 2, TC-034).
  - TC-019 and TC-043 disagree on rejected apostrophes (run 1).

  The rules fixed the vague oracles, but they added verdict rules that conflict with each other.
- **Still open from the recurring list:**
  - stored XSS can't be observed from the guest UI;
  - the booking count can't be observed after a refresh or double submit;
  - there is no re-run rule for the shared demo data.

**Reading:** v4 removed the structural problems that the reviewer had flagged in every earlier version. The remaining problems are about consistency between verdict rules and about choosing payloads and oracles that actually detect a defect. A v5 should address verdict consistency (one suite-level rule, applied everywhere) rather than add more case-level rules.

## v5 vs. v4 (added 2026-11-24)

v5 changed only the instructions: one set of verdict rules for the whole suite (L-29), and security payloads that would actually run (L-31). Same model and setup, two runs.

- **Blockers: 0 in both runs,** against 1–3 in v4. This is the first version with no blockers.
- **Comments per case: 0.44–0.47,** the same range as v4 (0.37–0.46). v5 did not reduce the total amount of feedback; it moved it from blockers to major and minor comments.
- **Both runs followed the new format.** Both open with a "Verdict rules" section. Each run also introduced shared notation on its own (run 1: `AVAIL`, `CONF`, `R1–R7`; run 2: a named availability check), which made the cases shorter and more uniform.
- **Security cases fixed.** Both runs used `<img src=x onerror=alert(1)>` and checked the DOM. The reviewer still notes that stored XSS can't be seen without admin access, and that a text search for "onerror" can give a false Fail (run 2).
- **Verdict contradictions: fewer, not zero.**
  - Run 1 still had two: the 10-second endless-loading rule against a case note that calls no feedback a Question, and a truncation rule broad enough to excuse a defect.
  - Run 2 resolved both in its suite rules (a valid value that gets cut is Fail; a date-shift procedure for Blocked cases), but left the endless-loading limit undefined under throttling.
- **A recurring problem the v5 rules don't address: "Same steps as TC-0xx".** Both v4 run 2 and v5 run 2 wrote negative cases as "Same steps as" a base case whose steps include its own data ("leave Firstname empty"). A tester following the steps literally gets the wrong input. This is a candidate rule for v6: a case that reuses another case's steps must not inherit its data.
- **Still open across all versions:** stored values and stored XSS can't be seen without admin access; reruns on a shared, persistent demo collide with earlier bookings.

**Reading:** v5 achieved what it targeted: no blockers, consistent suite-level rules, working security payloads. The remaining comments are mostly ambiguity in individual steps rather than defects that would let a bug pass. The next gains are more likely to come from the environment (a local copy with admin access, which would let the suite check stored values and booking counts) than from more prompt rules.

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

- Only v1 has two reviewer passes; v4 has two generator runs with one review each. v2 and v3 have one pass per run, so the differences between runs of the same version are partly reviewer variation.
- Comment counts are a rough measure. A comment's weight depends on its content.
- Only v1 has a human triage (7 comments). The v2 and v3 comments have not been triaged, so their precision is unknown.
