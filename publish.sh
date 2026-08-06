#!/bin/bash

set -e

PROJECT_ROOT=$(pwd)
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "=== Building gcl_personnel ==="

flutter clean
flutter pub get

flutter build web \
  --release \
  --base-href /gcl_personnel/


echo "=== Preparing main app ==="

rm -rf /tmp/gcl_personnel_pages
mkdir -p /tmp/gcl_personnel_pages

cp -r build/web/* \
      /tmp/gcl_personnel_pages/

echo "=== Building reservation app ==="

cd sharepoint_reservation_app

flutter clean
flutter pub get

flutter build web \
  --release \
  --base-href /gcl_personnel/reservation/

mkdir -p ../tmp_reservation_build

cd ..

mkdir -p /tmp/gcl_personnel_pages/reservation

cp -r sharepoint_reservation_app/build/web/* \
      /tmp/gcl_personnel_pages/reservation/


echo "=== Switching to gh-pages ==="

git checkout gh-pages


echo "=== Updating gh-pages files ==="

rm -rf gcl_personnel

cp -r /tmp/gcl_personnel_pages/gcl_personnel .


echo "=== Commit deployment ==="

git add .

git commit \
  -m "Deploy Flutter web apps last update: ${TIMESTAMP}" \
  || echo "No changes detected"


echo "=== Push gh-pages ==="

git push --force origin gh-pages


echo "=== Return to previous branch ==="

git checkout -


echo "=== Cleanup ==="

rm -rf /tmp/gcl_personnel_pages

echo "=== Deployment completed ==="pw