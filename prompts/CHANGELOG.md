# Prompt changelog

Prompt files contain only the text that is pasted or sent to the model. Notes about each version live here.

## v1 (baseline)
- Senior QA role, anti-hallucination rule (flag assumptions), categories, fixed table format.
- User input: user story, AC1–AC12, room prices.
- Note: run 1 was pasted including the file title "Prompt v1 — Generador de test cases (baseline)". Low impact, but the title is no longer in the file.

## v2
Changes from v1 (instructions only; the user input is identical, so the comparison isolates the effect of the instructions):
1. Oracle rules: expected results must list everything that must hold, including user feedback and app state.
2. Intermediate checks: verify displayed values at each step, not only the final outcome.
3. Real-user scenario checklist.
4. No duplicates; navigation method and verification point must be explicit.

The hints are generic testing heuristics, not descriptions of the defects found in exploration (see lessons-learned L-13).

## v3
Changes from v2:
1. User input: added an "Application UI" map written from the exploration sessions (pages, sections, buttons, URL format, where errors and confirmations appear, what the room calendar shows). It describes what exists, not what fails. Target metrics: hallucinations (unflagged UI assumptions) and reaching BUG-03 through the real user path.
2. Instructions: test data must be literal plain text (no HTML escaping, no described values). Target metric: executability.

This changes two things at once (see L-14). They target different metrics, so each effect can still be attributed.

## v4
Changes from v3 (instructions only; the user input, including the UI map, is identical to v3, so the comparison isolates the effect of the instructions):
1. Oracle: "rejected with a clear message" and "error page / crash / endless loading" are separate outcomes; only expect what the tester can observe, and give an observable check or a "cannot verify" note when access is missing; one verdict rule per case (no "either/or" oracles); say whether browser-level blocking counts as Pass or Fail.
2. Independence and data: each case creates its own preconditions; one invalid value per negative case; give an alternative route when an earlier step can hide the element a later step needs.
3. Dates: relative to the execution date; successful cases at least 30 days ahead; a unique resource and date range per case; time zone stated when "today" matters.
4. Real-user scenarios: added failures around the application (slow or dropped network, server error response, refresh during submit).
5. Output: after the table, a "Not covered" section listing the scenarios not included and why.

Sources: the QA lead's triage of the v1 peer review (three rules), the findings that the peer reviewer flagged in v1, v2 and v3 alike (`reviewer/results/comparison-across-versions.md`), and the gap analysis against ten scenarios AI usually misses. All rules are generic heuristics, not descriptions of known defects (L-13).

Target metrics: fewer reviewer blockers, no unobservable oracles, no colliding or expiring dates, and coverage of the environment-failure scenarios.

## v5
Changes from v4 (instructions only; the user input, including the UI map, is identical to v4):
1. Suite-level verdict rules: the output starts with a "Verdict rules" section that defines Pass, Fail, Blocked and Question once, and every case follows it. "Question" is never used for behavior an AC requires. The treatment of browser-level blocking is decided once for the suite, and a value cut to a valid length is not submitted. The agent checks that similar cases reach the same verdict. Replaces the per-case verdict instructions of v4. Source: L-29 (per-case rules contradicted each other in v4).
2. Security payloads: use payloads that would run or visibly change the page if the input were handled unsafely, check the page's elements in DevTools, and note where a displayed value can't be checked. Source: L-31 (a `<script>` tag inserted as HTML never runs).

This changes two things at once (see L-14). They target different metrics (verdict consistency and security-case strength), so each effect can still be attributed.

Target metrics: no contradictory verdict rules between cases, no "Question" applied to required behavior, and security cases whose payload could actually detect a defect.

## v6 (draft, not run yet)
Changes from v5 (instructions only; the user input, including the UI map, is identical to v5):
1. Reused steps: a case may say "Same steps as TC-0xx" only if those steps contain no test data or field-specific actions; otherwise it writes its steps out in full. Source: L-32 (in v4 run 2 and v5 run 2, negative cases inherited "leave Firstname empty" from their base case; 8 major comments).
2. Waiting limits: the Verdict rules section defines how long to wait before a loading state counts as endless loading, with and without throttling. Source: the v5 run 2 review (no limit under Slow 3G, so testers would disagree on Fail).

This changes two things at once (see L-14). Both target the same metric (steps two testers execute the same way), so they are measured together; the reviewer's check #2 (ambiguous steps) is the main signal.

Target metrics: no "Same steps as" that inherits data, explicit waiting limits for every network case, and fewer check #2 comments than v5 (v5: 7 in run 2).

Status: drafted 2026-11-24. Expected gain is small (see `reviewer/results/comparison-across-versions.md`, "v5 vs. v4"); a local environment with admin access is the bigger next step.
