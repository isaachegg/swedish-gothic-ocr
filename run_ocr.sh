#!/bin/bash

# --- PRE-FLIGHT CHECKS ---

# 1. Check for Python 3.11
if ! command -v python3.11 &> /dev/null; then
    echo "Error: Python 3.11 is not installed."
    echo "Try: brew install python@3.11"
    exit 1
fi

# 2. Check for ImageMagick
if ! command -v convert &> /dev/null; then
    echo "Error: ImageMagick is not installed."
    echo "To fix this, run: brew install imagemagick"
    exit 1
fi

# --- SETUP ENVIRONMENT ---

# 3. Create/Activate virtual environment
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3.11 -m venv venv
fi
source venv/bin/activate

# 4. Install dependencies (quietly)
echo "Checking dependencies..."
pip install htrflow --quiet

# --- MAIN EXECUTION ---

if [ -z "$1" ]; then
    echo "Usage: ./run_ocr.sh <image_filename>"
    exit 1
fi

INPUT_IMAGE="$1"
BASENAME=$(basename "$INPUT_IMAGE")
FILENAME="${BASENAME%.*}"
EXTENSION="${BASENAME##*.}"
PROCESSED_IMAGE="${FILENAME}_processed.${EXTENSION}"

echo "------------------------------------------------"
echo "Step 1: Optimizing Image (Adaptive Mode)..."

# Optimized for TrOCR (Soft Grayscale)
# -deskew: Keep this, it helps.
# -shave: Keep this, it removes border junk.
# -level 25%,85%: This is the magic. 
#      It says "Anything darker than 25% gray becomes Pure Black."
#      "Anything lighter than 85% gray becomes Pure White."
#      "Everything in between stays GRAY." (Preserving the smooth edges).

magick "$INPUT_IMAGE" \
    -colorspace gray \
    -deskew 40% \
    -shave 20x20 \
    -level 25%,85% \
    "$PROCESSED_IMAGE"

echo "Saved optimized image to: $PROCESSED_IMAGE"

echo "------------------------------------------------"
echo "Step 2: Transcribing..."
htrflow pipeline pipeline.yaml "$PROCESSED_IMAGE"

echo "------------------------------------------------"
echo "Done! Check the 'outputs' folder."