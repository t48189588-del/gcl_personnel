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
website
Data tables:
- [reservation availability](./data_tables.md#reservation-availability)

```mermaid
flowchart TB
    A[Receive request from website]
    B[Get available]
    C[Prepare data]
    D[Pass to flutter to show]
    A-->B-->C-->D
```
