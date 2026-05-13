#!/bin/bash

# Script: take_qa_screenshot.sh
# Purpose: Mengambil screenshot dari HP untuk evaluasi SDA V1.

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
FILENAME="screenshot_$TIMESTAMP.png"

echo "📸 Mengambil screenshot dari perangkat..."
adb shell screencap -p /sdcard/vizo_screen.png
adb pull /sdcard/vizo_screen.png ./screenshots/$FILENAME

echo "✅ Screenshot tersimpan: ./screenshots/$FILENAME"
echo "Master, silakan beritahukan SDA jika screenshot sudah siap dievaluasi."
