#!/usr/bin/env bash

set -euxo pipefail

INPUT_FILE="$1"
OUTPUT_DIR="$2"

ICONTOOL=$(echo /Applications/Xcode*.app/Contents/Applications/Icon\ Composer.app/Contents/Executables/icontool)

platforms=("iOS")
appearances=("Default" "Dark" "Mono")
sizes=("20" "29" "38" "40" "60" "64" "68" "76" "83.5" "1024")
scales=("1" "2" "3")

for platform in "${platforms[@]}"; do
  for appearance in "${appearances[@]}"; do
    for size in "${sizes[@]}"; do
      for scale in "${scales[@]}"; do
        "$ICONTOOL" "$INPUT_FILE" --export-preview "$platform" "$appearance" "$size" "$size" "$scale" "$OUTPUT_DIR/$platform-$appearance-$size@${scale}x.png"
      done
    done
  done
done
