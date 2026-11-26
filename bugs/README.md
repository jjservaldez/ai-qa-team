# Bug reports: Shady Meadows B&B booking flow

**Tester:** Jose Serna
**Environments:**
- **Demo:** https://automationintesting.online. Exploration ran 2026-10-17 to 2026-10-19, plus a partial run on 2026-11-23. Down since 2026-11-23.
- **Local:** restful-booker-platform at commit `efe2deb`, run 2026-11-25. Re-checks on 2026-11-26.

Each report keeps the original October evidence and adds a **"Re-test on the local copy"** section.

| ID | Severity | Title | Status (2026-11-26) |
|---|---|---|---|
| [BUG-01](BUG-01.md) | High | Booking panel crashes when the server rejects a booking | Reproduced on local, 6 paths. Cause confirmed by network + console evidence |
| [BUG-02](BUG-02.md) | High | Invalid date range shows negative or zero nights | Reproduced on local. The server rejects these ranges; the defect is client-side |
| [BUG-06](BUG-06.md) | High | A calendar click lowers the price, but the original range is booked | Reproduced on local (3/3 overall) |
| [BUG-03](BUG-03.md) | Medium | "View Details" in Similar Rooms loses the dates | **Not reproduced on local.** Verify on the demo |
| [BUG-04](BUG-04.md) | Medium | Names made only of digits are accepted | Reproduced · **Needs PO decision** (PO-1) |
| [BUG-05](BUG-05.md) | Low | Validation messages don't name the field | Reproduced · AC8 clarified, waiting for PO confirmation (PO-6) |
| [BUG-07](BUG-07.md) | Low | "Amenities" link goes nowhere | Reproduced · **Needs PO decision** (PO-5) |

**Candidates:** [CANDIDATES.md](CANDIDATES.md) (CAND-08 to CAND-15) · **Questions for the PO:** [PO-DECISIONS.md](PO-DECISIONS.md)

## Severity scale

- **High:** wrong price or booking, data integrity, or the user can't complete or recover from the flow.
- **Medium:** a path through the flow is broken or bad data is accepted, with a workaround.
- **Low:** cosmetic, unclear messaging, or outside the main flow.

## Notes on this environment

- The app is a public demo. Other users book the same default dates (today and tomorrow), and the data is reset periodically. State-dependent bugs were reproduced with no time gap and with far-future dates to avoid interference.
- One behavior was investigated and **not** reported as a bug: the rooms listed on the home page for today–tomorrow changed between sessions (OBS-01 in the exploration notes). The steps didn't give consistent results, and the most likely cause is other users' bookings.
