# Peer review: runs/v2-run2.md (pass a)

- **Reviewer:** `peer-reviewer` subagent (.claude/agents/peer-reviewer.md), fresh context, Read tool only
- **Inputs given:** runs/v2-run2.md, reviewer/inputs/story-and-acs.md, reviewer/inputs/ui-map.md
- **Date:** 2026-11-24
- **Output below is unedited.**

---

## Peer review: /home/claude/ai-test-case-agent/runs/v2-run2.md

I read only the three input files:
- /home/claude/ai-test-case-agent/runs/v2-run2.md
- /home/claude/ai-test-case-agent/reviewer/inputs/story-and-acs.md
- /home/claude/ai-test-case-agent/reviewer/inputs/ui-map.md

### 1. Comments table

| Case | Check # | Severity | Comment | Reason / evidence | Suggested fix | Confidence |
|---|---|---|---|---|---|---|
| TC-001 | 3, 4 | major | The step 9 expectation "the same dates now appear as unavailable for this room" doesn't say where to look. The obvious place is the room calendar, but it never marks booked dates. One tester will mark Fail and another Pass. | UI map line 14: "Dates already booked by other guests are not marked on the calendar." | Replace with an observable check: go back to the home page, set the same dates, click "Check Availability", and confirm the Single card is not listed (UI map line 6). | high |
| TC-001 (also TC-034 step 4, TC-036 step 2) | 2 | major | "Check ... the dates shown on the room page" doesn't say where. The only date display on the room page is the calendar's "Selected" bar. The calendar always opens on the current month, so whether today+10..+13 is visible without clicking Next depends on the day of execution. | UI map line 14 | Say exactly what to check. The URL `checkin`/`checkout` must equal the chosen dates in YYYY-MM-DD. On the calendar, click Next until the "Selected" bar is visible, and confirm it covers exactly the expected nights. | high |
| TC-003, TC-004 | 4 | minor | The expected confirmation dates are written as "30 Jan – 02 Feb" and "30 Dec – 02 Jan". The app shows the range as YYYY-MM-DD - YYYY-MM-DD. | UI map line 18 | Write the exact expected string, e.g. "2027-01-30 - 2027-02-02". | high |
| TC-004 | 5 | major | "30 Dec (this year)" expires. On or after 30 Dec 2026 the check-in is in the past, and the case turns into a past-date test like TC-030. It also books the Single room, which collides with TC-001 (Single, today+10..+13) if run around 18-22 Dec. | Test Data of TC-004 and TC-001 | Use "the next upcoming 30 Dec" with explicit years. Give it a room/date range that no other Single case uses. | high |
| TC-005 to TC-024, TC-035 to TC-041 (booking-creating ones: TC-008, 009, 018, 020, 021, 022, 023, 037, 038, and TC-019/024/039/040 if the app accepts the input) | 5, 6 | major | These cases name no room and no dates. The home page fields are prefilled with today/tomorrow. A tester who doesn't change them books the same room and range in every case. From the second booking on, AC10 blocks the submit and the case fails for the wrong reason. Results depend on execution order. | UI map line 5 (prefilled today/tomorrow); AC10 | Give every booking-creating case its own room + date range in Test Data, and make the ranges unique across the suite. | high |
| TC-006 | 3 | major | "After reload: the dates are still available (not marked as booked)" can't detect the realistic defect (Cancel submits the booking), because the calendar never marks bookings. The case passes either way. | UI map line 14 | After Cancel, go to the home page, run "Check Availability" for the same dates, and confirm the room is still listed. Alternatively, complete a booking for those dates and expect "Booking Confirmed". | high |
| TC-007 | 3, 8 | major | "One clear error per field" is not in AC8 ("error messages are shown"), and the case doesn't mark it as an assumption. An empty field can produce two messages (required + length). Testers will disagree on whether that is a Pass. If the form uses native browser `required` validation, a browser tooltip may appear instead of the red box. | AC8; UI map line 17 (red bulleted box above Price Summary) | Expected: no "Booking Confirmed"; the red box above Price Summary lists at least one message for each of Firstname, Lastname, Email and Phone. Mark the per-field count as an assumption. Needs verification in the app for native validation. | medium |
| TC-010 | 3 | minor | "Dates stay available" can't be checked on the room page (bookings are not marked). | UI map line 14 | Drop this item, or verify via home page "Check Availability". | high |
| TC-011 to TC-016, TC-019, TC-024 | 2 | minor | "Clear ... message" has no location. TC-010 says "booking panel"; these cases don't. | UI map line 17 | Expected: the message appears in the red box above Price Summary and names the field. | medium |
| TC-013 | 5 | major | The Test Data says only "Lastname: 31 chars". The tester has to build the string, and a miscount to 30 gives a valid value, so the case fails wrongly. TC-009 already warns that counting is error-prone. | TC-013 Test Data | Give the literal: `Hernandezgutierrezdelacruzvegas` (31). | medium |
| TC-014 | 3 | major | The message location is not specified. If the email field uses native type=email validation, the browser shows a tooltip and the red box never appears. Testers will split on Pass/Fail. | UI map line 17 | State the expected location (red box). Add a branch for native browser validation, or flag the case "needs verification in the app". | low |
| TC-018 | 3 | minor | "Only one booking exists" can't be observed by a guest: there are no admin credentials, and the calendar doesn't show bookings. | UI map lines 14, 22 | Replace with observable checks: only "Booking Confirmed" is shown, and the earlier error box is gone. Mark the single-booking check as needing admin access. | high |
| TC-020 | 3, 5 | major | (a) The data `"  Ana  "` / `" Lee "` doesn't say whether to type the quotes. In a rendered markdown table, repeated spaces collapse, so the number of spaces is lost. (b) The oracle "either trimmed and accepted, or rejected" accepts any outcome except a crash. An untrimmed stored name can't be seen because the confirmation shows only dates. The case can't fail on trimming. | UI map line 18 | Spell the data as "2 spaces + Ana + 2 spaces" with no quotes. Either state the assumed rule as the expected result, or reclassify the case as an exploratory question for the PO. | medium |
| TC-021 | 3, 4 | minor | "No encoding artifacts in any displayed text" can't be checked: the guest flow never shows the name after submit. | UI map line 18 (confirmation shows dates only) | Remove that clause, or mark it as needing admin access. | high |
| TC-022 | 3, 5 | minor | "Length counted consistently" can't be tested with `Ana😀`. That is 4 code points or 5 UTF-16 units, and both are inside 3–18, so no boundary is exercised. The "either/or" oracle passes everything except a crash. | AC4 | To test length counting, put the emoji at the boundary, e.g. 17 letters + 1 emoji (18 code points, 19 UTF-16 units). State the assumed count. | medium |
| TC-023 | 5 | minor | The "Alt run (new dates)" packs a second execution into one case, with unspecified dates and an unstated length (`+44 (20) 7946-0958` = 18 chars). | TC-023 Test Data | Split it into two cases, each with its own room/dates and stated length. | high |
| TC-025 | 6 | major | The precondition "Single room already booked today+20 to today+23" has no setup. The tester has no admin access, so they must create the booking through the UI first, and the case doesn't say so. TC-026 and TC-027 depend on the same state. | UI map line 22; TC-026/027 preconditions | Add explicit setup steps: book Single today+20..+23 with named data and confirm "Booking Confirmed". State that TC-025–027 share this setup and must run in order. | high |
| TC-025 | 2, 4 | blocker | Step 2 can't be executed: after "Check Availability" the home page lists only available rooms, so the Single card will not be there to click. The expected "room calendar shows the dates as booked" contradicts the UI map. | UI map line 6 (lists only available rooms); line 14 (booked dates not marked) | Split it. (1) Home page: after Check Availability for the booked range, the Single card is not listed. (2) To test the booking check itself, open `/reservation/1?checkin=<today+20>&checkout=<today+23>` directly, submit valid data, and expect no "Booking Confirmed" plus an unavailability message. Remove the calendar expectation. | high |
| TC-026 | 2, 6 | blocker | Same problem. For today+22..+25 the Single card should not be listed, so "Book now on Single" is impossible. The case also depends on TC-025's undocumented setup. | UI map line 6 | Same split as TC-025, using the direct URL `/reservation/1?checkin=...&checkout=...` for the submit attempt. | high |
| TC-027 | 6 | major | Depends on run order. If TC-026 hits the realistic defect (the overlap is accepted), a booking for today+22..+25 exists and TC-027 fails falsely on today+23..+25. | TC-026 / TC-027 data | Run TC-027 before TC-026, or give TC-026 a range that doesn't cover today+23..+25 (e.g. today+19..+21). | medium |
| TC-028 | 2, 3 | major | (a) The expected "must not show a payable total for 0 nights (e.g. only £40 fees)" is ambiguous: is showing £40 the example of a defect or an acceptable display? (b) There is no branch for the date picker refusing a same-day Check Out, or for "Check Availability" listing no rooms. (c) "Book now" names no room. "Try to reserve with valid data" doesn't say to click "Reserve Now" twice. | AC11, AC2; UI map line 16 | Name the room. Give explicit branches: "picker blocks selection" means Pass and stop; otherwise continue. State exactly what the Price Summary must or must not show. Spell out the two Reserve Now clicks. | high |
| TC-029 | 2 | major | Same as TC-028: no room named, no branch for the picker blocking or auto-correcting Check Out, and "Try to reserve" is vague. | AC11; UI map line 5 | Same fix as TC-028. | medium |
| TC-030 | 2, 7 | minor | No room named, and no branch for the picker disabling past dates. AC1/AC11 don't cover past dates (the Notes admit this), so the AC links are loose. | AC1, AC11 | Name the room, add the picker branch, and link "assumption, no AC". | medium |
| TC-033 | 2, 3 | major | The expected result says "no booking possible with invalid dates", but no step tries to book. "Observe the page" is vague, and no room ID is given. A defect that lets you book with garbage dates would go unnoticed. | AC12; UI map line 10 | Steps: open `/reservation/1?checkin=abc&checkout=2020-13-45`; check the Price Summary for NaN or negative values; click Reserve Now, fill valid data, click Reserve Now; expect no "Booking Confirmed". | high |
| TC-034 | 3 | major | "Dates A remain available" has no way to be checked (the calendar doesn't mark bookings), and "the same room" is not named. | UI map line 14 | Name the room. Verify A via home page "Check Availability" for range A: the room is still listed. | high |
| TC-035 | 3, 6 | major | The precondition "Booking just confirmed" relies on another case and gives no dates. Step 2 is conditional ("If the form is shown again"), so when the form isn't shown the case passes without testing anything. "No second booking" can't be observed. | UI map lines 18, 22 | Make the case self-contained: book a named room/range, press Back, and record exactly what is shown. If a room page appears, click Reserve Now, submit the same data, and expect no "Booking Confirmed". Then check that "Check Availability" for that range doesn't list the room. | medium |
| TC-036 | 8 | minor | Step 2 checks "form state", but the expected result says nothing about it (form closed or open; values kept or cleared). The ACs are silent. | AC3, AC12 | State the assumed post-refresh form state and mark it as an assumption. | medium |
| TC-037 | 3 | blocker | "Exactly one booking created" can't be observed from the guest UI. The realistic defect (a double-click creates two bookings) would pass, because the guest sees one confirmation either way. | UI map lines 14, 18, 22 | Keep the observable checks: only "Booking Confirmed" is shown, with no red box and no error page. Mark the booking count as "needs admin/API access", or get admin credentials for this case. | high |
| TC-039 | 5 | blocker | The data is written as HTML entities (`&lt;script&gt;alert(1)&lt;/script&gt;`). A tester reading the raw file types the entity text literally. That is 37 characters, so the Lastname length check rejects it and the injection is never tested. | TC-039 Test Data; AC5 (max 30) | Write the literal value in a code span: `<script>alert(1)</script>` (25 chars). | high |
| TC-039 | 3 | major | The oracle only covers reflected execution on the guest page. The guest flow never renders the Lastname after submit, and the place where stored XSS would fire (admin) is not reachable. A stored-XSS defect would pass. | UI map lines 18, 22 | State that the case covers immediate reflection only. Add "stored rendering needs admin access". | high |
| TC-040 | 3 | minor | "No other bookings affected" can't be observed by a guest. | UI map lines 14, 22 | Remove it, or mark it as needing admin access. Keep "no database error text in the panel". | high |
| TC-042 | 5 | major | Single today..today+1 is exactly the home page's prefilled range, so any earlier case that didn't change the dates has already taken it. "Today" is also ambiguous: the tester's local date vs. the app/server date (UK pricing). Near midnight, or in the evening in UTC-6, "today" may already be "yesterday" for the server, and the result varies with the time of execution. | UI map line 5; policies line 11 (check-in 3–8 PM) | Use a room no other case books for today. Record the execution time and time zone. Add a branch for runs after the 8 PM check-in cutoff. | medium |

### 2. Suite-level findings

**Coverage gaps**
- **AC12, "from any path": applies.** No case reaches the room page through "View Details" in "Similar Rooms You Might Like" (UI map line 19), the breadcrumb (line 11), or "Return home" followed by a new booking (line 18). Only "Book now", a direct URL and browser Back are covered. "View Details" is the most likely path to drop the dates.
- **AC11 via URL: applies.** TC-028/029 only use the home page picker. No case opens `/reservation/{id}?checkin=X&checkout=Y` with checkout equal to or before checkin to see whether the room page enforces the rule. TC-033 uses garbage values only.
- **AC10 at the room/server level: applies.** Every AC10 case goes through the home page filter (UI map line 6). No case submits already-booked dates through a direct URL, which is the realistic way to get past the filter (see TC-025/026 comments).
- **AC10 at the home page level: applies.** No case asserts that a booked room disappears from the "Check Availability" results. That is the only guest-visible signal of AC10 in the UI map.
- **AC6 depth: applies.** There is one invalid format (TC-014) plus `bad@` in TC-017/041. There is no case for a missing TLD (`a@b`), spaces, or a double @. There is no valid-but-unusual address (plus addressing, subdomain, apostrophe in the local part, or a long address).
- **AC9 details: applies, minor.** No case asserts the exact text "Your booking has been confirmed for the following dates:", the YYYY-MM-DD - YYYY-MM-DD format, or the "Return home" button (UI map line 18).
- **AC2 longer stays: applies, minor.** The longest stay tested is 3 nights. There is no stay of 7+ nights or one spanning several calendar months.
- **Manual date entry: applies.** The fields accept DD/MM/YYYY (UI map line 5). No case types a date by hand, and none checks day/month confusion (e.g. 03/04 read as March 4), which feeds AC1.

**Conditions the suite ignores**
- **Slow or dropped network during submit: applies.** There is no case for going offline or throttled between the two Reserve Now clicks, or for a retry after a timeout. A retry is a realistic way to create duplicate bookings. It can be simulated with DevTools.
- **Backend errors (5xx) on submit: applies.** No case checks what the panel shows when the booking request fails. This needs request blocking or mocking in DevTools; mark as needs verification.
- **Time of day and time zone: applies.** The suite uses relative dates (today, yesterday, today+N) without saying whose "today" counts. The check-in window (3–8 PM, UI map line 11) is ignored. See the TC-030/TC-042 comments.
- **Two sessions on the same data: partly covered.** TC-038 covers two tabs submitting the same range. There is no case where tab 2 opened the room page before tab 1 booked and then refreshes.
- **Refresh/Back during submit: applies.** TC-035/036 cover Back/Refresh after confirmation and before submit, but not during an in-flight submit.
- **Data that looks valid but isn't: partly covered.** Accents, apostrophes, emoji, whitespace, script and SQL are covered for names. Not covered: values far above the maximum (e.g. 1,000 characters, or pasted text with line breaks), and accents/apostrophes in Email.
- **Shared demo data: likely applies, sources don't confirm.** The preconditions "room free for the dates" can't be checked on the room page (UI map line 14). If other users book on the same public instance, they can take a case's dates. The suite gives no way to verify or recover, such as re-checking with "Check Availability" right before the run. Needs verification of how the environment is shared or reset.
- **Admin-side checks: do not apply to guest execution.** Admin credentials are not provided (UI map line 22). Every oracle that depends on counting or inspecting stored bookings has to be rewritten or marked as needing admin access.

### 3. Summary

- **Cases reviewed:** 42 (TC-001 to TC-042).
- **Comments:** 32 table rows. Some rows cover more than one case.
- **By severity:** 4 blocker (TC-025, TC-026, TC-037, TC-039 data), 18 major, 10 minor.
- **By check number** (a row tagged with two checks is counted under each):

| Check | Comments |
|---|---|
| 1 (duplicates) | 0 |
| 2 (ambiguous steps) | 8 |
| 3 (weak oracle) | 16 |
| 4 (unsupported UI claims) | 4 |
| 5 (unusable data) | 8 |
| 6 (hidden dependencies) | 5 |
| 7 (traceability/category) | 1 |
| 8 (expected result vs. ACs) | 2 |

- **Duplicates:** none found after a second pass. TC-018 step 1 repeats TC-010's input on purpose as a setup step. TC-035 and TC-037 both target duplicate submission, but through different triggers.
- **Main pattern:** most findings trace back to three facts in the UI map:
  - the room calendar doesn't show bookings;
  - the home page hides booked rooms after "Check Availability";
  - guests can't see stored bookings.

  Many oracles ("dates remain available", "only one booking exists", "calendar shows booked") can't be observed as written.

**What I could not check (needs verification in the app):**
- Whether the form uses native browser validation (`required`, type=email), which changes where messages appear (TC-007, TC-014).
- Whether the date picker blocks past, same-day or reversed dates (TC-028–030, TC-042).
- Whether the room page calendar can change the selected dates.
- What browser Back does after confirmation (TC-035).
- Whether the public instance is shared or reset, which affects every "room free" precondition.
- Server time zone.
- Anything that needs admin access: booking counts, stored name rendering, stored XSS.
