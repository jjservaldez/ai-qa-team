# Peer Reviewer agent

A second AI agent that reviews the test cases produced by the generator, before a human does. It runs as a Claude Code subagent (`.claude/agents/peer-reviewer.md`), in its own context, with **read-only access** (the `Read` tool only).

The reviewer comments; it doesn't fix or decide. The QA lead accepts or rejects each comment.

## Why it exists

A single model reviewing its own output shares its own blind spots. In the v1 evaluation, a first human review scored 40/40 and a second, targeted peer review still found 11 problems (duplicates, ambiguous steps, weak oracles). The reviewer agent makes that targeted second pass systematic, and it is measured against the human reviews to see how much of it can be trusted.

## Inputs

The reviewer only reads the files it is given:

| File | Content |
|---|---|
| `runs/<version>-run<n>.md` | The generated test cases to review (raw generator output) |
| `reviewer/inputs/story-and-acs.md` | User story and AC1–AC12 |
| `reviewer/inputs/ui-map.md` | What the live app shows (screens, labels, messages, URL format) |

All versions are reviewed against the **same** ACs and UI map, so the results are comparable across versions.

**Independence:** the human reviews (`evaluation/`), `lessons-learned.md`, `bugs/` and `exploration.md` are never passed to the reviewer. Run it in a fresh Claude Code session that is not attached to any project holding those notes.

## How to run one review

In a new Claude Code session on this repo, ask:

```
Use the peer-reviewer agent to review these test cases:
- Test cases: runs/v1-run1.md
- Acceptance criteria: reviewer/inputs/story-and-acs.md
- UI map: reviewer/inputs/ui-map.md
Save its full output, unedited, to reviewer/results/v1-run1-review-a.md
```

Repeat with `-review-b` for the second pass of the same version (LLM output varies between runs).

## Planned runs

| Version | Input | Passes |
|---|---|---|
| v1 | `runs/v1-run1.md` | a, b |
| v2 | `runs/v2-run1.md`, `runs/v2-run2.md` | a, b |
| v3 | `runs/v3-run1.md`, `runs/v3-run2.md` | a, b |

## How it is evaluated

For each review, the QA lead adds two columns to the comments table: **Accepted?** (yes / no / verify in app) and **Reason**. Then compare with the human review of the same version (`evaluation/reviews/`):

- **Recall:** human findings the reviewer also found ÷ human findings
- **Precision:** accepted comments ÷ all comments
- **Unique findings:** accepted comments the human review missed
- **Consistency:** overlap between passes a and b
- **Trend:** the reviewer should flag fewer problems in v3 than in v1. If it flags the same amount everywhere, it isn't telling versions apart.

**Decision rule (set before the first run):** the reviewer is useful as a standard step if recall ≥ 70% and precision ≥ 70%, with no false blockers.

**Overfitting guard:** if the reviewer prompt is changed after these runs, the final check uses v3 cases with planted defects that were never used while tuning it.
