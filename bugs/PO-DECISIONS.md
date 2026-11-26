# PO decision log

Some observed behavior has no acceptance criterion behind it. Its test case verdict is **Question**, but it still gets a ticket with its evidence and the status **Needs PO decision**. The PO's answer, written here or in the ticket, is the evidence. A question is closed only once the answer is written down (L-33).

| # | Ticket | Question for the PO | Raised | Decision | Date | Effect on tests |
|---|---|---|---|---|---|---|
| PO-1 | [BUG-04](BUG-04.md) | Can names contain only digits? Which characters are allowed? | Oct (test plan Q1) · re-raised 2026-11-25 | *pending* | — | If not allowed: add to AC4/AC5 → TC-017 becomes Fail |
| PO-2 | [CAND-08](CANDIDATES.md) | Can a booking be made for past dates? | 11-23 · 11-25 | *pending* | — | If not: new AC → TC-037 becomes Fail |
| PO-3 | [CAND-11](CANDIDATES.md) | Are spaces at the start or end of a name trimmed before the length check? | Test plan Q5 · 11-25 | *pending* | — | If trimmed: TC-018 becomes Fail |
| PO-4 | [CAND-10](CANDIDATES.md) | Should the calendar shade only the nights, or also the check-out day? | 11-25 | *pending* | — | Nights only: TC-001, 002, 011, 013, 038 become Fail. Otherwise: update their oracles |
| PO-5 | [BUG-07](BUG-07.md) | Is the top navigation in scope for this story? Should "Amenities" lead to a section? | 11-25 | *pending* | — | Track under a separate story |
| PO-6 | [BUG-05](BUG-05.md) | Confirm AC8 as clarified by QA: "each error message identifies the field it refers to". | 11-25 | *pending* | — | If confirmed: update the TC-021 and TC-030 oracles in the next suite version |
| PO-7 | [BUG-01](BUG-01.md) (note) | For developers and the PO: the server returns 409 for invalid date ranges, not only for taken dates. Is that intended, or should it be 400? | 11-26 | *pending* | — | API contract; affects the frontend fix for BUG-01 |
