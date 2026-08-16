#!/bin/bash
set -e

FLUTTER_VERSION="3.41.7"

if [ ! -d "$HOME/flutter" ]; then
  git clone --depth 1 --branch "$FLUTTER_VERSION" \
    https://github.com/flutter/flutter.git "$HOME/flutter"
fi

export PATH="$HOME/flutter/bin:$PATH"

flutter config --enable-web
flutter --version
flutter pub get
flutter build web --release