---
name: run-prompt-version
description: Run and evaluate a new version of the test-case Designer prompt end to end. Covers preparing the prompt, two clean runs, saving raw output, the peer review, the cross-version comparison and the QA lead's triage. Use when creating, running or comparing a prompt version (v6, v7, ...).
---

# Run a Designer prompt version

This packages the process used for v1–v5. Each step exists because skipping it once produced a misleading result; the lesson IDs point to [lessons-learned.md](../../../lessons-learned.md).

## 0. Before writing the prompt
- **One change per version (L-14).** If a version changes two things, the changelog must say why both still map to separate metrics.
- **General heuristics only (L-13).** No hint describes a known bug ("check the price is never negative"). Rules must transfer to another app.
- **Source of each change:** the previous version's review, the triage, or a lesson. Write it down.

## 1. Prepare the files
1. Create `prompts/vN.md` with **only the text sent to the model** (L-15). Notes, titles and "changes from" lines go in the changelog, never in the prompt file.
2. Keep the **user section identical** to the previous version, unless the change being tested is in the input. Diff it: `diff <(sed -n '/^## User/,$p' prompts/vN-1.md) <(sed -n '/^## User/,$p' prompts/vN.md)`.
3. Add a `## vN` entry to `prompts/CHANGELOG.md` with: the changes, the source of each, whether it is one variable or two, the target metrics, and the status ("draft, not run yet").
4. **The QA lead approves the prompt before it runs.**

## 2. Run it twice, clean (L-06, L-16)
The QA lead runs it. The agent doesn't run the generator itself, because that would change the environment (model, context, tools).
- Use a **new chat outside any project**, with no files attached. Paste the prompt file unchanged.
- Record the model and the effort. Keep them the same as the previous version, unless the model is the variable.
- Do **2 runs**, each in its own new chat.

## 3. Save the raw output (L-27)
Save each run as `runs/vN-runK.md`, **unedited**, under this header:

```markdown
# vN-runK

| Field | Value |
|---|---|
| Prompt | [vN](../prompts/vN.md), pasted unchanged |
| Model | <model>, effort <effort> |
| Date | <YYYY-MM-DD> |
| Context | New chat outside any project, no files attached |
| Account memory / past-chat search | <on/off or "Not recorded (UNKNOWN)"> |
| Output | <what came back: sections, number of cases> |
```

Never fix the output to make it runnable. Fixes go into the execution copy (sheet or test-suite), not into the run file.

## 4. Peer review each run
Use the `peer-reviewer` subagent once per run, giving it **only** these paths:
- `runs/vN-runK.md`
- `reviewer/inputs/story-and-acs.md`
- `reviewer/inputs/ui-map.md`

Save its output **unedited** as `reviewer/results/vN-runK-review-a.md`, with a short header saying who reviewed it, which inputs it read, the date, and "output below is unedited".

## 5. Compare across versions
In `reviewer/results/comparison-across-versions.md`:
1. Add one row per run to the **Numbers** table: Cases · Comments · Comments per case (2 decimals) · Blockers · Major · Minor · Duplicates flagged.
2. Add a `## vN vs. vN-1` section that covers:
   - did the targeted metric move, in both runs;
   - what got worse (L-17: every fix can create a new failure mode);
   - any recurring finding that is a candidate rule for the next version;
   - a one-paragraph reading.
3. Report both runs and the spread between them. Never judge a version on a single run.

## 6. Triage (QA lead)
- The QA lead accepts or rejects each reviewer comment and owns the final severity (L-30). Severity labels from an LLM aren't reliable on their own.
- New lessons go in `lessons-learned.md` (what happened · lesson · applied).
- A recurring finding becomes the candidate rule for vN+1.

## 7. Ship it
- Branch `add-prompt-vN`; commit the prompt, changelog, runs, reviews, comparison and lessons.
- Open a PR and merge it with **"Create a merge commit"**.

## Checklist
- [ ] One documented change; no known-bug hints
- [ ] Prompt file holds only prompt text; changelog entry written
- [ ] QA lead approved the prompt
- [ ] 2 clean runs, saved unedited with headers
- [ ] 2 peer reviews, saved unedited
- [ ] Comparison table + vN vs vN-1 section updated
- [ ] Triage done; lessons and next candidate rule recorded
- [ ] PR merged
