#!/bin/bash
# .git/hooks/pre-commit

echo "🔄 Background Scanner: Rebuilding blueprint.md from Flutter structure..."

TARGET_MD="documentation/process_blueprints.md"
TARGET_IMG="documentation/visuals/blueprint_charts.png"

# Generate Header
cat << 'INNER_EOF' > $TARGET_MD
# 🗺️ System Blueprint (Auto-Generated from Flutter Codebase)

This documentation maps out your structural layers, user access permissions, and system flows directly from your local Dart codebase configuration.

---

## 1. Code-Inferred User Roles & Screens Matrix
The following architecture map shows the roles discovered inside your Flutter project logic and how they connect to UI features.
INNER_EOF

# --- LAYER 1: DYNAMIC ROLE & SCREEN ACCESS DETECTION ---
echo -e "\`\`\`mermaid\ngraph TD\n    subgraph Roles Detected" >> $TARGET_MD

# Scan Dart files for common Role definitions/enums (Admin, Manager, Operator, User, etc.)
if [ -d "lib" ]; then
    # Look for roles in enums or strings (case-insensitive)
    ROLES=$(grep -rioh "role\.[a-zA-Z0-9_]*\|admin\|manager\|operator\|supervisor\|worker" lib/ | sort -u | tr '[:upper:]' '[:lower:]' | head -n 5)
    
    if [ -z "$ROLES" ]; then
        # Default fallback if no explicit roles are coded yet
        echo "        Role_Default[Generic User Role]" >> $TARGET_MD
    else
        for role in $ROLES; do
            # Clean up syntax characters if matching an enum line
            clean_role=$(echo "$role" | sed 's/role\.//g')
            echo "        Role_${clean_role}[Role: ${clean_role}]" >> $TARGET_MD
        done
    fi
fi
echo "    end" >> $TARGET_MD

echo -e "    subgraph Inferred UI Screens" >> $TARGET_MD
# Automatically grab actual Flutter Screen/Widget class names
if [ -d "lib" ]; then
    SCREENS=$(find lib -type f -name "*.dart" | xargs grep -h "class .* extends" | awk '{print $2}' | grep -i "page\|screen\|view\|widget" | sed 's/State//g' | sort -u | head -n 6)
    for screen in $SCREENS; do
        echo "        UI_${screen}[Screen: ${screen}]" >> $TARGET_MD
    done
fi
echo "    end" >> $TARGET_MD

# Draw connections from all roles to all discovered UI screens to show the Single-Screen mapping
echo "    Roles Detected --> Inferred UI Screens" >> $TARGET_MD
echo -e "\`\`\`\n" >> $TARGET_MD


# --- LAYER 2: DYNAMIC FLOWCHART PROCESS DETECTION ---
cat << 'INNER_EOF' >> $TARGET_MD
---

## 2. Technical System Process Flowchart
This flowchart shows how data actions flow from your Flutter presentation layers down to your storage models (SQLite/Cloud Sync).
INNER_EOF

echo -e "\`\`\`mermaid\ngraph LR" >> $TARGET_MD
echo "    UI_Layer[Flutter UI Widgets] -->|Triggers Action| Controller[State Controller / Bloc / Riverpod]" >> $TARGET_MD

# Scan code to see where data is routed to display in the flowchart
if grep -rq "sqlite\|sqflite" lib/; then
    echo "    Controller -->|Process 1: Local Cache| SQLite[(Local SQLite DB Cache)]" >> $TARGET_MD
fi
if grep -rq "sharepoint\|http\|dio\|client" lib/; then
    echo "    Controller -->|Process 2: Network Cloud Sync| SharePoint[[SharePoint List API]]" >> $TARGET_MD
fi
if grep -rq "excel\|csv\|export" lib/; then
    echo "    SQLite -->|Process 3: Hardcopy Export| Excel[Excel / CSV Backup Sheet]" >> $TARGET_MD
    echo "    SharePoint -->|Process 3: Hardcopy Export| Excel" >> $TARGET_MD
fi
echo -e "\`\`\`\n" >> $TARGET_MD


# --- LAYER 3: DYNAMIC TIMELINE LOG ---
cat << 'INNER_EOF' >> $TARGET_MD
---

## 3. Dynamic Development Timeline Log
Generated directly from code tags and version changes.

```mermaid
gantt
    title Historical Git Activity Track
    dateFormat  YYYY-MM-DD
    section Commit Milestones
INNER_EOF

# Grab last 5 commit summaries and append as a Gantt track safely
git log -n 5 --date=short --pretty=format:"    %s :active, %cd, 3d" | sed 's/[:\/()]/ /g' >> $TARGET_MD
echo -e "\n\`\`\`" >> $TARGET_MD

# --- SYSTEM FIX: TARGET THE EXPLICIT PNG FILENAME EXTENSION ---
if command -v npx &> /dev/null; then
    # Pointing directly to a file path ending in .png fixes your exact compiler error output
    npx -y @mermaid-js/mermaid-cli -i $TARGET_MD -o $TARGET_IMG
fi

exit 0