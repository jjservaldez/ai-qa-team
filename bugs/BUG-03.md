# BUG-03 · "View Details" in Similar Rooms loses the selected dates (£NaN, booking fails)

| Field | Value |
|---|---|
| Severity | Medium |
| Priority | Medium |
| Component | Room page → "Similar Rooms You Might Like" |
| Environment | https://automationintesting.online · Google Chrome on macOS |
| Reproducibility | Always |
| Related AC | AC12 (reaching a room from any path keeps the dates or asks for them) |
| Found by | Exploratory testing |
| Date | 2026-10-17 |

## Summary

From a room page with dates selected, "View Details" on a similar room opens it with `checkin=null&checkout=null`. The Price Summary shows "NaN", and submitting a booking fails with a generic message.

## Steps to reproduce

1. Open `https://automationintesting.online/reservation/3?checkin=2026-10-17&checkout=2026-10-18` (Suite).
2. Scroll to "Similar Rooms You Might Like".
3. On the Double card, click "View Details".
4. Check the URL and the Price Summary.
5. Click "Reserve Now", enter valid data, click "Reserve Now".

## Expected result

The Double room opens with the same dates (17–18 October), or the page asks the user to select dates before booking.

## Actual result

- URL: `/reservation/2?checkin=null&checkout=null`.
- Price Summary: "£150 x NaN nights = £NaN", Total £NaN.
- After opening the form, the summary changes to "1 nights, £190" with no dates selected.
- Submitting shows "Failed to create booking" in the red error box.

## Evidence

| Step | Screenshot |
|---|---|
| URL with null dates, £NaN | ![NaN](evidence/BUG-03-nan.jpg) |
| "Failed to create booking" | ![Failed](evidence/BUG-03-failed.jpg) |

## Re-test on the local copy (2026-11-25): NOT reproduced

**Environment:** Local copy of restful-booker-platform, commit `efe2deb` (2026-10-23), http://localhost:3003 · Claude desktop browser pane, 1280×900 · executed by the agent, re-checks 2026-11-26
- **TC-038:** a real click on "View Details" (Double) from `/reservation/1?checkin=2027-04-05&checkout=2027-04-07` opens `/reservation/2?checkin=2027-04-05&checkout=2027-04-07`, Double Room, £150 x 2 nights = £300, Total £340. The dates are kept.
- **Possible explanations:** it was fixed in this build, or the public demo runs an older build.
- **Status:** still open, waiting to be verified on the demo. The demo has been down since 2026-11-23. Do not close it on the strength of a different environment.
