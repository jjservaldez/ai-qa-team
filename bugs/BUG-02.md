# BUG-02 · Invalid date range is not validated: price shows negative or zero nights

| Field | Value |
|---|---|
| Severity | High |
| Priority | High |
| Component | Home page date fields → room page Price Summary |
| Environment | https://automationintesting.online · Google Chrome on macOS |
| Reproducibility | Always |
| Related AC | AC11 (Check Out after Check In), AC2 (price summary) |
| Found by | Exploratory testing (negative nights); zero-night variant from AI-generated test case v2 TC-030 |
| Date | 2026-10-17, zero-night variant on 2026-10-19 |

## Summary

The home page accepts a Check Out date that is before or equal to the Check In date, with no warning. The room page then calculates the price from that range: negative nights give a negative total, and zero nights give a total made only of the fees.

## Steps to reproduce

**Variant A: Check Out before Check In**
1. On the home page, set Check In `17/10/2026` and Check Out `02/10/2026`.
2. Click "Check Availability".
3. Click "Book now" on the Double room.
4. Read the Price Summary.

**Variant B: Check Out equal to Check In**
1. On the home page, set Check In and Check Out to `22/10/2026`.
2. Click "Check Availability".
3. Click "Book now" on the Double room.
4. Read the Price Summary.

## Expected result

The home page rejects the range with a clear message (or the date picker prevents it). The room page never shows zero or negative nights or a total for an invalid range.

## Actual result

- Variant A: "£150 x -15 nights = £-2250", Cleaning fee £25, Service fee £15, **Total £-2210**. With Check Out `01/10/2026`: -16 nights, Total £-2360.
- Variant B: "£150 x 0 nights = £0", Cleaning fee £25, Service fee £15, **Total £40**.
- In both variants, "Reserve Now" stays available; submitting crashes the page (BUG-01).

## Evidence

| Variant | Screenshot |
|---|---|
| A: negative nights and total | ![Negative total](evidence/BUG-02-a-negative.jpg) |
| B: zero nights, £40 total | ![Zero nights](evidence/BUG-02-b-zero.jpg) |

## Notes

- The room page computes the price from the URL parameters (`?checkin=2026-10-17&checkout=2026-10-02`) without validating them, so the room page is missing the check too, not only the home page.

## Re-test on the local copy (2026-11-25 and 2026-11-26)

**Environment:** Local copy of restful-booker-platform, commit `efe2deb` (2026-10-23), http://localhost:3003 · Claude desktop browser pane, 1280×900 · executed by the agent, re-checks 2026-11-26
**Result:** reproduced (TC-035, TC-036, TC-048).
- Reversed dates 15/03/2027 → 13/03/2027: the date pickers accept them, no message appears, all rooms are listed. The room page shows "£100 x -2 nights", £-200, Total **£-160**.
- Same day 17/03/2027: "£100 x 0 nights", £0, Total **£40**.

**New finding (2026-11-26):** the server **rejects** these ranges (`POST /api/booking` → 409), so no invalid booking is stored. The defect is on the **client**: the home page accepts the range, and the Price Summary calculates and shows negative or zero nights. Submitting crashes the page (BUG-01).

**Linked:** CAND-13. Invalid date parameters show £NaN. It is likely the same missing validation of the dates in the URL before the price is calculated.
