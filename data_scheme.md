To perfectly align with your updates, we are expanding the profile tracking to handle rich, customizable personal data (like hobbies and photos) that Office 365 doesn't store.

Regarding your question about **joining the Working Schedule and Working Report tables**:
Yes, we can absolutely combine them! Merging them creates a highly efficient **unified lifecycle table**. Instead of moving data across tables, a row simply matures through different statuses:

1. `Scheduled` (Student proposes availability)
2. `Approved` (Staff locks it in on the 30th)
3. `Completed` (Student inputs actual times and logs their work)

Here is the finalized, fully scalable relational data blueprint for your system.

---

## The Complete Relational Schema

### Module 1: Core Identity & Centralized Profiles

This table acts as the unified directory. It maps the Microsoft identity to the custom, rich profile data editable directly from your Flutter app.

#### 1. `Profiles` Table

* **`User_ID`** (Text, Primary Key) $\rightarrow$ *The unique Microsoft Object ID (GUID) from Azure AD.*
* **`Email`** (Text, Unique)
* **`Full_Name`** (Text)
* **`Role`** (Choice) $\rightarrow$ `Main Staff`, `Student Assistant`, `Visitor`
* **`Staff_Classification`** (Choice, Nullable) $\rightarrow$ `Japanese Staff`, `International Staff`
* **`Mother_Language`** (Text)
* **`Spoken_Languages`** (Text) $\rightarrow$ *Comma-separated values or JSON array (e.g., "Japanese, English, Spanish") editable in Flutter.*
* **`About_Me`** (Text/RichText) $\rightarrow$ *Short bio.*
* **`Studies`** (Text) $\rightarrow$ *Major, department, or academic focus.*
* **`Hobbies`** (Text) $\rightarrow$ *Interests for team-building/matching.*
* **`Profile_Picture_URL`** (Text) $\rightarrow$ *Path to the image stored in your secure document library.*
* **`Department_Grade`** (Text, Nullable) $\rightarrow$ *For tracking visitor academic standings.*
* **`Is_Active`** (Boolean) $\rightarrow$ *True for current staff/visitors; False soft-deletes graduated students.*

---

### Module 2: Unified Scheduling & Working Reports

> This single table replaces two messy Excel processes. It tracks time from a student's initial monthly submission all the way to final payroll approval.

#### 2. `Schedules_And_Reports` Table

* **`Time_Log_ID`** (Auto-ID, Primary Key)
* **`Student_ID`** (Text, Foreign Key $\rightarrow$ `Profiles.User_ID`)
* **`Associated_Reservation_ID`** (Number, Nullable, Foreign Key $\rightarrow$ `Reservations.Reservation_ID`)
* **`Location_Preference`** (Choice) $\rightarrow$ `In Person`, `Online Only`, `Both`
* **`Proposed_Start`** (DateTime) $\rightarrow$ *The availability block submitted by the student before the 24th.*
* **`Proposed_End`** (DateTime)
* **`Actual_Start`** (DateTime, Nullable) $\rightarrow$ *The exact time the student actually began working.*
* **`Actual_End`** (DateTime, Nullable) $\rightarrow$ *The exact time the student finished working.*
* **`Work_Log_Summary`** (Text, Nullable) $\rightarrow$ *The working report summary typed by the student.*
* **`Staff_Comments`** (Text, Nullable) $\rightarrow$ *Replaces the Excel footer comments section for staff reviews.*
* **`Lifecycle_Status`** (Choice) $\rightarrow$ Tracks the complete timeline:
* `Availability_Submitted` *(Student proposed the time block)*
* `Schedule_Approved` *(Main staff colored/approved it on the 30th)*
* `Report_Submitted` *(Student filled in actual times and work details)*
* `Final_Approved` *(Main staff signed off; ready for dynamic printing)*



---

### Module 3: Events & Guest Experience

Links proposal approvals, social media tasks, visual media folders, and guest feedback surveys under one roof.

#### 3. `Events` Table

* **`Event_ID`** (Auto-ID, Primary Key)
* **`Proposer_ID`** (Text, Foreign Key $\rightarrow$ `Profiles.User_ID`)
* **`Title`** (Text)
* **`Theme`** (Text)
* **`Proposed_Start`** (DateTime)
* **`Proposed_End`** (DateTime)
* **`Status`** (Choice) $\rightarrow$ `Proposed`, `Approved`, `Rejected`, `Completed`
* **`Preparation_Notes`** (Text/RichText) $\rightarrow$ *Guidelines, marketing rules, QR codes, and guest dependency checklists.*
* **`Teams_Media_Folder_URL`** (Text, Nullable) $\rightarrow$ *Direct link to the SharePoint/Teams folder containing event photos and videos.*

#### 4. `Event_Feedback` Table

* **`Feedback_ID`** (Auto-ID, Primary Key)
* **`Event_ID`** (Number, Foreign Key $\rightarrow$ `Events.Event_ID`)
* **`Guest_Identifier`** (Text, Optional) $\rightarrow$ *Can link to a Visitor profile or be left blank for anonymous logs.*
* **`Rating`** (Number) $\rightarrow$ *Numerical satisfaction score.*
* **`Comments`** (Text) $\rightarrow$ *Qualitative text responses for future diagnostics and study.*
* **`Submitted_At`** (DateTime)

---

### Module 4: Digital Meeting Logs

Replaces free-form Word documents with structured, searchable data tracking key roles and recordings.

#### 5. `Meetings` Table

* **`Meeting_ID`** (Auto-ID, Primary Key)
* **`Proposed_By`** (Text, Foreign Key $\rightarrow$ `Profiles.User_ID`)
* **`Moderator_ID`** (Text, Foreign Key $\rightarrow$ `Profiles.User_ID`)
* **`Note_Taker_ID`** (Text, Foreign Key $\rightarrow$ `Profiles.User_ID`)
* **`Scheduled_Start`** (DateTime)
* **`Scheduled_End`** (DateTime)
* **`Status`** (Choice) $\rightarrow$ `Pending Staff Confirmation`, `Confirmed`, `Completed`
* **`Agenda`** (Text/RichText) $\rightarrow$ *The planned outline for the meeting.*
* **`Minutes_Text`** (Text/RichText) $\rightarrow$ *The notes captured during the session, including references to embedded graphics.*
* **`Teams_Recording_URL`** (Text, Nullable) $\rightarrow$ *Link to the meeting's cloud video backup.*

---

### Module 5: Automated Reservations (Visitor Portals)

Handles external visitor bookings, prevents double-booking across student availability schedules, and tracks assignments.

#### 6. `Reservations` Table

* **`Reservation_ID`** (Auto-ID, Primary Key)
* **`Visitor_ID`** (Text, Foreign Key $\rightarrow$ `Profiles.User_ID`)
* **`Assigned_Student_ID`** (Text, Nullable, Foreign Key $\rightarrow$ `Profiles.User_ID`)
* **`Start_DateTime`** (DateTime)
* **`End_DateTime`** (DateTime)
* **`Place`** (Choice) $\rightarrow$ `In Person`, `Teams`
* **`Purpose`** (Choice) $\rightarrow$ `Assignment`, `Conversation`, `Presentation Practice`
* **`Status`** (Choice) $\rightarrow$ `Pending Assignment`, `Staff Confirmed`, `Visitor Notified`, `Completed`, `Cancelled`

---

### Module 6: Developer Auditing & Sequence Tracking (SQLite)

This logging engine records real-time clicks, validation bumps, and structural sequences completely separate from the staff's SharePoint ecosystem.

#### 7. `Developer_Action_Logs` Table

* **`Log_ID`** (Auto-ID, Primary Key)
* **`Session_ID`** (Text) $\rightarrow$ *A distinct UUID generated whenever the app launches to stitch a specific user session sequence together.*
* **`User_ID`** (Text, Nullable) $\rightarrow$ *Tracks the user performing actions if they are authenticated.*
* **`Timestamp`** (DateTime, Default: Current System Time)
* **`Screen_Name`** (Text) $\rightarrow$ *e.g., "Staff_Schedule_Approval_Screen"*
* **`Action_Type`** (Choice) $\rightarrow$ `BUTTON_CLICK`, `INPUT_CHANGED`, `VALIDATION_FAILED`, `API_REQUEST`, `API_ERROR`, `APP_CRASH`
* **`Element_ID`** (Text) $\rightarrow$ *e.g., "approve_schedule_btn_24"*
* **`State_Context_JSON`** (Text/Blob) $\rightarrow$ *A snapshot of what went wrong (e.g., raw API failure payloads or exact validation errors).*
