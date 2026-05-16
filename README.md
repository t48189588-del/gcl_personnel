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
  - [ ] working report (only activated AFTER the shift)
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

# Presentation scheme
- Current situation (5 min)
  - data organization
    -  Excel (book & sheets)
    -  SNS platforms   
  - pros & cons
    - not easily comparable
    - not automatically scalable
    - wasted/unused space (blank cells) show in % utilization
    - easily error by human hand
    - not chained/linked
- Proposal explanation (5 min)
  -   option 1: Power apps: included in the kyutech office 365 yearly license
  -   option 2: Flutter: completely aisled but more customizable & integradable with other tools
  -   build a single platform for all functions and services for all GCL personnel (and external visitors)
    -   clearly labled in the users native language
    -   short videos for explanations (<3 min)
    -   keep exporting data as is, graphing generation and possible llm integration
  -   Costs
    - personnel
    - equipment
- Demo (10 min)
  - pre record actions
  - Live demo with 
- my profile and experience (5 min)
  - national university engineer
  - projects to display
    -   DINAGEA electric dashboard (national scale)
    -   DIPLAN estudio de capacidad instalada (national scale)
    -   LABSI insight (national scale)
- final Q&A and requirements (5 min)
  - requirements
    - permission
      - to use GCL staff present in teams and website
        - emails, names, studies, language information 
        - working schedules
        - working reports
        - events
        - meetings
      - SNS public information
    - Assistance from Kyutech personnel (optional): for faster development
      - double check japanese information (format and styling)
      - making the documentation
        - written
        - videos with japanese audio
      - setting color scheme and shapes compliant with Kyutech standards
      - for future stage and admin
        - data collection on
          - All GCL equipment information and data sheet (dimensions and complete capabilities)

# Tool development for presentation
Your complete implementation summary, hardware analysis, and specialized development prompts are ready.

Because your presentation requires an flawless, zero-latency execution in under 10 minutes, the architecture below has been specifically tuned for your exact hardware constraints.

---

## Part 1: Comprehensive System Architecture Summary

### 1. Data Processing Engine (Python Pipeline)

* **Bounding Box Isolation:** Instead of reading the spreadsheet blindly, the Python backend loops through every sheet in the Excel workbook, dynamically detecting contiguous coordinate boxes (blocks of data bounded by empty rows and columns) to isolate overlapping or floating tables without data loss.
* **Deterministic Normalization:** Heavy operations (global trailing/leading whitespace removal, structural stripping, lower/snake_case header formatting, type casting) are handled purely by Pandas to guarantee sub-second execution speeds and 0% risk of AI hallucination.
* **Telemetry Tracker:** Evaluates data composition at initial intake vs. final export. It tracks total row/column shapes, counts of blank cells, string lengths, and data errors, compiling a live "Wasted Characters & Layout Blocks Cleared" metric to prove data ROI to the audience.

### 2. Live Interaction Stack (Streamlit UI Layout)

* **Stage 1: Drag-and-Drop Ingestion:** Left-hand panel accepts messy multi-sheet Excel files.
* **Stage 2: Schema Alignment Panel:** Displays the local LLM’s live thought process as it matches mismatched headers to a target schema, showing the audience the semantic relationship mapping.
* **Stage 3: Human-in-the-Loop (HITL) Editor:** An interactive grid allowing live double-click column renaming (e.g., `Date` to `Timestamp`) alongside a "Transformation Toolbox" allowing users to split columns dynamically (e.g., separating `1:00pm-2:30pm` by a delimiter into `Start_Time` and `End_Time`).
* **Stage 4: Clean Analytics Dashboard:** Converts the locked data into instant visual KPI metric cards, distribution charts (Plotly/Altair), and data-completeness heatmaps showing 0% noise.
* **Stage 5: Dual-Format Exporter:** A toggle enabling instantaneous structural compilation into clean **CSV** (`df.to_csv`) or nested **JSON** (`df.to_json`) previews and downloads.

---

## Part 2: Hardware Suitability Analysis

### Your Device Specs:

* **GPU:** NVIDIA RTX Ada 500 Laptop GPU (4GB VRAM)
* **RAM:** 16GB System RAM
* **CPU:** Intel Core Ultra 7 155H (with integrated NPU)

### The Constraint: 4GB VRAM

Running a standard 14B or 32B parameter model locally requires 10GB to 24GB of VRAM. Loading those onto your machine will force the model to offload to your System RAM, introducing massive token-generation delays that will break your "<10 minute presentation" requirement.

### The Solution: Optimized 3B to 8B Quantized Models

To achieve instant, split-second responses in front of an audience on an Ada 500, you must run tightly quantized small language models (SLMs) that fit completely inside your 4GB VRAM.

* **Primary Recommendation: Llama-3.1-8B-Instruct (Quantized to Q3_K_L or Q4_K_M via Ollama)**
* *VRAM Footprint:* ~3.5 GB to 4.2 GB.
* *Why:* Incredible schema comprehension, highly articulate instruction-following, and perfectly fits your GPU tier.


* **Speed Alternative: Qwen2.5-Coder-3B-Instruct (Quantized to Q4_K_M or Q8_0)**
* *VRAM Footprint:* ~2.2 GB to 3.2 GB.
* *Why:* Extremely lightweight. It leaves a safety buffer for your 16GB system RAM and Streamlit UI to run simultaneously without risking a system freeze during your live demo. It excels at delivering raw JSON schema maps.



---

## Part 3: Ready-to-Use Development Prompts

To generate your application, open a new LLM conversation thread and execute these two specialized prompts sequentially.

### Prompt 1: Building the Core Data Engine & Streamlit UI

```text
Act as a Principal Python Engineer specializing in data pipelines and Streamlit application design. I need you to write a complete, production-ready Streamlit application that functions as an interactive data cleaning and consolidation pipeline. The application must process data deterministically using Python and Pandas to ensure speed and zero data loss.

The app must feature a clean, professional multi-stage layout optimized for a live audience presentation:

1. METRICS & TELEMETRY ENGINE:
   - Create a helper function that takes a raw Excel workbook and calculates: Total rows/columns, count of empty/null cells, count of leading/trailing whitespaces, and total character length of all strings combined.
   - Create an identical metric evaluator for the final output so we can display a "Before vs. After" side-by-side comparison matrix showing an "Efficiency Score" (Wasted characters and layout blocks removed).

2. INGESTION & BOUNDING BOX DISCOVERY:
   - Provide a drag-and-drop file uploader for Excel files (`.xlsx`).
   - Write python logic to loop through all sheets in the uploaded workbook. It must dynamically detect separate tables on a single sheet using continuous bounding box discovery (identifying blocks of contiguous non-empty data separated by blank rows or columns). Extract these into separate temporary DataFrames and globally apply `.strip()` to string columns and normalize letter casing.

3. HUMAN-IN-THE-LOOP (HITL) EDITING PANEL:
   - Display an interactive data editor using Streamlit's native data editing features allowing the user to double-click and change column headers manually on the screen.
   - Implement a "Smart Split Toolbox": Include UI fields where a user can select a column (e.g., a time range column like "1:00pm-2:30pm"), input a custom delimiter (like "-"), and automatically split it into two newly named columns in the underlying dataframe.

4. POST-CLEANED DASHBOARD PREVIEW:
   - Below the editing panel, once data is confirmed, display a beautiful dashboard containing:
     a) Three large visual KPI metric cards (Total Records Processed, Unique Categories, Columns Aligned).
     b) A dynamic bar chart or histogram (using Plotly or Altair) displaying data distribution based on the numerical or categorical columns present.
     c) A completeness heatmap proving missing data gaps have dropped to 0%.

5. OUTPUT CUSTOMIZATION EXPORTER:
   - Provide a toggle or radio selection for "Export Format" supporting CSV and JSON.
   - If CSV is chosen, prepare a download button running `df.to_csv(index=False)`. If JSON is chosen, format it cleanly using `df.to_json(orient='records', indent=4)` and show a code preview block of the raw structural JSON before downloading.

Ensure the code is self-contained, handling all exceptions elegantly so it does not crash on stage. Use placeholder mock functions for the LLM header mapping step for now; I will insert the local LLM logic in the next step. Write the full script out. Do not use snippets or leave code blocks incomplete.

```

### Prompt 2: Integrating the Local LLM Schema Mapping

```text
Act as an AI Engineer specializing in local LLM integrations and structured JSON formatting. I have a Streamlit app that extracts multiple disjointed tables from Excel sheets using Pandas. Now, I need you to write the exact integration layer to connect this pipeline to a local LLM running via Ollama.

Given that my presentation machine has a 4GB VRAM NVIDIA Ada 500 GPU, 16GB RAM, and an Intel Ultra 7, we are explicitly targeting the 'llama3.1:8b' or 'qwen2.5-coder:3b' models running locally via Ollama to maximize execution speeds (< 5 seconds per request).

Please write the Python functions to execute the following pipeline logic:

1. SCHEMA MAPPING EXTRACTION:
   - Write a function that takes the extracted disparate header names from the Python ingestion step (e.g., a dictionary like `{'Table_1': ['Client Name', 'ID'], 'Table_2': ['Cust_Nm', 'Identifier']}`) and builds a compact prompt string.
   - The prompt must instruct the local LLM to act as a data architect, evaluate the semantic similarities, and return a strictly structured JSON mapping map outlining how to reconcile these disjointed headers into a unified master schema target.

2. LOCAL OLLAMA API CALL WITH ENFORCED STRUCTURE:
   - Use Python's `requests` library or the official `ollama` python library to send this prompt to `http://localhost:11434/api/generate` (or `/api/chat`).
   - Crucial: Use Ollama's `format: 'json'` parameter in the API payload options to guarantee that the local model returns valid JSON without any conversational filler text or markdown backticks, ensuring it parses safely without crashing.

3. STREAMING LOGS FOR THE AUDIENCE:
   - Implement the call inside a Streamlit container with a progress spinner or a streaming text area, so the audience can watch the raw mapping generation loop complete live on the screen.

4. PANDAS EXECUTION LAYER:
   - Provide the accompanying Python function that takes the JSON map returned by the local LLM, maps the DataFrames natively in Pandas using `.rename()`, joins them into a singular master dataframe, and passes it forward to the UI dashboard layer built previously.

Integrate this cleanly as a standalone module or block of functions that drop straight into our Streamlit application architecture. Provide clear instructions on how to start the Ollama instance via terminal before launching the presentation app.

```
