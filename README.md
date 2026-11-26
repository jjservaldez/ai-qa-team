# AI QA Team

A team of AI agents that design, review and run manual test cases, led by a human QA lead. The case study tests a real booking flow end to end. Every prompt, run, review and verdict is in this repo, unedited.

**App under test:** Shady Meadows B&B booking flow ([restful-booker-platform](https://github.com/mwinteringham/restful-booker-platform)) · **QA lead:** Jose Serna, QA Engineer

## The team

| Role | Status | What it does | Where |
|---|---|---|---|
| **Designer** | Live | Writes manual test cases from a user story, its acceptance criteria and a UI map | [prompts/](prompts/) (v1–v5, v6 draft) |
| **Peer Reviewer** | Live | Independent second set of eyes. Read-only, clean context. Reviews generated suites *and* execution results | [.claude/agents/peer-reviewer.md](.claude/agents/peer-reviewer.md) · [reviewer/](reviewer/README.md) |
| **QA Lead** (human) | — | Approves prompts, triages every review comment, owns severity and verdict rules, talks to the PO | [lessons-learned.md](lessons-learned.md) |
| **Executor** | Prototype | Runs the cases in a browser and records evidence. So far an agent session run by hand; the next step is Playwright MCP | [runs/execution-*](runs/) |
| **Data Validator** | Built, not wired in | Checks booking data with SQL; its `--check` mode is verified by mutation | [shady-meadows-sql](https://github.com/jjservaldez/shady-meadows-sql) |
| **Reporter** | Planned | Drafts bug reports from the Executor's evidence, then sends them back through the Reviewer | — |

```
Designer → Peer Reviewer → QA Lead → Executor → Peer Reviewer (on results) → QA Lead → bug reports + PO decision log
```

## Results

### Designing: 5 prompt versions, measured by the reviewer

| | v1 | v2 | v3 | v4 | v5 |
|---|---|---|---|---|---|
| Reviewer blockers per run | 5–7 | 4–6 | 1–2 | 1–3 | **0** |
| Review comments per case | 0.78–0.83 | 0.76–0.82 | 0.50–0.58 | 0.37–0.46 | 0.44–0.47 |

Two runs per version, each in a fresh chat. v1 is one run reviewed twice. Before the reviewer was trusted, it was measured against my own review of v1: it found 11 of my 11 findings in both passes, and I accepted all 7 of the comments I triaged. Details: [reviewer/results/comparison-across-versions.md](reviewer/results/comparison-across-versions.md)

### Executing: 52 cases on a local copy of the app (2026-11-25)

| Suite | Cases | Time (agent) | Pass | Question | Fail |
|---|---|---|---|---|---|
| Smoke | 8 | 3 min 44 s | 5 | 1 | 2 |
| Regression | 16 | 4 min 29 s | 0 | 3 | 13 |
| Full | 28 | 8 min 55 s | 19 | 5 | 4 |

- **Every known bug that the cases cover reproduced, except BUG-03.** BUG-03 did not reproduce on this build.
- **BUG-01 now has a cause backed by evidence:** the server answers 409, and the frontend throws a TypeError reading that response.
- **The run found 6 new candidates (CAND-10 to CAND-15).** The worst is CAND-15: a double click sends two POSTs. The booking is created, but the user sees an error page.
- **Stored data matches what the UI showed:** 32 bookings, one for each "Booking Confirmed". No rejected case stored anything, and there were no double bookings.
- **The Peer Reviewer also reviewed the results:** 3 of my 52 verdicts changed because I had applied my own rules inconsistently, plus a set of method fixes.

Runs: [Smoke](runs/execution-2026-11-25-smoke.md) · [Regression + Full](runs/execution-2026-11-25-regression-full.md) · Reviews: [reviewer/results/](reviewer/results/)

### Key findings

1. **A second agent finds what the first one misses, but the human decides.** The reviewer's severity labels weren't stable between passes, so every comment goes through my triage (L-30).
2. **Every prompt fix created a new failure mode.** For example, verdict rules written per case contradicted each other, so they moved to one suite-level rule (L-17, L-29).
3. **More prompt rules stopped paying off after v4.** The next gain came from the environment: a local copy with stable data and network and console access (L-24).
4. **A "Question" still gets a ticket.** If no AC covers a behavior, the verdict is Question. It is still reported, with "Needs PO decision", and the PO's answer becomes the evidence (L-33).
5. **The highest-severity bug came from a person.** No prompt version found [BUG-06](bugs/BUG-06.md), where the displayed price drops but the original stay is booked.

## Bugs

| ID | Severity | Summary | Status (2026-11-25) |
|---|---|---|---|
| [BUG-01](bugs/BUG-01.md) | High | A rejected booking (409) crashes the page | Reproduced on local by 6 cases; network and console evidence |
| [BUG-02](bugs/BUG-02.md) | High | Invalid date range gives negative or zero-night prices | Reproduced on local (client-side; the server rejects these ranges) |
| [BUG-06](bugs/BUG-06.md) | High | Clicking a calendar date lowers the price, but the original range is booked | Reproduced on local (shows £190, books £490) |
| [BUG-03](bugs/BUG-03.md) | Medium | "View Details" loses the dates | **Not reproduced on local build**; verify on demo |
| [BUG-04](bugs/BUG-04.md) | Medium | Names made only of digits are accepted | Reproduced · **Needs PO decision** (no AC requires letters) |
| [BUG-05](bugs/BUG-05.md) | Low | Error messages don't name the field | Reproduced against AC8 (clarified, PO confirmation pending) |
| [BUG-07](bugs/BUG-07.md) | Low | "Amenities" link goes nowhere | Reproduced · **Needs PO decision** (outside this story) |

New candidates from the local run: past dates are booked (CAND-08); the calendar shades the check-out day (CAND-10); spaces count toward name length (CAND-11); a room URL without dates spins forever (CAND-12); invalid dates show £NaN (CAND-13); a missing room returns 500 (CAND-14); double submit (CAND-15). Each report in [bugs/](bugs/README.md) keeps its October evidence and adds a local re-test section. See also [CANDIDATES.md](bugs/CANDIDATES.md) and the [PO decision log](bugs/PO-DECISIONS.md).

## Environment and how to run it

The public demo (automationintesting.online) is shared, resets its data and has been down since 2026-11-23. **The evidence lives in this repo, not in the demo.** The 2026-11-25 run used a local copy pinned to a known version:

| | |
|---|---|
| App | restful-booker-platform, commit `efe2deb` (2026-10-23) |
| Tools | JDK 27, **Maven 3.9.14** (3.10 rejects the project's version format), Node 24 |
| Run | `bash build_locally.sh` once, then `bash run_locally.sh` → http://localhost:3003 |
| Health check before every run | `GET /api/room/1`, `/2`, `/3` return 200 (L-24) |

To re-run the suite, reset the data first by restarting `run_locally.sh` without `-e`. The cases use fixed dates and would collide with earlier bookings.

## Method

1. **Exploratory testing** with screen recordings. Acceptance criteria were written from observed behavior, because there are no official requirements: [exploration.md](exploration.md)
2. **Prompt versions** that each change one documented thing. Prompt files contain only what is sent to the model; notes are in the [changelog](prompts/CHANGELOG.md).
3. **Clean runs:** every generation runs in a new chat with no project context, so the model never sees the known bugs.
4. **Peer review** by the reviewer agent. It reads only the files it is given and never edits them. I triage every comment.
5. **Execution** against a pinned local build. Each case records method, timing and evidence, and there is a data check through the API afterwards.
6. **Verdict rules defined once for the whole suite** (Pass / Fail / Blocked / Question). Behavior with no AC goes to the PO decision log, not to a silent Pass.

## What I'd do differently

- **Start on an environment I control.** Two recurring review findings, colliding reruns and stored XSS I couldn't see, were environment limits, not prompt problems. I spent two prompt versions learning that.
- **Write the verdict rules down completely before executing.** All three verdicts the reviewer changed came from applying my own rules inconsistently, and two rules ("wording only" and "outside oracle") were only written down partway through the run.

## Lessons learned

33 lessons, each with what happened, the lesson and what changed: [lessons-learned.md](lessons-learned.md). A few:

- **L-07:** reaching the scenario isn't the same as detecting the bug. The expected result decides.
- **L-09:** polished AI output lowers the reviewer's guard.
- **L-24:** check that the environment is healthy before a run. A working home page doesn't mean the flow works.
- **L-33:** a Question verdict still gets a ticket.

## Repository structure

```
.claude/agents/   peer-reviewer subagent
prompts/          Designer prompts v1–v6 and CHANGELOG
runs/             raw generator output per version, and execution results
reviewer/         reviewer inputs, unedited reviews, cross-version comparison
evaluation/       rubric reviews and the v1–v3 analysis
bugs/             bug reports with screenshot evidence
test-suite/       final 52-case suite (Smoke / Regression / Full) with traceability
exploration.md    acceptance criteria, observed rules, bug log
lessons-learned.md
```

## Limitations

- Two runs per prompt version. More runs would give a firmer consistency figure.
- The Executor is still an agent session I run by hand. Its timings are agent speed, not a manual estimate, and some fields were set by script instead of typed. Each case records its method.
- The reference bugs were found by the same person who reviewed the output.
- The local build and the public demo can differ (BUG-03, CAND-10). Each finding records which environment it was seen in.

## Next steps

1. **Executor with Playwright MCP**, measured against a timed manual Smoke run.
2. **Reporter with Jira.** Bug drafts go through the Reviewer, and I approve them before any ticket is created.
3. **API tests with Postman and Newman in CI.**
4. **Skills that package the process:** environment health check, running a prompt version, bug report template.
