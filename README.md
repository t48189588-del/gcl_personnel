# gcl_personnel

A flutter web app for managing GCL staff and events.

## Tasks
- [ ] admin information
  - [ ] GCL hour schedule
  - [ ] Staff information
  - [ ] holidays input (to pull from internet yearly and ask for user confirmation)
  - [ ] platform management logging
    - [ ] instagram
    - [ ] website
    - [ ] Twitter
    - [ ] Line
    - [ ] Email
    - [ ] Youtube
    - [ ] Moodle
- [ ] scheduling platform
  - [ ] date and time handler (within GCL hour schedule limit, holidays and events)
  - [ ] type of availability
    - [ ] in person
    - [ ] online only
  - [ ] attendance confirmation
- [ ] Event handler
  - [ ] before event
    - [ ] date and time
    - [ ] title
    - [ ] location
    - [ ] type of event
  - [ ] post event
    - [ ] inmediately after event
      - [ ] customer satisfaction questionare
    - [ ] post event
      - [ ] photos
      - [ ] summary 
      - [ ] SNS publication
- [ ] Meeting reservation forms integrations
  - [ ] date and time (30 minute limit per session)
  - [ ] japanese compatibility
  - [ ] place
    - [ ] online
    - [ ] in person
  - [ ] department
  - [ ] grade
  - [ ] purpose
  - [ ] name
    - [ ] organizer
    - [ ] participant
  - [ ] purpose
    - [ ] assignment
    - [ ] conversation
      - [ ] English
      - [ ] Chinese
      - [ ] Japanese
    - [ ] Presentation practice
      - [ ] English
      - [ ] Japanese
## capabilities
- photos submission
- email and calendar integration (google and outlook)
- export logging
  - events
  - attendance
  - meeting agenda
- Login capability 
- Multi-language support
  - English
  - Japanese
  - Chinese
- dashboard visualization
- local storage?
- sharepoint storage

# Prompts
## First day
```
# PROJECT: International Dept. Multi-Role Admin Ledger (PoC)
# ROLE: Senior Flutter Architect & UI/UX Specialist

## 1. ACCESS CONTROL LOGIC (The "Role Gate")
On launch, the app presents a simple Role Selection (Senior Staff vs. Junior Staff) to demonstrate the two distinct workflows.

## 2. SENIOR STAFF MODULE (The Commander View)
### A. Departmental Guardrails
- **Operating Hours:** Global Start/End time setter.
- **Calendar Management:** Tool to mark Holidays and Location status.
- **Staff Metrics Dashboard:** A filterable table/view to analyze the 20 staff members by:
    - Language (Native/Fluent)
    - Degree/Academic level
    - Modality (In-Person vs. Online)
    - Assistance/Availability rate
- **Data Export:** Button to generate a formatted .xlsx file containing all filtered metrics and schedules.

## 3. JUNIOR STAFF MODULE (The Self-Service Portal)
### B. Scheduling & Availability
- **30-Min Block Painter:** A calendar grid allowing staff to select availability in 30-minute increments within Admin-defined hours.
- **Modality Toggle:** For each block or shift, mark as "In-Person," "Online," or "Both."
- **Event Feed:** A "Notice Board" section showing upcoming department events.

### C. Personal Profile & Communication
- **Multi-Language Support:** Input for "Native Language" and a list for "Fluent Service Languages."
- **Communication Preferences:** Toggle for Email, SNS, or Both.
- **Emergency Protocol:** A prominent "Emergency Reschedule" button that:
    1. Allows the user to select the shift to vacate.
    2. Flags the shift as "Needs Replacement" for Senior Staff.
    3. Triggers a notification simulation (Snackbar/Toast) to the replacement (if logic is set).

## 4. UI/UX REQUIREMENTS
- **Color Coding:** Use distinct themes for Senior (e.g., Professional Slate) and Junior (e.g., Energetic Blue) portals.
- **Clarity:** 30-minute blocks must be large enough for "fat-finger" selection on mobile devices.
- **Accessibility:** Ensure high-contrast text and icons for senior staff members.

## 5. TECHNICAL SPECIFICATIONS
- **Framework:** Flutter Web.
- **Storage:** Local Hive/IndexedDB for persistent data across sessions.
- **Validation:** Junior staff CANNOT select times outside the Admin's "Operating Hours" or on "Holidays."
```
