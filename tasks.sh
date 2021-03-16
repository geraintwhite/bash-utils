#!/bin/bash

task() {
  TASK_NAME="$1"

  SECONDS=0
  TASK_NUMBER=$((TASK_NUMBER + 1))

  shift

  echo ""
  echo "$TASK_NAME... [$TASK_NUMBER/$TASK_TOTAL]"

  "$@"

  echo "$TASK_NAME finished in ${SECONDS}s  ✓"
}

#
# Example Usage
#
#
# TASK_NUMBER=0
# TASK_TOTAL=9
#
# λ() {
#   npm run build:android:dev
#   archive $ANDROID_BUILD android-dev.apk
# }
# task "Packaging Android dev build" λ
#
