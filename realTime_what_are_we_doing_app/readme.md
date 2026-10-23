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