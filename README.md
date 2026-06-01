# gcl_personnel

## Logs
Presentation to other student staff **May 6,2026**
Presentation date to senior staff (shiriashi-san, kimura-san) **May 13, 2026**
Presentation date to senior staff (hatsuda-san, sugawara-san) **May 20, 2026**
Presentation of documentation and power apps prototype (hatsuda-san, sugawara-san) **May 27, 2026**
Presentation of documentation and power apps prototype (kimura-san, shiriashi-san) **May 28, 2026**

A flutter web app for managing GCL staff and events (self hosted)
A office/sharepoint mirror (cloud hosted)

Base information pulled from 
Online contact 

- Instragram: https://www.instagram.com/gclkyutech/  
- Website (hosted in google sites): https://sites.google.com/view/gclkyutech/about-us  
- Line ID: kyutechgcl  
- Email: gcl@lai.kyutech.ac.jp  
- Youtube: https://www.youtube.com/channel/UCXeW6dvL52EJgPPNJMlVt0A  
- Moodle reservation: https://horyu.el.kyutech.ac.jp/course/view.php?id=767 
- Teams group

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
  - [x] holidays input (to pull from internet yearly and ask for user confirmation)
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
- Login capability
  - cojoin with office 365 (kyutech credentials) 
- Multi-language support (integrate with translation API and cache saving)
  - English
  - Japanese
  - Chinese
- dashboard visualization
  - public information from the SNS 
    - instagram: views, followers, likes?
    - youtube: subscriber, video views
- hability to configure - generate content to all platforms from dashboard
- local storage?
- sharepoint storage in teams
- automatic backup generation 
  - locally 
  - online
- power automate integration?

## Pendings
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

### issues to be fixed!!
1. meetings hours are not being correctly processed by the system 

add auto language detection, application and display result in console terminal 

in the student block, block ONLY the meeting hours block

for students staff
in the schedule view, show also de the details of approved external meeting request.

in the event proposal tab, add a log of previosly proposed events (show if they are approved, pending or rejected)

in the senior dashboard approval panel
show for each block the start and end time


commander view-senior staff
approve windows - next month availability 
1. add a new layout option for day presentation.
   1. When multiple staff has submitted availability for the same time block change layout to each day show the time block grid, inside each block show the proposed schedule for the respective studnet staff with an approve or reject option
2. instead of removing the block when approved, change to a green background block (for approved), gray (pending approval), red for rejected, also enable the senior staff to change the approval status

fix to uptimize view in web browser mobile format
add graphings for the senior dashboard reports
1. historgram chart showing the total approved hours worked per time block
3. based on all the staff languages proficiency, a bar grpahs showing the amount of speakers per language 
4. a line chart per staff member, showing the accumulative worked hours per day
5. based on the staff academic status (master, bacherlor, phd, reseatch) show a column bar graphs showing the number of staff per academic status

to try 
from the existing data, create a "form" like for external meeting requests
only apply to approved student staff schedule
show date, time and language, academic information? (level and specialty)
requested topic, amount of persons

# System
## Data
- Sharepoint list
- Excel tables (saved in teams group)
- SQlite

## User interface (UI)
- Power apps
- Flutter (hosted in github pages)

## backbone 
- power automate 
- python? (webscrapping)
- google apps script (backup)?

## Testing comments

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

junior profile
add languages (native and speaking)

# Suggestions after hatsuda-san and sugawara-san meeting (may 20, 2026)
- export excel should be same format as original excel file (same column order and same column names )
- print availability schuedule
  - type 1: date, time, headers student staff name
  - type 2: date, time, row students staff side by side
- think about future updates/changes adding new screens/templates?
- build power apps 
- data permission obtained from hatsuda-san
- for external visitor, show a month previewe only sholy available slots (color code the student staff availability, origin country and time block) consider chooseing = reserved (for calendar purposes only)

## For exporting flutter project to github pages
| Step | Explain                                            | code                                                   |
| ---- | -------------------------------------------------- | ------------------------------------------------------ |
| 0    | Preparation, ensuring all libraries are up to date | `flutter clean && flutter pub get`                     |
| 1    | Preparing web pages elements (html, css, js)       | `flutter build web`                                    |
| 2    | Navigate to build/web directory                    | `cd build/web`                                         |
| 3    | temporary git (for uploading to github pages)      | `git init && git add . && git commit -m "first commit` |
| 4    | uploading pages                                    | `git push -f <repo>.git master:gh-pages`               |
