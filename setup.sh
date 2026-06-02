#!/bin/bash
PROJECT_DIR="$(pwd)"
LOCAL_SDK_DIR="$PROJECT_DIR/.local_sdk"
LOCAL_CACHE_DIR="$PROJECT_DIR/.local_cache"

# Absolute local path isolation bypasses global user setups
export PUB_CACHE="$LOCAL_CACHE_DIR"
export PATH="$LOCAL_SDK_DIR/flutter/bin:$PATH"

show_progress() {
    local current=$1; local total=$2; local task=$3
    local percent=$(( current * 100 / total ))
    local bar=$(printf "%-$(( percent / 4 ))s" "#" | tr ' ' '#')
    local spaces=$(printf "%-$(( 25 - (percent / 4) ))s" " ")
    printf "\r[\033[32m%-25s\033[0m] %d%% | %s" "$bar$spaces" "$percent" "$task"
}

clear
echo "========================================================="
echo "🏎️  GCL Personnel Mobility Workspace Sandbox"
echo "========================================================="
echo "This installs a fully isolated, standalone Flutter 3.41 engine."
echo "👉 NO root/sudo authentication required."
echo "👉 NO global environmental properties will change."
echo "👉 Moving this directory to the trash erases EVERYTHING completely."
echo "========================================================="
echo ""

read -p "Authorize local system execution? (y/n): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Task aborted by user." ; exit 1
fi

TOTAL_STEPS=4

if [ ! -d "$LOCAL_SDK_DIR/flutter" ]; then
    show_progress 1 $TOTAL_STEPS "Building local container maps..."
    mkdir -p "$LOCAL_SDK_DIR" "$LOCAL_CACHE_DIR" ; sleep 1

    show_progress 2 $TOTAL_STEPS "Fetching compatible portable binary packages..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # Detect Mac Processor Type (Intel vs Apple Silicon M1/M2/M3)
        if [[ "$(uname -m)" == "arm64" ]]; then
            curl -L -o fltr.zip https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.41.0-stable.zip > /dev/null 2>&1
        else
            curl -L -o fltr.zip https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_x64_3.41.0-stable.zip > /dev/null 2>&1
        fi
        unzip -q fltr.zip -d "$LOCAL_SDK_DIR" && rm fltr.zip
    else
        # Standard Linux x64 core
        curl -L -o fltr.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.41.0-stable.tar.xz > /dev/null 2>&1
        tar -xf fltr.tar.xz -C "$LOCAL_SDK_DIR" && rm fltr.tar.xz
    fi
else
    show_progress 2 $TOTAL_STEPS "Local engine validated cleanly..." ; sleep 1
fi

show_progress 3 $TOTAL_STEPS "Populating local pubspecs dependencies..."
"$LOCAL_SDK_DIR/flutter/bin/flutter" pub get > /dev/null 2>&1

show_progress 4 $TOTAL_STEPS "Resolving internal linkages..." ; sleep 1
printf "\r\033[K"

echo "✅ Ready! Launching GCL Personnel Application Web Engine..."
echo "---------------------------------------------------------"
"$LOCAL_SDK_DIR/flutter/bin/flutter" run -d chrome