# Application UI map (observed in the live app)

Home page
- Top navigation: Rooms, Booking, Amenities, Location, Contact, Admin.
- "Check Availability & Book Your Stay" section: Check In and Check Out date fields (format DD/MM/YYYY, date picker, prefilled with today and tomorrow) and a "Check Availability" button.
- "Our Rooms" section: one card per room (Single, Double, Suite) with price per night, amenities and a "Book now" button. After "Check Availability", it lists only the rooms available for the selected dates.
- Contact form (Name, Email, Phone, Subject, Message, Submit) and a Location section with address details.

Room page
- URL format: /reservation/{roomId}?checkin=YYYY-MM-DD&checkout=YYYY-MM-DD. Room IDs: Single = 1, Double = 2, Suite = 3. Clicking "Book now" on the home page opens this URL with the dates from the home page.
- Breadcrumb (Home / Rooms / room name), room name, "Accessible" badge, "Max 2 Guests", photo, description, features, and policies: check-in 3:00 PM to 8:00 PM, check-out by 11:00 AM, early/late by arrangement; house rules.
- "Book This Room" panel on the right:
  - Price per night.
  - A month calendar with Today / Back / Next buttons. It always opens on the current month with today highlighted. The selected nights are shown as a "Selected" bar (shortened to "Sel…" for a single night); selections in later months are only visible after clicking Next. Dates already booked by other guests are not marked on the calendar.
  - "Price Summary": nightly rate × number of nights, cleaning fee, service fee and total.
  - "Reserve Now" button. The first click shows the form (Firstname, Lastname, Email, Phone) and a "Cancel" button; the second click submits.
  - Validation errors appear as a bulleted list in a red box inside the panel, above the Price Summary.
  - On success, the panel is replaced by "Booking Confirmed", the text "Your booking has been confirmed for the following dates:", the range as YYYY-MM-DD - YYYY-MM-DD, and a "Return home" button.
- "Similar Rooms You Might Like" section at the bottom: cards for the other rooms, each with a "View Details" button that opens that room's page.

Admin
- /admin shows a login form (Username, Password). Admin credentials are not provided to the tester.

Rooms: Single £100/night, Double £150/night, Suite £225/night (max 2 guests each).
