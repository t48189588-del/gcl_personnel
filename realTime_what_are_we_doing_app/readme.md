# About
This is a webfirst platform to share with ANYONE in Kyutech Iizuka, about 
- GCL staff
- what are the currently doing and interests
- invite/delete the entry barrier for new visitors (maybe?)


# Logs
|date(yyyy/mm/dd)|who|description|
|---|---|---|
|2026/10/20|Aimi-san|Initial idea presentation.|


# AI prompt

## Version 1
```
Master Prompt — Department Personnel Directory & Messaging MVP
1. Project objective

Build an interactive MVP web application for a department personnel directory and internal communication platform.

The application has two distinct interfaces:

Public face: A desktop-first personnel directory that allows visitors to discover department members, understand their research and interests, see their working availability, and initiate direct conversations.
Private face: A mobile-first workspace where authenticated personnel can publish their daily activities, receive messages, and participate in individual conversations.

The primary objective is to present the concept to a board and collect feedback from prospective users.

The MVP must feel like a real, usable product rather than a static design mockup.

Scope boundaries
Build only the two web interfaces and the functionality needed to demonstrate them.
Use Flutter with web support as the intended application framework.
Keep the project compatible with a GitHub-based development workflow and future Vercel hosting.
Use realistic fictional sample data.
Support a real cross-device demonstration of the messaging flow, using an appropriate shared backend if necessary.
Keep the architecture simple and explain any external services needed to run the demonstration.
Do not implement the Docker first-run setup wizard, full production administration system, native mobile applications, or advanced infrastructure automation at this stage.

Do not substitute isolated, simulated buttons for core interactions that are expected to work during the presentation.

2. Overall design direction

Create a polished, professional, welcoming interface suitable for an academic department or research institution.

The public interface should take inspiration from editorial and newspaper layouts:

Clear typography and a strong visual hierarchy.
Portrait-oriented personnel entries.
Generous white space and carefully aligned columns.
Subtle borders and restrained use of color.
Minimal decorative cards; prioritize the personnel information itself.
Smooth, purposeful animations that never interfere with readability.

The private interface should use a familiar, modern messaging layout, with a clean inbox and a chat experience inspired by established messaging applications.

Use responsive layouts, accessible typography, visible interaction states, keyboard accessibility, and sufficiently large touch targets.

The public interface must be desktop-first. The private interface must be mobile-first. Both must remain usable on other screen sizes.

3. Public face — personnel directory

Create a public-facing page that can be opened directly from a QR code without requiring visitors to create an account just to browse.

3.1 Personnel gallery

Display a vertical list of department members.

Each member should have a single editorial-style entry composed of:

Left column — Profile photograph

Display a portrait photograph.
The portrait height should establish the height of the main personnel entry, similar to a newspaper profile layout.
Preserve the image's aspect ratio and use consistent image treatment.
Use realistic fictional portraits for demonstration data.

Middle column — Personnel information Display the following information in this order of priority:

Current activity: what the person is doing today, if provided.
If no current activity has been published, display their interests instead.
Full name.
Research topics.
Studies or academic background.
Current study year, where applicable.
Languages and proficiency levels.

Use typographic hierarchy to make the name immediately recognizable and the current activity easy to discover.

Do not display empty fields as awkward blank spaces. Handle missing information gracefully.

Right column — Direct message

Display a clearly identifiable Direct message button at the far right of the entry.
Keep the button aligned consistently across personnel entries.
Provide hover, focus, and pressed states.
On smaller screens, reorganize the entry without sacrificing readability or making the button inaccessible.
3.2 Working availability timeline

Below each personnel entry, display a horizontal timeline spanning the full width of the entry, including the portrait, information, and action columns.

The timeline must communicate when a person is working and when visitors are welcome to approach them.

The timeline is a functional representation of time, not a decorative progress bar.

Timeline requirements:

Show the shift start time at the far left.
Show the shift end time at the far right.
Represent the full shift proportionally along the timeline.
Display unreserved periods within the shift in green or cyan to communicate availability and encourage visitors to make contact.
Display reserved periods in red.
Position each reservation according to its actual start and end times relative to the shift.
Preserve the correct chronological order and proportional duration of every segment.
Display time labels clearly enough that visitors can understand the schedule.
Show a clear distinction between time outside the shift and available time within the shift.
Never imply that someone is available outside their declared shift.
Support multiple reservations within one shift.
Handle shifts with no reservations, fully reserved shifts, and adjacent reservations.
Prevent overlapping reservations from producing misleading availability indicators.
Include accessible labels or text so that the meaning of each color is not dependent on color perception alone.

Use the following visual semantics:

Green or cyan: Working and unreserved; visitors are welcome to approach.
Red: Reserved or occupied.
Neutral grey: Outside the working shift or otherwise unavailable.

Add a subtle timeline animation when the page loads or when the timeline changes. Keep the animation restrained and respect reduced-motion preferences.

If a visitor selects a timeline segment, optionally show its time range and availability status.

The timeline must use the same underlying sample data as the rest of the application, so its presentation is consistent and predictable.

3.3 Direct messaging entry point

When a visitor clicks Direct message on a personnel entry:

Open the appropriate messaging interface for that person.
If the visitor is not authenticated, allow them to initiate a conversation according to the MVP's public messaging rules.
Identify the recipient clearly.
Provide an obvious way to return to the directory.
Avoid dead ends, placeholder buttons, or navigation that loses the visitor's intended recipient.

The board must be able to use this flow from a separate phone or computer.

4. Private face — personnel workspace

Create a private interface that requires authentication and is optimized for mobile screens.

The private experience has two primary pages.

4.1 Private page one — Activity and inbox

At the top of the page, display a multiline text input with the exact placeholder:

"What are you doing today?"

Below the text input, display a wide Publish button.

Activity publishing behavior:

Allow the user to enter a short description of their current activity.
Publish the activity when the button is pressed.
Provide a clear success or error state.
Update the current user's public personnel entry so the published activity appears in the public directory.
Replace the displayed interests with the current activity while an activity is available.
If no activity is published, fall back to the person's interests.
Provide a simple way to clear or update the current activity.
Preserve the relationship between the authenticated user and the published status.

Under the activity input, display a list of received messages and existing conversations.

Each conversation entry should show:

Sender's profile photograph or avatar.
Sender's name.
A preview of the latest message.
The time of the latest message.
An unread indicator when appropriate.
A clear visual distinction between read and unread conversations.

Sort the inbox by most recent activity.

Selecting a conversation must open the second private page.

4.2 Private page two — Individual chat

Build a complete one-to-one messaging interface inspired by WhatsApp's familiar interaction patterns, without copying its branding.

The chat page must include:

Conversation header

The other person's profile photograph or avatar.
Their name.
A back navigation control.
An optional indication of availability, provided the information is available and accurate.

Message history

Display the complete available conversation history in chronological order.
Visually distinguish messages sent by the current user from messages received from the other person.
Include timestamps.
Handle long messages, consecutive messages, and scrolling naturally.
Load older messages appropriately if pagination is needed.

Message composer

A multiline message input.
A Send button.
Support sending a message using the Enter key where appropriate, without making multiline composition inconvenient.
Clear the composer after successful sending.
Show a clear sending, sent, or error state.
Keep the latest message visible when appropriate.

Conversation behavior

New messages must appear without a manual page refresh.
Messages must appear in the correct conversation.
The sender must see their outgoing message and the recipient must see the corresponding incoming message.
Update inbox previews and unread indicators when messages arrive.
Preserve conversation history when users navigate away and return.
Handle temporary connection failures gracefully.

Do not use fabricated messages to represent successful real-time delivery.

5. Authentication and public messaging

The MVP must distinguish between public browsing and private personnel access.

Public visitors

Can browse personnel profiles and availability without logging in.
Can initiate a conversation with a personnel member through the public interface.
Must not be able to access the recipient's private inbox or other conversations.
Should have an understandable messaging identity, such as a visitor name and contact identifier, according to the selected MVP authentication approach.

Department personnel

Must log in to access their private workspace.
Can publish their activity.
Can read their own conversations and reply to messages.
Must not be able to read other personnel members' private conversations merely by changing a URL or identifier.

Provide a simple, polished login screen for the private interface.

For the presentation, create a dedicated presenter account and at least one fictional personnel account.

Use a secure authentication mechanism appropriate to the chosen backend. Do not treat a frontend-only login screen as real authentication.

Keep private messages and authentication credentials out of publicly accessible profile data.

6. Real-time board presentation scenario

This is a central acceptance criterion for the MVP.

The application must support the following demonstration from separate devices over the internet.

The presenter displays a QR code pointing to the deployed public website.
A board member scans the QR code using their own phone.
The board member browses the public personnel directory.
They locate the presenter using the presenter's sample or configured profile.
They inspect the presenter's research, current activity, languages, and availability timeline.
They click Direct message and send a message.
The presenter opens the private interface on their own PC or phone and logs in.
The incoming message appears in the presenter's inbox without requiring a refresh.
The presenter opens the conversation and replies.
The board member receives the response on their own device without requiring a refresh.
Both participants can continue the conversation and see the shared message history.

The public and private interfaces must share a common backend and conversation data.

Use real-time subscriptions, WebSockets, or an equivalent suitable mechanism for cross-device message updates.

If a backend service must be configured separately, document the minimum requirements and setup steps. The application must not silently fall back to a local-only simulation while presenting the chat as real.

Include a visible way for the presenter to reset fictional demo data, but never let that reset action delete genuine users' data or real conversations.

7. Sample data and initial presentation

Populate the application with enough fictional personnel to make the directory feel realistic.

Include at least five fictional department members, including the presenter.

Vary their:

Names and profile photographs.
Research topics and academic backgrounds.
Study years.
Languages and proficiency levels.
Current activities and fallback interests.
Shift start and end times.
Number and duration of reservations.

Ensure that the timeline examples include:

A shift with no reservations.
A shift with one reservation.
A shift with multiple reservations.
A fully reserved shift or a clearly unavailable period.
Different shift lengths.

Use clearly fictional identities and avoid importing real personal information.

Create a small amount of initial sample conversation history to make the inbox and chat interface easy to evaluate.

Clearly separate fictional seed data from real user-generated content.

The initial demo should open in a polished state rather than requiring the presenter to populate all profiles manually.

8. Feedback gathering

The purpose of the MVP is to gather feedback from the board and prospective users.

Include an accessible feedback form or feedback page.

Allow visitors to submit:

A general rating of the experience.
Comments or suggestions.
Feedback about the personnel directory.
Feedback about the availability timeline.
Feedback about messaging usability.

Make the feedback process simple and usable on mobile.

Show a confirmation after successful submission.

If feedback is stored, use an appropriate backend rather than pretending that a local-only submission has been delivered to the project owner. Document where submitted feedback can be reviewed.

Do not require visitors to provide unnecessary personal information.

9. Technical expectations

Use Flutter with web support as the intended frontend framework.

The project should be organized so that the public and private interfaces share reusable components, design tokens, data models, and application logic.

Keep the codebase compatible with GitHub-based development and future deployment through Vercel.

Select or recommend a suitable backend for authentication, persistent conversation storage, and real-time messaging. Clearly identify any external services and their configuration requirements.

Do not hardcode credentials, private keys, or production secrets.

The frontend must not be trusted to enforce private access controls. Protect private data and operations at the backend.

Provide appropriate loading states, empty states, error messages, form validation, and responsive behavior.

Use a consistent source of truth for profile data, published activities, shift schedules, reservations, and conversations.

Do not introduce unnecessary architectural complexity for features that are not needed by this MVP.

10. MVP acceptance criteria

The MVP is ready for board presentation when all the following are satisfied:

The public directory renders multiple realistic personnel entries.
Each entry contains a portrait, personnel information, and a Direct message action.
The availability timeline accurately represents working shifts and reservations, using green or cyan for available time and red for occupied time.
The current activity appears publicly after the authenticated user publishes it.
Interests appear as the fallback when no current activity is available.
The private login provides genuine access control.
The private inbox lists conversations and unread indicators.
A user can open a conversation, send messages, and review the history.
A public visitor can initiate a conversation with the presenter.
Messages synchronize between the visitor's device and the presenter's device without manual refresh.
The application remains usable on desktop and mobile.
Feedback can be submitted and retrieved through the configured feedback mechanism.
Setup instructions clearly describe how to run, configure, and deploy the MVP.
No core presentation interaction is merely decorative or falsely reports success.
11. Development priorities

Implement the MVP in this order:

Establish the visual design system and responsive public directory.
Implement the personnel profiles and accurate availability timeline.
Build the private activity and inbox page.
Build the individual chat page.
Connect authentication, shared persistence, and real-time messaging.
Add realistic demo data and the feedback flow.
Validate the complete cross-device presentation scenario.
Document the deployment process and remaining limitations.

Prioritize a coherent, reliable demonstration over an excessive number of features.

The final product should allow a board member to discover a person, see when they are available, send a message, and receive a real reply from the presenter — all through a polished public and private web experience.
```

## version 2
```
MASTER PROMPT — BUILD AND RUN THE DEPARTMENT MVP DIRECTLY IN THE BROWSER
1. Your mission

Act as an expert full-stack developer and build a working MVP for a department personnel directory, availability calendar, messaging platform, and long-term service request system.

Your primary deliverable is a RUNNING, INTERACTIVE WEB APPLICATION that I can immediately open and test in the browser preview. Do not respond with architecture recommendations, a development plan, wireframes, or instructions telling me how to build the application myself. BUILD THE APPLICATION FIRST.

Use the available coding environment, browser preview, application builder, and connected tools to create and run the actual application.

Do not stop after explaining what you intend to build. Start implementing the user interface and working interactions immediately. Make reasonable technical decisions independently.

If the environment supports a live application preview, launch the application and make it available there. If it supports a persistent development server, run it and verify the preview. Do not merely print source code when you can render and run the application directly.

If a particular environment limitation prevents execution, explain the specific limitation and provide the closest genuinely runnable result available.

2. Product requirements

Build two connected interfaces backed by shared application data.

Public website

Provide four navigation destinations:

Directory.
Daily Calendar.
Long-Term Requests.
Feedback.

The public website must be accessible without requiring a personnel account.

Private workspace

Provide a personnel login and private workspace containing:

Daily activity publishing.
Inbox and unread indicators.
Individual messaging.
Incoming long-term request management.
Authorized demo-data reset.

The public and private interfaces must work together as one application.

3. Immediate browser-preview requirements

Before doing any architectural discussion, create a complete, visually polished, interactive application that opens in the browser.

The first runnable version must include:

A fully rendered public directory.
At least five realistic fictional personnel profiles with portraits.
Working navigation between all public pages.
A functional daily calendar displaying 30-minute intervals.
An availability timeline beneath directory entries.
A long-term request form with validation.
A feedback form.
A personnel login screen.
An activity publishing page.
An inbox and individual chat interface.
A long-term request management view.
Sample data that makes the application immediately testable.
Responsive desktop and mobile layouts.
Clear success, error, loading, and empty states where applicable.

Every visible primary action must work. Do not use inert buttons or decorative controls that imply functionality that does not exist.

Do not wait for an external backend to be configured before implementing and displaying the frontend.

4. Demo mode and real backend behavior

Provide an immediately usable demonstration mode using fictional seed data.

Demo mode must allow me to explore the entire user experience without first configuring external credentials.

Where backend functionality is unavailable, implement clearly identified local demo behavior for interface testing, including:

Browsing personnel and schedules.
Filtering the calendar.
Publishing sample activities.
Creating sample service requests.
Changing request statuses through authorized demo controls.
Navigating between inbox and chat.
Testing message composition and conversation interactions.
Submitting sample feedback.

Persist demo data across navigation and refresh when the execution environment supports appropriate local persistence.

Clearly distinguish demo behavior from verified backend behavior. Never label local-only messages as genuinely delivered to another device.

Keep the application architecture ready for a real shared backend, so demo-only data handling can later be replaced without redesigning the entire interface.

If a backend or connected service is available, use it. Implement real authentication, persistent shared data, backend authorization, and real-time messaging where the environment permits. Do not invent credentials, claim external services are connected when they are not, or silently substitute local simulation for real cross-device functionality.

5. Visual design

Use a polished academic editorial style for the public interface:

White or neutral backgrounds.
Strong typography.
Portrait-oriented personnel entries.
Generous white space.
Subtle borders.
Restrained colors.
Clear information hierarchy.

Use a modern, mobile-friendly messaging layout for the private interface.

The public interface is desktop-first; the private interface is mobile-first. Both must remain usable on other screen sizes.

Include keyboard accessibility, visible interaction states, readable contrast, accessible labels, and reduced-motion support.

6. Personnel directory

Display at least five fictional department members.

Each profile must include:

Portrait photograph.
Current activity, if available; otherwise interests.
Full name.
Research topics.
Academic background.
Study year, where applicable.
Languages and proficiency levels.
Direct message button.

Use fictional sample data and realistic portraits. Gracefully handle missing fields.

Publishing or clearing an activity in the private workspace must update the public profile through the application's shared data model.

Visitors must be able to browse without logging in and initiate a conversation with the selected person.

7. Availability timeline

Display a horizontal timeline below every personnel entry, spanning the complete entry width.

Green/cyan: working and available.
Red: reserved or occupied.
Neutral grey: outside the shift or otherwise unavailable.

Show shift start and end times. Position reservations proportionally according to actual start and end times.

Support multiple reservations, empty shifts, fully reserved shifts, different shift lengths, adjacent reservations, overlaps, and partial intervals.

Never imply availability outside working hours. Prevent overlapping reservations from creating misleading availability. Use accessible labels so status is not communicated through color alone.

The timeline must use the same schedule data as the daily calendar.

8. Daily calendar

Create an interactive daily calendar with:

Date selection and previous/next-day navigation.
30-minute time intervals.
Personnel portraits and names in the relevant blocks.
Availability and reservation indicators.
A personnel filter.
Responsive layouts and clear empty states.

Show all relevant personnel by default. Allow visitors to filter individual people.

Use actual shifts and reservations to calculate availability. A block must not appear fully available if a reservation occupies only part of that interval.

Selecting a person's portrait or name opens their profile.

The calendar is for availability discovery, not instant booking. Do not create conflicting schedules or separate calendar data that disagrees with the directory timeline.

9. Long-term service requests

Create a public request form for services lasting between two months and twelve months.

Support these categories:

Language learning.
Programming.
Research assistance or collaboration.
Academic support.
Other, with a free-text description.

Collect:

Requester's name and email.
Selected personnel member.
Service category and description.
Start and end dates.
Preferred days and times.
Requested hours per week.
Scheduling flexibility.
Optional goals and additional details.

Validate required fields, date ranges, and the permitted duration. Do not implement payments or assume that services are paid or free.

Submitting a request must create a request record in the application's active data store and show a genuine confirmation for the mode being used.

Implement the following statuses:

Pending.
Accepted.
Rejected.
Cancelled.

Provide a private request-management view with actions appropriate to the current user's permissions.

The default approval model is personnel-led review with configurable administrative oversight.

10. Long-term scheduling rules

Keep the requested service period separate from confirmed working hours.

A six-month request must not block every calendar interval during those six months.

Pending requests do not create confirmed reservations.
Accepted requests without agreed times must not generate invented time slots.
Accepted requests with agreed recurring sessions create corresponding schedule entries.
Confirmed sessions must appear consistently in the calendar and timeline.
Conflicting confirmed reservations must be prevented.
Rejected or cancelled requests must not continue blocking future time solely because they previously existed.

Allow conflicts and alternative schedules to be reviewed or negotiated.

Visitors must be able to follow up securely on their own requests without gaining access to personnel inboxes or other visitors' records.

11. Authentication and private workspace

Provide a personnel login screen and a dedicated presenter account in demo mode.

The private workspace must include:

Activity publishing

Display a multiline input with this exact placeholder:

"What are you doing today?"

Include a Publish button. Allow publishing, editing, and clearing activities.

Inbox

Display conversations sorted by most recent activity. Show the other participant's portrait, name, latest-message preview, timestamp, and unread indicator.

Individual chat

Include a conversation header, message history, timestamps, sent/received message styling, multiline composer, Send button, and appropriate sending/error states.

Keep conversation history when navigating away and returning. Update inbox previews and unread indicators when messages arrive.

Messaging requirements

In demo mode, messages may be simulated for interface testing, but the interface must clearly identify that mode.

When a real backend is configured, messages must be persisted and delivered between separate devices through real-time subscriptions or an equivalent mechanism.

Public visitors must not access private personnel inboxes, impersonate personnel, or read unrelated conversations.

12. Feedback

Create an interactive feedback form covering:

General experience rating.
Comments and suggestions.
Directory.
Availability timeline and calendar.
Messaging.
Long-term requests.

Keep the form short and mobile-friendly.

Store submissions in the active data store. Clearly distinguish demo feedback from feedback actually delivered to the project owner.

13. Seed data and demo controls

Include at least five fictional personnel members, with varied portraits, research interests, backgrounds, languages, activities, and schedules.

Provide sample shifts illustrating:

No reservations.
One reservation.
Multiple reservations.
Fully reserved periods.
Adjacent reservations.
Different shift lengths.
Partial 30-minute overlaps.
Multiple people working simultaneously.

Include sample conversation history and long-term requests in different statuses.

Provide a clearly identified demo reset control for authorized demo users. It must only reset fictional demo data, never genuine user records.

Make the application immediately useful without requiring me to create every sample record manually.

14. Technical quality and security

Use a coherent shared data model for personnel, activities, shifts, reservations, recurring commitments, conversations, messages, requests, and feedback.

Use Flutter web where the execution environment supports it. If the available browser-building environment cannot execute Flutter directly, prioritize delivering the immediately runnable preview and clearly explain the framework limitation rather than pretending Flutter is running.

When connecting a real backend, use proper authentication, persistent storage, backend-enforced authorization, secure visitor access, and real-time messaging.

Do not expose privileged credentials in frontend code. Do not trust frontend route guards as the sole security mechanism.

Support a GitHub-based workflow and document Vercel or other compatible deployment requirements.

Avoid unnecessary infrastructure and production administration features.

15. Implementation priorities

Build and render the application in this order:

Create the complete application shell, navigation, visual design, and fictional seed data.
Implement the directory and availability timeline.
Implement the daily calendar and date/person filters.
Implement the long-term request form and request-management view.
Implement the private activity page, inbox, and chat.
Implement feedback and demo controls.
Connect the available backend and real-time functionality.
Verify responsive behavior, business rules, and core interactions.

Do not stop after listing these steps. Execute them.

Prioritize a complete, testable browser experience over lengthy explanations.

16. Acceptance criteria

The browser preview must allow me to:

Browse at least five personnel profiles.
Inspect working availability and reservations.
Navigate the daily calendar in 30-minute intervals.
Filter personnel and inspect their profiles.
Publish a sample activity and see it reflected in the directory.
Create a valid long-term request and see it in request management.
Test request status changes.
Open the inbox and individual chat.
Compose and interact with messages.
Submit feedback.
Navigate between all interfaces without dead ends.
Use the application on desktop and mobile layouts.
Reset fictional demo data safely.

Additionally, when a real backend is configured, verify that authentication, persistence, access controls, cross-device messaging, and shared scheduling actually work.

Do not claim real cross-device delivery or production security based only on a local demo.

17. Final response

Your first priority is to create and launch the working application in the browser preview.

After implementation, briefly report:

How to open and test the running application.
Which features are functional in demo mode.
Which features are connected to a real backend and verified.
Which external configuration remains necessary.
Any significant limitations discovered during testing.

Do not return another architecture proposal instead of the application.

START BUILDING THE RUNNABLE MVP NOW.
```