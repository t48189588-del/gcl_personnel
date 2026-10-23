# Data tables
This documents show the data table with their respective names, data time and examples

## Working schedules
This registers the information regarding the working schedules after being checked by the main staff

table name: workingSchedules

|Field|Data type|Example|
|---|---|---|
|Id|excel formula<br>`=Row()`|
|staff|String|
|country|excel formula<br>`=XLOOKUP([@staff],スタッフ[nickname],スタッフ[国])`||
|date|date|2026-10-01|
|weekday|string <br>excel format `aaa`|月<br>火<br>水<br>木<br>金|
|startDateTime|dateTime|2026-10-01 9:00|
|endDateTime|dateTime|2026-10-01 9:00|
|calculatedHours|number<br>excel format: `number`|0.00|
|location|string|◯<br>GCL<br>Teams|
|status|string|approved<br>available
|checked_main_staff|boolean|True<br>False|
|updatedTime|dateTime<br>excel format: `yyyy/m/dd HH:mm:ss`|2026/10/1  5:14:18
|__PowerAppsId__|string|ee60c9cc-09dd-4515-9170-44d04387c7bb|

## Working report

table name: workingReports

|Field|Data type|Example|
|---|---|---|
|id|excel formula<br>`=Row()`
|staff|string
|date|date|2026-10-01
|weekday|string|月<br>火<br>水<br>木<br>金
|scheduledStart|Time|13:00
|scheduledEnd|Time|15:00
|actualStart|Time|13:00
|actualEnd|Time|15:00
|calculated|number<br>2 decimals|2.00|
|description|string|"Talk with visitors",<br>"English conversation",<br>"Staff meetings [note taker, meeting coordinator, attendance]",<br>"Assignments from reservation",<br>"Event assistance",<br>"Others"
|additional details|string|
|submitted_time|dateTime<br>excel format: `yyyy/m/dd HH:mm:ss`|2026/10/1  5:14:18|
|status|string
|__PowerAppsId__|string|48e65b5d-ecaf-4c27-aac8-5ebad9057cfd

## Reservations

table name: reservations

|Field|Data type|Example|
|---|---|---|
|ID|excel formula<br>`=Row()`|
|date|date|2026-10-01|
|startTime|dateTime
|endTime|dateTime
|requestedNationality|sting
|assignedStaffNickname|string
|japSupport|string
|location|string
|email|string
|name|string
|dept|string
|affiliation|string
|participant|integer
|purpose|string
|desired_language|string
|status|string|
|__PowerAppsId__|string|48e65b5d-ecaf-4c27-aac8-5ebad9057cfd

## Activities

table name: gclActivities

|Field|Data type|Example|
|---|---|---|
|activityID|excel formula<br>`=Row()`|
|activityType|string
|title|string
|location|string
|date|date
|Schedule_Start|dateTime
|Scheduled_end|dateTime
|status|string
|preActivityNotes|string
|postActivityNotes|string
|media_folder|string
|__PowerAppsId__|string|48e65b5d-ecaf-4c27-aac8-5ebad9057cfd

## Reservation availability

table name: reservationAvailability

|Field|Data Type|Example|
|---|---|---|
|staff|string|
|country|string<br>Excel formula `=XLOOKUP([@staff],スタッフ[nickname],スタッフ[国])`|
|date|date|2026/10/01|
|weekday|string<br>Excel format `aaa`|月<br>火<br>水<br>木<br>金
|startDateTime|datetime|2026/10/01 13:00|
|endDateTime|datetime|2026/10/01 15:00|
|location|string|◯<br>GCL<br>Teams|
