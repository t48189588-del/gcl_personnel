# gcl_personnel


A flutter web app for managing GCL staff and events (self hosted)
A office/sharepoint mirror (cloud hosted)

- Instragram: https://www.instagram.com/gclkyutech/  
- Website (hosted in google sites): https://sites.google.com/view/gclkyutech/about-us  
- Line ID: kyutechgcl  
- Email: gcl@lai.kyutech.ac.jp  
- Youtube: https://www.youtube.com/channel/UCXeW6dvL52EJgPPNJMlVt0A  
- Moodle reservation: https://horyu.el.kyutech.ac.jp/course/view.php?id=767 
- Teams group

## Wanna test?
### Public website (testing purposes only)
Main page: https://t48189588-del.github.io/gcl_personnel/
<br>
Reservation: https://t48189588-del.github.io/gcl_personnel/reservation/
> [!Note]
> The website are for testing purposes only. The information presented is presented only as an auxiliary for testing and interactivity, submission is not enabled either.

### Code
| Where                                | File                                                                                                                                                                                                                                    | command                                                                       |
| ------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| GitHub Codespace<br> (cloud testing) | [![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=t48189588-del/gcl_personnel)                                                              | testing<br>`flutter run -d web-server --web-port=8080 --web-hostname=0.0.0.0` |
| Mac & linux<br>(local testing)       | 1. **Download** and extract this repository ZIP folder to your desktop. <br>2. **Execute** `./setup.sh` via your terminal<br>3. Type `y` and user password to approve when prompted, then sit back while the setup launches the system. |
| Windows<br>(local testing)           | 1. **Download** and extract this repository ZIP folder to your desktop.<br>2. **Double-Click**: `setup.bat`<br>3. Type `y` to approve when prompted, then sit back while the setup launches the system.                                 |

> [!Note]
> If you wish to remove the system from your computer, simply drag the main `gcl_personnel` directory folder into your **Trash / Recycle Bin** and empty it. Because all caches and engines are stored directly inside this folder, 100% of all dependencies are wiped instantly from your computer without leaving single file fragments behind.

Currently all information is hosted in excel files in teams groups

## General information
- profiles
    - Main staff
    - Student assistants
        - Japanese staff
        - International staff
    - visitor
- processes
    - Working
        - schedules
        - reports
    - activities
        - events
        - meetings
    - reservations
## Tasks
- [ ] admin information
  - [x] seniour staff (3 people)
    - [ ] Hatsuda Hisanori
    - [ ] Shiraishi Shinyav
    - [ ] Kiruma Tomoko
  - [x] student staff (25 people)
    - [ ] admin / owner
    - [ ] users
  - [x] GCL hour schedule
    - Working hours: 11:30-14:00; 16:00-19:00 allow to be modified by personel
    - [x] export (auto generated)
      - [x] Excel 
      - [x] generate PDF naming=japanese year.month_GCL_Schedule.pdf
  - [x] Staff information
  - [x] holidays input (to pull from internet yearly and ask for user confirmation)v
  - [x] platform management logging
    - [x] instagram
    - [ ] website
    - [x] Twitter
    - [ ] Line
    - [ ] Email
    - [x] Youtube
    - [ ] Moodle
- [ ] scheduling platform
  - [x] ~~date and time handler (within GCL hour schedule limit, holidays and events)~~
  - [x] ~~type of availability~~
    - [x] in person
    - [x] online only
  - [x] attendance confirmation 
  - [x] working report (only activated AFTER the shift)
    - [x] confirm time (start time - finish time)
    - [x] number of hours (floating data type)
    - [x] what did you do?
    - [ ] when exporting 
      - [ ] header
        - [x] name
        - [x] affiliation
      - [ ] 1 book per year
      - [ ] 1 month per tab
      - [ ] 1 day per row
- [ ] Event handler
  - [x] event proposal: is it limited to GCL working schedule?
  - [x] before event
    - [x] start date and time
    - [ ] end date and time
    - [x] title
    - [x] location
    - [ ] type of event
  - [ ] post event
    - [ ] inmediately after event
      - [ ] customer satisfaction questionare
    - [ ] post event
      - [ ] photos
      - [ ] summary 
      - [ ] SNS publication
- [x] Meeting reservation forms (for external people of GCL)
  - [x] date and time (30 minute limit per session) based on approved schedule
  - [x] japanese compatibility
  - [ ] forms
    - [x] place
      - [ ] online
      - [ ] in person
    - [x] department
    - [x] grade
    - [x] name
      - [ ] organizer
      - [ ] participant
    - [x] purpose
      - [x] assignment
      - [x] conversation
      - [x] Presentation practice
    - [x] purpose language
        - [x] English
        - [x] Japanese
    - [ ] export
      - [ ] create menu and log to register previously exported information
      - [ ] Excel (1 tab per month - 1 book per year)
## capabilities
- photos & video submission
  - events
  - profile 
- [x] email and calendar integration (google and outlook)
- export logging
  - events
  - attendance
  - meeting agenda
- [x] Login capability
  - cojoin with office 365 (kyutech credentials) 
- Multi-language support (integrate with translation API and cache saving)
  - [x] English
  - [x] Japanese
  - Chinese
- dashboard visualization
  - public information from the SNS 
    - instagram: views, followers, likes?
    - youtube: subscriber, video views
- hability to configure - generate content to all platforms from dashboard
- local storage?
- sharepoint storage in teams
- automatic backup generation 
  - [x] locally 
  - online
- power automate integration
  - [x] sharepoing -> flutter
  - [x] flutter -> sharepoint
  - [x] excel backup
  - [ ] SQLite3 backup

## Pendings
- [ ] make short format videos for each stage (both student and seniors taff)
- [x] Working reports (information and standards)
- [ ] Meeting Agenda & Minutes
- [ ] SNS scrapper (only public information)
- [ ] Media generator - integration with LLM
- [ ] user uploading media
  - [ ] image
  - [ ] video
  - [ ] audio
- [ ] saving settings and data
  - [ ] locally
  - [ ] sharepoint
  - [ ] syncing between sources
- [ ] Data collecting
  - [ ] staff web information
  - [ ] event information
  - [x] staff schedule information 
  - [ ] fix information formatting for online/local storage and dashboard reading or excel pivoting
- [ ] People counter (to be defined)
  - [ ] GCL staff
  - [ ] non staff (public?)
  - [ ] frequency count?
- [ ] montly? check teams members - share/delete access to power apps

### issues to be fixed!!
1. meetings hours are not being correctly processed by the system 

in the student block, block ONLY the meeting hours block

for students staff
in the schedule view, show also de the details of approved external meeting request.

in the event proposal tab, add a log of previosly proposed events (show if they are approved, pending or rejected)

commander view-senior staff
approve windows - next month availability 
1. add a new layout option for day presentation.
   1. When multiple staff has submitted availability for the same time block change layout to each day show the time block grid, inside each block show the proposed schedule for the respective studnet staff with an approve or reject option

fix to optimize view in web browser mobile format
add graphings for the senior dashboard reports
1. historgram chart showing the total approved hours worked per time block
2. based on all the staff languages proficiency, a bar grpahs showing the amount of speakers per language 
3. a line chart per staff member, showing the accumulative worked hours per day
4. based on the staff academic status (master, bacherlor, phd, reseatch) show a column bar graphs showing the number of staff per academic status

to try 
only apply to approved student staff schedule

# System
> [!Note]
> Convert to flowchart diagram presentation

## Data
- Sharepoint list
- Excel tables (saved in teams group)
- SQlite

Currently "human-readable but not machine-readable"

## User interface (UI)
- Power apps
- Flutter (hosted in github pages)

## backbone 
- power automate 
- python? (webscrapping)
- google apps script (backup)?

## Pending features to add

enable a tab if multiple working reports are pending (>3), display all missing in table layout, each day per row 

for senior staff, allow export per group/all junior staff (multiple excel books 1 per staff member)

Social media stats must be able to be shown in japanese

senior metrics
add "finish employment" button for ever row 

add event proposals tab
After the initial event proposal is approved, the proposer shall be able to add:
  - event date & time
  - event summary 
  - event photos for SNS publication


# Suggestions after hatsuda-san and sugawara-san meeting (may 20, 2026)
- export excel should be same format as original excel file (same column order and same column names )
- think about future updates/changes adding new screens/templates?

## For exporting flutter project to github pages
| Step | Explain                                            | code                                                   |
| ---- | -------------------------------------------------- | ------------------------------------------------------ |
| 0    | Preparation, ensuring all libraries are up to date | `flutter clean && flutter pub get`                     |
| 1    | Preparing web pages elements (html, css, js)       | `flutter build web`                                    |
| 2    | Navigate to build/web directory                    | `cd build/web`                                         |
| 3    | temporary git (for uploading to github pages)      | `git init && git add . && git commit -m "first commit` |
| 4    | uploading pages                                    | `git push -f <repo>.git master:gh-pages`               |

# Logs
| date              | who                                                   | what                                                                                                                                                                                                                                                                                                                                                                                         |
| ----------------- | ----------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **May 13, 2026**  | Shiriashi-san & Kimura-san                            | Presentation of proposal                                                                                                                                                                                                                                                                                                                                                                     |
| **May 20, 2026**  | Hatsuda-san & Sugawara-san                            | Presentation of documentation and power apps prototype <br> Hatsuda-san provided permission to interact with real data from GCL Teams                                                                                                                                                                                                                                                        |
| **May 27, 2026**  | Hatsuda-san & Sugawara-san                            | Presentation of documentation and power apps prototype                                                                                                                                                                                                                                                                                                                                       |
| **May 28, 2026**  | Kimura-san & Shiriashi-san                            | Presentation of documentation and power apps prototype                                                                                                                                                                                                                                                                                                                                       |
| **June 1, 2026**  | Hatsuda-san                                           | A flutter web app for managing GCL staff and events (power apps)                                                                                                                                                                                                                                                                                                                             |
| **June 2, 2026**  | Hatsuda-san & Sugawara-san                            | Presented reservation flutter portal and suggestions on fields to add                                                                                                                                                                                                                                                                                                                        |
| **June 3, 2026**  | Hatsuda-san, Kimura-san, Shiriashi-san & Sugawara-san | Emailed power apps, flutter reservation page and GCL manual                                                                                                                                                                                                                                                                                                                                  |
| **June 17, 2026** | All GCL staff                                         | Presentation of complete system (github, power app and flutter)                                                                                                                                                                                                                                                                                                                              |
| **June 24, 2026** | Hatsuda-san & Kimura-san                              | Presentation of working reports screen (from main staff perspective) and feedback<br>Additional information in regard preparing data presentation for higher admin <ul><li>Footer on working reports, must remain the same when printed</li><li>All working reports are printed</li><li>Electronic signatures/stamps are reserved only for headquarter director and vice president</li></ul> |
| **July 29, 2026** | All GCL staff                                         | Presentation of complete system (github, power app and flutter)<br>Consultation with shiriashi-san about expected reports (schedules, reports, reservation and events), public visibility, japanese translation for approved & available                                                                                                                                                     |
|**August 3,2026**|Hatsuda-san, Kimura-san, Shiriashi-san,Sugawara-san|Sent email with report and tabular data in excel book `GCLデータ.xlsx` and access to V1 of power apps<br>Capabilities:<ul><li>Working scheduling</li><li>Working reports</li><li>Reservations</li><li>Events</li></ul>
## Tangent/psicological questions
1. What's the inconvenience?
2. What's the experience?
3. What is the highest priority per profile?
 - student: max amount of payment
 - main staff: faster organization
 - visitor: easy of understanding and update


# Common problems
## Variables names
use **ONLY** english variable in excel and sharepoint. When using power automate calling japanese characters becomes not human readable.
|Variable name <br> (Sharepoint, excel column)|Power automate field name|
|---|---|
|スタッフ|OData__x30b9__x30bf__x30c3__x30d5_|
|氏名|OData__x540d__x524d_|
|名前|OData__x540d__x524d_|
|メール|OData__x30e1__x30fc__x30eb_|
|国|OData__x56fd_|
|母語|OData__x6bcd__x8a9e_|
|他の言語|OData__x4ed6__x306e__x8a00__x8a9e_|
|プロフィール|OData__x30d7__x30ed__x30d5__x30a3__x30|
|私について|OData__x79c1__x306b__x3064__x3044__x30|
|キャンパス|OData__x30ad__x30e3__x30f3__x30d1__x30|

## Power automate & Flutter communication
the JSON fields must be **EXACTLY equal** (name and data type)
Power automate expects to receive
```
{
    "type": "object",
    "properties": {
        "start": {
            "type": "string"
        },
        "end": {
            "type": "string"
        },
        "name": {
            "type": "string"
        },
        "email": {
            "type": "string"
        },
        "department": {
            "type": "string"
        },
        "grade": {
            "type": "string"
        },
        "location": {
            "type": "string"
        },
        "purpose": {
            "type": "string"
        },
        "targetLanguage": {
            "type": [
                "string"
            ]
        },
        "staffPreference": {
            "type": "string"
        },
        "nativeLanguage": {
            "type": "string"
        }
    }
}
```
Good example
```
start: 2026-08-03T13:30:00.000
end: 2026-08-03T14:00:00.000
name: test
email: kung@mail.kyutech.jp
department: test2
grade: B2
location: GCL Lounge
purpose: Conversation
targetLanguage:英語 - en
staffPreference: anyone
nativeLanguage: en-US
```
Bad Example

```start: 2026-08-03T13:30:00.000
end: 2026-08-03T14:00:00.000
name: test
email: kung@mail.kyutech.jp
department: test2
grade: B2
location: GCL Lounge
purpose: Conversation
targetLanguage: null
staffPreference: anyone
nativeLanguage: en-US
```

Explanation: The variable *targetLanguage* only expects to receives a string, but if a null value is send, the flow crashes with responde Bad request (from power automate) and ERROR SYNCING TO POWER AUTOMATE: Exception: Server returned status code 400 (from flutter)