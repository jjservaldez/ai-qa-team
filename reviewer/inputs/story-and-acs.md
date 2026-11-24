# User story and acceptance criteria

Application: Shady Meadows B&B (https://automationintesting.online), a hotel booking web app.

User story:
As a guest, I want to book a room for specific dates by entering my contact details, so that I can secure my stay.

Acceptance criteria:
- AC1: Dates chosen on the home page (Check In / Check Out) are passed to the room page and are the dates that get booked.
- AC2: The price summary shows nightly rate × number of nights + cleaning fee (£25) + service fee (£15) = total.
- AC3: The first click on "Reserve Now" shows the booking form (Firstname, Lastname, Email, Phone) and a "Cancel" button.
- AC4: Firstname is required, 3–18 characters.
- AC5: Lastname is required, 3–30 characters.
- AC6: Email is required and must be a valid email format.
- AC7: Phone is required, 11–21 characters.
- AC8: If any field is invalid, the booking is not created and error messages are shown.
- AC9: With valid data, a "Booking Confirmed" message is shown with the booked date range.
- AC10: Dates that are already booked for a room cannot be booked again.
- AC11: Check Out date must be after Check In date.
- AC12: Reaching a room page from any path keeps the selected dates or asks the user to select them.
