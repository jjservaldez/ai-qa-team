# Peer review: runs/v4-run1.md (pass a)

- **Reviewer:** `peer-reviewer` subagent (.claude/agents/peer-reviewer.md), fresh context, Read tool only
- **Inputs given:** runs/v4-run1.md, reviewer/inputs/story-and-acs.md, reviewer/inputs/ui-map.md
- **Date:** 2026-11-24
- **Output below is unedited.**

---

## Review of /home/claude/ai-test-case-agent/runs/v4-run1.md (46 cases)

Sources used: /home/claude/ai-test-case-agent/reviewer/inputs/story-and-acs.md (AC1–AC12) and /home/claude/ai-test-case-agent/reviewer/inputs/ui-map.md. I opened no other files.

The suite is in good shape on the basics. The boundary lengths are counted correctly: 18/19 Firstname, 30/31 Lastname, 21/22 Phone, 25 characters for the script payload, 18 for the SQL payload, 18 for the formatted phone. All price totals match AC2. Within one run, the date allocations per room never overlap. The problems are mostly oracles that would miss a real defect, verdict rules that contradict each other, and the suite's reliance on shared demo data.

### 1. Comments table

| Case | Check # | Severity | Comment | Reason / evidence | Suggested fix | Confidence |
|---|---|---|---|---|---|---|
| TC-002 (also TC-001, TC-004) | 6 | major | The "not listed at step 3 → Blocked, re-run +200 days" fallback can hide a real defect. TC-001 books Double ED+31→ED+34 just before TC-002 looks for Single on ED+31→ED+32. If booking one room wrongly makes the other rooms unavailable for those dates, TC-002 is recorded as Blocked, not Fail. | AC10 limits the block to "a room". UI map line 6: the list shows only available rooms. The Notes of TC-001, TC-002 and TC-004 treat a missing room as shared demo data. | Before recording Blocked, check whether this suite has booked a different room on overlapping dates. If it has, record Fail (AC10). Also add an explicit cross-room case (see section 2). | medium |
| TC-003, TC-005–TC-046 | 6 | major | Every case needs its room to be free on its dates in a public, shared database. Only TC-001, TC-002 and TC-004 say what to do if the room is not listed at step 3. In the other cases one tester will record Fail, another Blocked, and another will pick new dates. | TC-001 Note ("the shared demo data has it booked"). UI map line 14: booked dates are not marked on the calendar. | Add one suite-level precondition with the Blocked rule and the date-shift rule, and point to it from every case. | high |
| TC-008, TC-013, TC-014, TC-018 | 3 / 8 | major | The expected result asks for a "required/blank" message. An empty field also fails the length rule (AC4, AC5, AC7) or the format rule (AC6). If the app shows only "size must be between 3 and 18", one tester will pass and another will fail. | AC4–AC7 combine "required" with a length or format rule. The cases already admit the wording is an assumption. | State which outcome passes: any message naming the field, or a required message specifically. | medium |
| TC-019 | 8 | major | The verdict rule contradicts the rest of the suite. TC-019 is Happy path and treats a rejected apostrophe as Fail. TC-043 (Lastname with apostrophes) and TC-021 (symbols) treat a rejection as a question for the product owner. The ACs say nothing about allowed characters. | AC4 and AC5 restrict length only. Compare the Notes of TC-021 and TC-043. | Mark the expected result as an assumption and use one rule for rejected characters across TC-019, TC-020, TC-021 and TC-043. | high |
| TC-022, TC-024, TC-037 | 7 | minor | AC links don't match what is tested. TC-022 links AC12, but it tests a double booking, not date carry-over. TC-024 links AC11, but a back-to-back stay has nothing to do with the Check Out > Check In rule. TC-037 links AC8, but no field is invalid. | AC8, AC11 and AC12 text. | Remove AC12 from TC-022, AC11 from TC-024 and AC8 from TC-037. | high |
| TC-022 (step 5), TC-023 (step 5), TC-025, TC-026, TC-028, TC-034, TC-039, TC-041 (step 7), TC-044 | 5 | major | These URLs are relative (no base URL), and most of them don't say how to write ED+n in the URL. Only TC-022 and TC-025 say YYYY-MM-DD. Testers type dates as DD/MM/YYYY everywhere else in the suite, so some will put DD/MM/YYYY in the URL and get different results. | UI map line 10: the URL uses YYYY-MM-DD. UI map line 5: the home page fields use DD/MM/YYYY. | Write the full URL, https://automationintesting.online/reservation/{id}?checkin=YYYY-MM-DD&checkout=YYYY-MM-DD, with one worked example. | medium |
| TC-022, TC-023, TC-025, TC-026, TC-027, TC-028, TC-032, TC-033, TC-039, TC-040 | 2 / 4 | major | These cases require a "clear" message about unavailable, invalid or missing dates. No source describes such a message. The UI map only defines the red validation box. Only TC-022, TC-025, TC-033 and TC-040 mark it as an assumption. "Clear" is subjective: a generic red box saying "Failed to create booking", or no message with no confirmation, will be judged differently by different testers. | ACs 10, 11 and 12 only say "cannot be booked", "must be after" and "asks the user to select". UI map line 17. | Mark it as an assumption everywhere. Define the minimum pass: no "Booking Confirmed", plus a visible message in the panel that mentions dates or availability. Say whether "no message, nothing happens" is a Fail or a question for the product owner. | medium |
| TC-025 | 3 | minor | The Price Summary check ("any total shown equals nights × £100 + £40 for the nights shown") passes when the app takes the absolute value of a reversed range and shows "2 nights, £240" for ED+65→ED+63. | AC2 and AC11: a reversed range has no valid nights. | State that a positive night count for a reversed range is a Fail, or say it is not judged at step 2. | medium |
| TC-027 | 2 | major | Step 2 says "Type", but the expected result accepts "the date picker won't let you choose". Typing gets around the picker. The case also doesn't cover a date field that quietly corrects Check Out (for example to ED+91). The tester would then get "Booking Confirmed" for dates they never chose and mark Fail, even if correcting the date is acceptable. | UI map line 5 (typed field plus picker). AC1. | Say whether the dates are typed or picked. Add the auto-correct outcome: pass only if the corrected dates are visible before submit and match the confirmation. Needs verification in the app. | low |
| TC-029 | 2 | major | ED is defined as the Europe/London date, but the prefilled fields probably use the browser's local date. A tester in UTC-6 sees a different date for about 6 hours every evening, not only "near midnight". The case doesn't say whether that is a Pass or a Fail. | UI map line 5: "prefilled with today and tomorrow", no time zone given. TC-029 precondition and Notes. | Set the browser time zone explicitly (DevTools > Sensors) or define ED as the local date. Give the verdict for the case where the two dates differ. | medium |
| TC-032 | 3 | major | Step 2 ("Read the panel and Price Summary") has no expected result. The most likely AC12 defect is a room page that quietly defaults to today→tomorrow and shows £140. The case doesn't judge that until step 3, and at step 3 a confirmation is only a Fail if it happens. | AC12: "keeps the selected dates or asks the user to select them". UI map line 14: the calendar opens on the current month. | Step 2: Pass if no dates are shown as selected and no total is shown, or if a prompt to select dates is shown. Fail if it shows a price for dates the tester did not choose. | high |
| TC-035 | 4 / 2 | minor | Step 7 mentions "Home (in the breadcrumb or top navigation)". The top navigation has no Home item. "If needed" and "the page shown" (step 6) have no expected result. The POST count in step 4 is not limited to the booking request. | UI map line 4: the top navigation is Rooms, Booking, Amenities, Location, Contact, Admin. | Remove "top navigation". State which page Back should show. Filter the Network panel to the booking request. | high |
| TC-038 | 3 | major | Without throttling, the second click of a double-click most likely lands after the panel has been replaced. A form with no protection against double submission would still pass. | UI map line 18: the panel is replaced when the booking succeeds. The case has no throttling step. | Set "Slow 3G" before step 4 and keep the rest of the oracle. | medium |
| TC-039 | 1 | minor | The two submissions happen one after the other, not at the same time. Tab B makes the same server request as TC-022 step 6, because the room page doesn't load availability. The calendar doesn't mark booked dates. The title promises a concurrency test that the steps don't run. | UI map line 14. TC-022 steps 5–6. | Retitle it as a "stale page" check or merge it into TC-022. A real race needs a tool. Record it as not covered. | medium |
| TC-042 | 3 | major | The case passes whatever the code does. Lastname is never shown to the guest (the confirmation shows only dates), and a `<script>` tag inserted via innerHTML doesn't run in modern browsers. "Any alert = Fail" can never trigger. Its High priority overstates what it checks. | UI map line 18 (confirmation content) and line 22 (no admin access). | Retitle it "Script-like Lastname is accepted without error", use `<img src=x onerror=alert(1)>` (28 characters, within 3–30), lower the priority, and record stored XSS as not covered. | medium |
| TC-044 | 3 | blocker | The URL parameter is where the input could actually be reflected on screen, but the `<script>` payload doesn't run when inserted as HTML. A reflected-XSS defect would pass. "The raw script is not rendered as markup" doesn't tell the tester how to check. | UI map line 10 (the dates come from the URL into the page). | Use `checkin=<img src=x onerror=alert(1)>`. Check in the Elements panel that no injected `<img>` element exists. Use the full URL with checkout in YYYY-MM-DD. | medium |
| TC-046 | 7 / 4 | minor | The title says "keyboard only", but steps 3–4 click "Book now", "Reserve Now" and Firstname. "Visible focus indicator" is in neither the ACs nor the UI map, and it is not marked as an assumption. | AC3, AC9. TC-046 steps 3–4. | Either reach and open the form with Tab/Enter, or retitle it. Mark the focus indicator as an assumption. | high |

### 2. Suite-level findings

**Coverage gaps**
- **AC6, email format (applies).** There is only one invalid format (no "@", TC-015). Missing invalid formats: no local part (`@example.com`), no domain (`maria@`), two "@", spaces inside or around the address. There is also no valid-but-unusual address (plus sign, subdomain, upper case).
- **AC8, several invalid fields at once (applies).** No case submits with several fields invalid or all empty. AC8 says "error messages" (plural), so the red box should list every field.
- **AC10, overlap variants (applies).** Only "new stay starts inside the existing one" (TC-023) is covered. Missing: new stay ends inside the existing one, new stay fully contains it, same check-in with a different check-out. There is also no explicit case showing that booking one room leaves the other rooms bookable on the same dates (see the TC-002 comment).
- **AC1 and AC12, other paths to the room page (applies).** Not covered:
  - Typing dates and clicking "Book now" without clicking "Check Availability".
  - Changing the dates after "Check Availability" and before "Book now".
  - Top navigation "Rooms" → card → "Book now".
  - Breadcrumb "Rooms" from a room page.
  - Back from the room page and Forward again.
- **AC7, phone content (applies, as an assumption).** No phone made of letters (for example 11 letters). The ACs restrict length only, so the expected result would be an assumption.
- **AC2, date arithmetic (applies, minor).** No stay across 29 Feb 2028 (reachable from today) and no long stay (for example 30 nights).

**Ignored conditions**
- **Re-running the suite (applies).** Most cases book real dates in a shared database that the suite never cleans up. A retest of TC-001 on the same day finds the room booked. Re-running, or spreading the run over more than a day or two, makes later windows land on dates booked earlier, for example Double ED+35 after a 3-day shift. Whether the demo resets its data needs verification in the app. The suite should state a re-run rule.
- **Browser time zone (applies).** Only TC-029 thinks about time zones. A common defect parses YYYY-MM-DD as UTC midnight and shows the day before in UTC-x zones. Run TC-001 with the browser set to a UTC-x zone and a UTC+x zone.
- **Backend errors, 5xx (applies, partly).** The "Not covered" note is reasonable. DevTools request blocking only reproduces what TC-040 already does. A real 5xx needs a proxy or mock and should be listed as a known risk.
- **Slow or dropped network (applies).** Covered by TC-040 and TC-041. TC-038 should also use throttling.
- **Two sessions on the same data (applies, partly).** TC-039 is sequential (see above). A true simultaneous submit can't be done by hand. Admin-side changes do not apply: no credentials (UI map line 22).
- **Refresh or Back during and after submit (applies).** Covered by TC-035, TC-036, TC-037 and TC-041. Back while a submit is in progress is not covered.
- **Valid-looking but invalid data (applies).** Accents, apostrophes, emoji and symbols are covered. Not covered: leading or trailing spaces in Email, very long pasted values (for example 1000 characters) if the fields have no maxlength. Whether they do needs verification in the app.
- **Policy times of day (does not apply).** Check-in 3–8 PM and check-out by 11 AM appear only as policy text (UI map line 11). No AC ties booking to them.
- **Other browsers and mobile (does not apply).** No AC or UI map entry requires them. Date picker behaviour (TC-027) may still vary between browsers.

### 3. Summary

- **Cases reviewed:** 46 (TC-001 to TC-046), plus the "Not covered" section.
- **Comments:** 17.
- **By check:** #1: 1 · #2: 3 · #3: 6 · #4: 1 · #5: 1 · #6: 2 · #7: 2 · #8: 1.
- **By severity:** blocker 1 (TC-044) · major 11 · minor 5.

**What I could not check (needs verification in the app):**
- Whether the demo database resets.
- Whether the name fields have a browser maxlength. This decides the "input blocked = Pass" branches in TC-007, TC-012 and TC-017.
- How the date field handles a typed reversed range (TC-027).
- Whether the room page loads availability or the URL dates through innerHTML (TC-044).
- What the app actually shows for empty fields, unavailable dates and missing dates.
- How names are stored and shown on the admin side. No admin credentials were provided (UI map line 22).
