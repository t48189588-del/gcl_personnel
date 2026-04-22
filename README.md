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
  - [x] ~~date and time handler (within GCL hour schedule limit, holidays and events)~~
  - [x] ~~type of availability~~
    - [ ] in person
    - [ ] online only
  - [ ] attendance confirmation 
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
- [ ] Working reports (information and standards)
- [ ] Meeting Agenda & Minutes
- [ ] SNS scrapper (only public information)
- [ ] Media generator - integration with LLM

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

