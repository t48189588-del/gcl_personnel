# 🗺️ System Blueprint (Auto-Generated from Flutter Codebase)

This documentation maps out your structural layers directly from your local codebase configuration.

---

## 1. Modular Application Architecture Map
This layout visually separates your presentation layer from the core storage logic.
```mermaid
graph TD
    subgraph Flutter App [lib/]
        Root[lib/main.dart] --> Core[core/ common modules]
        Root --> Feat[features/ system components]
        Root --> Data[Data & Storage Isolation Layer]
        Data --> CloudSync[[SharePoint / API Gateway Connection]]
        Data --> ExcelEngine[Excel Storage Backup Engine]
    end
```

---
## Next month availability submission
Via power apps
```mermaid
flowchart TB
    A[Main staff send reminder message via teams]
    B[Students staff submit all availability ]
    A-->B-->C
```
## Reservation
Reservation website: https://gcl-personnel-kohl.vercel.app
```mermaid
sequenceDiagram
  autonumber
  actor Kyutech Student
  participant Website
  participant API as GCL/LL Main staff
  participant GCL/LL Student Assistant
  Kyutech Student->>Website: Request reservation
  Website->>API: Reservation details
  activate API
  API->>GCL/LL Student Assistant: Assign SA
  GCL/LL Student Assistant-->>Kyutech Student: Approved
  API-->>Kyutech Student: Send Satisfaction form
  deactivate API
  Note over Kyutech Student,GCL/LL Student Assistant: One order, one transaction

```
# Developer 
## Grouping working schedules
Data table: [Working Schedules](/documentation/data_tables.md#working-schedules)
```mermaid
flowchart TB
    A[Date filtering from Excel]
    B[Staff filtering]
    C[Status filtering]
    D[Extract start and endtime into single array]
    E[Get smallest start time and greatest endtime]
    F[Create new nows]
    G[Delete original rows]
    A-->B-->C-->D-->E-->F-->G
```
## Working report prefill
Data tables:
- [working schedules](./data_tables.md#working-schedules)
- [working reports](./data_tables.md#working-report)
- [reservations](./data_tables.md#reservations)
- [activities](./data_tables.md#activities)
```mermaid
flowchart TB
    A[Daily trigger from Mon-Fri at 20:00]
    subgraph Active_month
        direction TB
        a1[Read data from excel tables        

        - working schedules
        - acivities
        - reservations]
        b1[update excel table

        - reservation set status=完了
        ]
        c1[add new row
        
        - working reports: copy time and set status to pending]
        a1-->b1 & c1
    end
    subgraph Storage_Excel
        direction TB        
        a2[add new rows
        - working schedules 
        - reservations]
        b2[update row
        - activity set status=completed]
        a2
        b2
    end
    A-->a1-->a2 
    A-->b2
```

## passing information from excel to public website
Reservation website: https://gcl-personnel-kohl.vercel.app

Data tables:
- [reservation availability](./data_tables.md#reservation-availability)
- [working schedules](./data_tables.md#working-schedules)
- [reservations](./data_tables.md#reservations)



## Reservation Availability and Booking Workflow

The reservation process begins with a scheduled Power Automate flow that runs Monday through Friday at 19:00. The flow summarizes and compacts changes made to the daily staff schedules, then updates the Reservation Availability Table to keep the available time-slot data organized and ready for retrieval. When an external user accesses the Vercel website, Power Automate retrieves the reservation availability data, converts it into JSON, and sends it to Vercel. The website processes the received data and splits availability into bookable time blocks for the requested date and time, allowing the user to select a desired slot.

When the user submits a reservation, the reservation details are automatically saved to the Reservation Table, and the Reservation Availability Table is updated to remove the booked time slot from available inventory. This ensures that subsequent availability requests reflect the latest reservation data and reduces the risk of duplicate bookings. Developers should ensure that reservation records and availability updates remain consistent, particularly when multiple users attempt to reserve the same time slot concurrently.

```mermaid
flowchart TD
    A([Start])

    subgraph SCHEDULE["1. Scheduled Availability Update"]
        B["Power Automate runs<br/>Monday-Friday at 19:00"]
        C["Summarize and compact<br/>daily schedule changes"]
        D[("Reservation Availability Table")]
        B --> C --> D
    end

    subgraph ACCESS["2. User Access and Availability Retrieval"]
        E["External user accesses<br/>Vercel website"]
        F["Power Automate retrieves<br/>availability data"]
        G["Convert data to JSON<br/>and send to Vercel"]
        H["Vercel receives JSON"]
        I["Split availability into<br/>bookable time blocks for<br/>the selected date and time"]
        J["Display available slots"]
        K["User selects a slot<br/>and submits reservation"]

        E --> F --> G --> H --> I --> J --> K
        D --> F
    end

    subgraph SUBMISSION["3. Reservation Submission"]
        L[("Reservation Table")]
        M["Automatically save<br/>reservation details"]
        N["Update Reservation<br/>Availability Table"]
        O["Remove booked slot<br/>from available inventory"]
        P([Ready for main staff revision])

        K --> M --> L -->P
        M --> N --> D
        N --> O 
    end

    A --> B
```
