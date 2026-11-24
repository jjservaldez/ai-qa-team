# Peer review: runs/v3-run1.md (pass a)

- **Reviewer:** `peer-reviewer` subagent (.claude/agents/peer-reviewer.md), fresh context, Read tool only
- **Inputs given:** runs/v3-run1.md, reviewer/inputs/story-and-acs.md, reviewer/inputs/ui-map.md
- **Date:** 2026-11-24
- **Output below is unedited.**

---

Peer review of /home/claude/ai-test-case-agent/runs/v3-run1.md (48 cases)
Sources: /home/claude/ai-test-case-agent/reviewer/inputs/story-and-acs.md and /home/claude/ai-test-case-agent/reviewer/inputs/ui-map.md. Review date: 2026-11-24. The suite was generated on 2026-10-19.

The suite has two blockers. TC-001 and TC-004 use dates that are already in the past, so neither can be run as written. The other recurring problems are expected results that conflict with their own notes, oracles that can't see the defect they target, and some date-dependent data that expires within days.

### 1. Comments table

| Case | Check # | Severity | Comment | Reason / evidence | Suggested fix | Confidence |
|---|---|---|---|---|---|---|
| TC-001 | 5 | blocker | The test dates 09/11/2026–11/11/2026 are now in the past. Step 6 says "click Next once (to November)", which only worked when the calendar opened on October. | UI map: the calendar "always opens on the current month". In November one Next shows December. The note covers dates already being taken (+7 days), not dates in the past. | Use future dates relative to the run date, or say "run date + N days". Change step 6 to "click Next until November 2026". | high |
| TC-001 (applies to all cases with Price Summary) | 4 | minor | The exact format "£100 × 2 nights = £200" is not in the sources. A tester could mark Fail if the app shows the same values in another layout. | The UI map only lists the parts: "nightly rate × number of nights, cleaning fee, service fee and total". | Check the values (rate, nights, line amount, £25, £15, total), not the exact string. | medium |
| TC-002 | 6 | major | The precondition "Double room free for tonight" can't be checked as written. Step 2 does not click "Check Availability", and the calendar does not mark booked dates. On the shared demo the Double may already be booked tonight. One tester then logs a Fail, another logs blocked. | UI map: booked dates are "not marked on the calendar". "Our Rooms" is filtered only "after Check Availability". | Add a step: click "Check Availability" without changing the dates and confirm the Double card is listed. If it is not, mark the case blocked. | medium |
| TC-003 | 6 | minor | There is no precondition that the Suite is free on 07–10/12/2026. If it is booked, the Suite card is missing after step 3 and step 4 can't be done. | UI map: after "Check Availability" only available rooms are listed. | Add "Suite free for those dates" or open the room URL directly. No booking is needed here. | high |
| TC-004 | 5 | blocker | Check-in 2026-11-23 is already in the past, so the expected Price Summary (£240) and the happy-path behavior no longer hold. | The case data compared with the review date 2026-11-24. | Use future dates and state that they depend on the run date. | high |
| TC-005 | 5 | major | The dates 2026-11-26–28 expire within two days of this review. | The case data compared with the review date. | Use dates relative to the run date. | high |
| TC-005 | 4 | major | The expected result for Cancel ("form fields and Cancel are hidden; Reserve Now is visible") is not supported. AC3 and the UI map only say that Cancel exists. The note marks only field retention as unknown. | AC3; UI map "Reserve Now" bullet. | Mark the Cancel behavior as an assumption, or confirm it with the PO. | high |
| TC-005 | 3 | minor | "No booking was created" has no step that checks it. | Steps 1–6 only look at the panel. | Add a step: on the home page set 26–28/11, click "Check Availability", and confirm Single is still listed (as TC-045 step 5 does). | high |
| TC-007 | 3 | major | Defect that slips through: the input has a maxlength below the AC limit (for example 15) and cuts the value. The booking is still confirmed, so the case passes. The note says to check this, but no step or expected result does. | AC4, AC5, AC7. The expected result checks only "Booking Confirmed". | Add a step after typing: each field contains the full value (18, 30 and 21 characters). | high |
| TC-008 (also TC-016) | 3 | minor | "No garbled characters" can't be observed. The confirmation panel shows only the date range, not the name. | UI map success panel: the text plus the YYYY-MM-DD range. | Check the typed fields before submit, or say that stored spelling can't be verified without Admin. | high |
| TC-011, TC-012 | 5 | minor | The dates start on 30/11/2026 and 30/12/2026, within 6 and 36 days of this review. They will soon fail as past dates. | The case data compared with the review date. | Use dates relative to the run date. Keep the month and year boundary. | high |
| TC-018 | 8 | major | The expected result says "No Booking Confirmed", but the note says "If accepted, raise as a defect/clarification". The ACs say nothing about trimming. Testers will disagree on Pass, Fail or Blocked when the booking is accepted. | AC4 sets length only. The note conflicts with the expected result. | State one verdict, for example "Blocked – PO clarification" if accepted, or mark the case as assumption-based and non-gating. | high |
| TC-019 (also TC-020, 023, 024, 027, 028) | 2 | minor | It is unclear whether the bullet must mention the range ("3–18") or only "length". A message like "Firstname too short" would be judged differently. | The notes say the exact text is not specified. | Write: "one bullet that refers to Firstname length; the wording is not checked." | medium |
| TC-020 (also TC-024, TC-028) | 2 | major | If the field blocks typing past the limit, the 18/30/21-character value is submitted and booked. The expected result says "No Booking Confirmed" (Fail), but blocking the input also meets the AC. TC-020's note says only "record it". TC-024 and TC-028 have no note at all. | AC4, AC5 and AC7 do not say how the limit is enforced. | Add a branch: if the input stops at the limit, Pass when the field holds exactly 18/30/21 characters, and do not submit. | high |
| TC-025 (also TC-026, TC-030) | 2 | major | The TC-025 note accepts a browser-native tooltip instead of the red box. The expected result requires "exactly one bullet" in the red box. TC-026 (`maria@`) and TC-030 (four errors including `maria@`) have the same risk and no note. In TC-030 a native block means the red box never shows four errors. | UI map: errors appear in the red box. Native validation is not mentioned, so it needs verification in the app. | Choose one rule for native validation (acceptable or Fail) and apply it to all three cases. In TC-030, use an email that passes native checks but is invalid by the AC, or check it separately. | medium |
| TC-031 (also TC-032, TC-033) | 2 | major | "A clear message says the dates are not available" has no location and no definition of "clear". The sources do not describe how a conflict is shown (red box? other?). | The UI map describes only validation errors and success. AC10 does not say how the rejection looks. | Write: "an error that names unavailable or already-booked dates appears in the panel; the wording is not checked." Mark the location as an assumption. | medium |
| TC-032 | 6 | major | The precondition booking 2027-02-15–17 has no setup step, unlike TC-015 and TC-031. If it does not exist, 16–18 is booked and the tester marks a false Fail. | Compare the preconditions of TC-015 and TC-031. | Add: "create it via /reservation/1?checkin=2027-02-15&checkout=2027-02-17 with valid data". | high |
| TC-033 (also TC-034) | 7 | minor | Both are labeled "Security" but test concurrency and duplicate submission. | The case content. The listed categories include no concurrency category. | Relabel them Edge/Boundary, or add a concurrency label if the suite allows one. | medium |
| TC-034 | 3 | major | Defect that slips through: the double click sends two POSTs and both are stored, or the second fails silently. The UI still shows one "Booking Confirmed", so the case passes. | The note admits that counting bookings needs Admin. | Add a check in the DevTools Network tab for the number of booking requests sent, or mark the persistence part as not verifiable. | high |
| TC-035 | 2 | major | The expected result says "a booking with valid data must not reach Booking Confirmed", but step 5 never submits a booking. It is also undefined whether the date picker auto-correcting Check Out is a Pass. | Steps 1–5 compared with the expected result. AC11. | Add submit steps to step 5. List auto-correction as an explicit Pass or Fail outcome. | high |
| TC-036 | 8 | major | The case accepts only "a clear message" with no picker-prevents branch, while TC-035 accepts that branch for the same rule. "If possible" in step 4 leaves it unclear whether skipping step 4 passes the case. | AC11. Compare with TC-035. | Use the same acceptable outcomes as TC-035 and define what to do when "Book now" is not offered. | high |
| TC-037 | 7 | minor | AC11 is linked, but past dates are not AC11 (Check Out after Check In). The precondition "Today is 19/10/2026" is stale. | AC11 wording. Review date 2026-11-24. | Link no AC (assumption) and change the precondition to "dates before the run date". | high |
| TC-037 | 8 | major | The expected result says "No Booking Confirmed", but the note says "If the booking is confirmed, raise with the PO", so the verdict is unclear. A picker that disables past dates is not listed as an outcome. | The ACs say nothing about past dates. The note conflicts with the expected result. | State one verdict (for example Blocked pending the PO) and add "picker prevents selection" as an acceptable outcome. | high |
| TC-042 | 2 | major | Step 4 expects the home page after Back, but the UI map does not say whether the confirmation changes the URL or history, so Back may return to the room page. Step 5 clicks "Check Availability" without setting 19–21/04/2027. If the fields reset to today and tomorrow, the "Single not listed" check is meaningless. | The UI map is silent on URL or history at confirmation. The home fields are "prefilled with today and tomorrow". | Expect "the previous page loads normally". In step 5, set the dates explicitly before clicking. | medium |
| TC-044 | 3 | minor | "Price Summary (if shown)" and "no second Booking Confirmed triggered by the refresh" do not say what the page should show after the refresh. A second stored booking would not be visible. | The UI map is silent on the state after a refresh. | State the expected page after refresh (the room page for the same URL). Say that duplicate storage can't be checked without Admin or the Network tab. | medium |
| TC-045 | 7 | minor | AC8 (invalid fields) does not match a refresh test. Step 4 checks the calendar, but there is no expected result for it. | AC8 wording. Expected result for step 4. | Link AC1 only, or mark it as an assumption. Add the expected calendar state, or remove the calendar from step 4. | high |
| TC-046 | 3 | major | Defect that slips through: stored XSS. Names are never shown in the guest UI, since the confirmation shows only dates. "No bold text anywhere" and "no alert" would pass even if the payload runs in Admin. | UI map success panel. Admin credentials are not provided. | Limit the expected result to "no alert or rendering in guest-facing pages". Mark the stored-XSS check as blocked until Admin access is available. | high |
| TC-048 | 2 | minor | "Negative/zero-night totals presented as payable" is subjective. Step 2 does not say what a correct state looks like. | The expected result for step 2. | Write: "Price Summary shows no negative or zero night count, or shows a prompt to select valid dates". | medium |

No duplicates found (check 1). I did a second pass on checks 1–3. TC-001, TC-011, TC-012 and TC-013 differ in ways that matter (month boundary, year boundary, far future). TC-042, TC-043 and TC-044 test different navigation.

### 2. Suite-level findings

**Coverage gaps**
- **AC10, overlap variants (applies).** Not covered: a new range that fully contains an existing booking; a new range that ends on an existing check-in day (the reverse of TC-015); and a booking in a different room on the same dates, which must still succeed.
- **AC12, other paths (applies).** Only View Details (TC-038) and the URL (TC-039–041) are tested. The top-nav "Rooms"/"Booking" links and the breadcrumb "Rooms" link have no case.
- **AC8, single required fields (applies).** An empty Lastname, Email or Phone is tested only together with other empty fields in TC-029. No case shows each "required" error alone.
- **AC6, invalid formats (applies).** Only "no @" and "no domain" are tested. Missing: no TLD (`maria@example`), an embedded space, a double @, and an empty local part.
- **AC7, character content (applies).** There is no case with letters in Phone (for example 12 letters). The AC defines length only, so this should be raised with the PO.
- **AC11 via URL with the same day (applies).** TC-048 covers reversed dates in the URL. Check In equal to Check Out in the URL is not covered.
- **Unicode length at the boundary (applies).** No case puts accented or emoji characters at exactly 18, 19 or 30 characters.

**Conditions**
- **Slow or dropped network during submit (applies).** There is no case, but it can be simulated with DevTools offline or throttling.
- **Backend errors (applies).** There is no case for a 5xx response on submit. Forcing one needs network tooling, so it needs verification of what is possible.
- **Time of day and time zones (applies).** The home dates are prefilled with "today". The app is UK-based (£), and testers in UTC-6 cross the UK date line after 18:00 local time. TC-002 notes the 8 PM check-in policy but not time zones.
- **Two sessions on the same data (applies).** Covered by TC-033 only.
- **Refresh or Back during a submit (applies).** Only before and after a submit are covered (TC-042, 044, 045).
- **Data that looks valid but isn't (applies).** Apostrophes, accents, emoji, spaces and SQL/HTML input are covered. Very long input far beyond the limits (thousands of characters) is not.
- **Expiring dates in the whole suite (applies).** TC-001 and TC-004 are already past. TC-005 and TC-011 expire within a week. TC-002 and TC-037 hard-code 19/10/2026. TC-001 step 6 depends on the current month.
- **Re-runnability on the shared demo (applies).** Every positive case books fixed dates. A second execution (retest or regression) will hit "already booked" and give false Fails, unless the demo resets its data, which needs verification in the app.
- **"Room free" preconditions with no check method (applies).** TC-033, 034, 042–044, 046 and 047 give no way to confirm the room is free. TC-031 steps 2–3 show the method to reuse.

### 3. Summary
- **Cases reviewed:** 48.
- **Comments:** 28.
  - By check: #1 = 0, #2 = 7, #3 = 6, #4 = 2, #5 = 4, #6 = 3, #7 = 3, #8 = 3.
  - By severity: blocker 2, major 15, minor 11.
- **What I could not check, and why:**
  - **Needs verification in the app:** whether browser-native email validation or input maxlength exists (TC-020, 024, 025, 026, 028, 030), how a conflict error is shown (TC-031–033), the URL and history behavior after confirmation (TC-042, 044), whether the demo data resets, and the Cancel behavior (TC-005).
  - **Not possible without Admin credentials (not provided per the UI map):** stored values, stored-XSS rendering and booking counts (TC-008, 016, 034, 046).
