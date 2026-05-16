# gcl_personnel

Presentation to other student staff **May 6,2026**
Presentation date to senior staff **May 13, 2026**

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

## Tasks
- [ ] admin information
  - [ ] seniour staff (3 people)
    - [ ] Hatsuda Hisanori
    - [ ] Shiraishi Shinya
    - [ ] Kiruma Tomoko
  - [ ] student staff (25 people)
    - [ ] admin / owner
    - [ ] users
  - [x] GCL hour schedule
    - [ ] export (auto generated)
      - [ ] Excel 
      - [ ] generate PDF naming=japanese year.month_GCL_Schedule.pdf
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
    - [ ] in person
    - [ ] online only
  - [ ] attendance confirmation 
  - [x] working report (only activated AFTER the shift)
    - [ ] confirm time (start time - finish time)
    - [ ] number of hours (floating data type)
    - [ ] what did you do?
    - [ ] when exporting 
      - [ ] header
        - [ ] name
        - [ ] affiliation
      - [ ] 1 book per year
      - [ ] 1 month per tab
      - [ ] 1 day per row
- [ ] Event handler
  - [ ] event proposal 
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
- [ ] Meeting reservation forms integrations (for external people of GCL)
  - [ ] date and time (30 minute limit per session)
  - [ ] japanese compatibility
  - [ ] forms
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
- Multi-language support
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
  - [ ] staff schedule information 
  - [ ] fix information formatting for online/local storage and dashboard reading or excel pivoting

# option 1
Office 365 only tools
- power apps
- power automate
- sharepoint
- teams
- word 
- excel 

# option 2
"Open" tools
- flutter 
- python 
- n8n (power automate functions)
- google apps script

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

## Continuity demo approach
