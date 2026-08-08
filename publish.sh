#!/bin/bash

set -e

# ============================================================
# Configuration
# ============================================================

PROJECT_ROOT="$(pwd)"
CURRENT_BRANCH="$(git branch --show-current)"
TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"

DEPLOY_DIR="/tmp/gcl_personnel_pages"

MAIN_BASE_HREF="/gcl_personnel/"
RESERVATION_BASE_HREF="/gcl_personnel/reservation/"


# ============================================================
# Safety checks
# ============================================================

echo "=== Checking repository ==="

if [ -z "$CURRENT_BRANCH" ]; then
    echo "ERROR: Could not determine current Git branch."
    exit 1
fi

if [ "$CURRENT_BRANCH" = "gh-pages" ]; then
    echo "ERROR: Run this script from the main/development branch."
    exit 1
fi

if [ ! -f "pubspec.yaml" ]; then
    echo "ERROR: pubspec.yaml not found."
    echo "Run this script from the gcl_personnel project root."
    exit 1
fi

if [ ! -d "sharepoint_reservation_app" ]; then
    echo "ERROR: sharepoint_reservation_app directory not found."
    exit 1
fi


# ============================================================
# Prepare temporary deployment directory
# ============================================================

echo "=== Preparing deployment directory ==="

rm -rf "$DEPLOY_DIR"
mkdir -p "$DEPLOY_DIR"


# ============================================================
# Build MAIN Flutter application
# ============================================================

echo ""
echo "============================================================"
echo " Building gcl_personnel"
echo "============================================================"

flutter clean
flutter pub get

flutter build web \
    --release \
    --base-href "$MAIN_BASE_HREF"


# ============================================================
# Copy MAIN application
#
# Result:
# gh-pages/
# ├── index.html
# ├── assets/
# ├── flutter.js
# └── ...
# ============================================================

echo "=== Preparing main application ==="

cp -r build/web/. "$DEPLOY_DIR/"


# ============================================================
# Build RESERVATION Flutter application
# ============================================================

echo ""
echo "============================================================"
echo " Building sharepoint_reservation_app"
echo "============================================================"

cd "$PROJECT_ROOT/sharepoint_reservation_app"

flutter clean
flutter pub get

flutter build web \
    --release \
    --base-href "$RESERVATION_BASE_HREF"


# ============================================================
# Copy RESERVATION application
#
# Result:
# gh-pages/
# ├── index.html
# ├── ...
# └── reservation/
#     ├── index.html
#     ├── assets/
#     └── ...
# ============================================================

echo "=== Preparing reservation application ==="

mkdir -p "$DEPLOY_DIR/reservation"

cp -r build/web/. "$DEPLOY_DIR/reservation/"


# ============================================================
# Return to repository root
# ============================================================

cd "$PROJECT_ROOT"


# ============================================================
# Switch to gh-pages
# ============================================================

echo ""
echo "============================================================"
echo " Deploying to gh-pages"
echo "============================================================"

echo "Current branch: $CURRENT_BRANCH"

git checkout gh-pages


# ============================================================
# Completely clean gh-pages working tree
#
# Keep .git, remove everything else.
# ============================================================

echo "=== Cleaning gh-pages branch ==="

find . -mindepth 1 -maxdepth 1 ! -name ".git" -exec rm -rf {} \;


# ============================================================
# Copy compiled applications
# ============================================================

echo "=== Copying compiled applications ==="

cp -r "$DEPLOY_DIR"/. .


# GitHub Pages should not process this as a Jekyll site.
touch .nojekyll


# ============================================================
# Show deployment structure
# ============================================================

echo ""
echo "=== Deployment structure ==="

echo ""
echo "Main application:"
echo "  ./index.html"

echo ""
echo "Reservation application:"
echo "  ./reservation/index.html"

echo ""
echo "Files deployed:"
find . -maxdepth 2 -type f | sort


# ============================================================
# Commit
# ============================================================

echo ""
echo "=== Committing deployment ==="

git add -A

if git diff --cached --quiet; then
    echo "No changes detected."
else
    git commit \
        -m "Deploy Flutter web apps last update: ${TIMESTAMP}"
fi


# ============================================================
# Push
# ============================================================

echo ""
echo "=== Pushing gh-pages ==="

git push --force origin gh-pages


# ============================================================
# Return to original branch
# ============================================================

echo ""
echo "=== Returning to ${CURRENT_BRANCH} ==="

git checkout "$CURRENT_BRANCH"


# ============================================================
# Cleanup
# ============================================================

echo ""
echo "=== Cleanup ==="

rm -rf "$DEPLOY_DIR"


# ============================================================
# Complete
# ============================================================

echo ""
echo "============================================================"
echo " Deployment completed successfully!"
echo "============================================================"

echo ""
echo "Main:"
echo "https://t48189588-del.github.io/gcl_personnel/"

echo ""
echo "Reservation:"
echo "https://t48189588-del.github.io/gcl_personnel/reservation/"
