#!/bin/bash

# Create parent output directory
mkdir -p ./pngs

# Directory where SVG files are located
SVG_DIR="./svg"

# List of PNG sizes to generate (1024 is for initial generation, others are derived)
# 1024 will be used as the source image, and others will be saved in subdirectories
INITIAL_SIZE=1024
DERIVED_SIZES=(512 256 128 64 32 16)

echo "---"
echo "Starting PNG size conversion..."
echo "---"

# Process all SVG files in the SVG directory
for svg_file in "$SVG_DIR"/*.svg; do
  # Skip if the file does not exist (e.g., no SVG files in the directory)
  [ -f "$svg_file" ] || continue

  # Get the base name (without extension)
  filename=$(basename -- "$svg_file")
  filename_no_ext="${filename%.*}"
  initial_png_path="./pngs/${filename_no_ext}.png"

  # Create a subdirectory for each file and save derived sizes there
  CURRENT_OUTPUT_SUBDIR="./pngs/${filename_no_ext}"
  mkdir -p "$CURRENT_OUTPUT_SUBDIR"

  echo "  Deriving smaller sizes into $CURRENT_OUTPUT_SUBDIR/"

  # Generate each size from the initially created PNG
  for size in "${DERIVED_SIZES[@]}"; do
    output_filename="${size}x${size}.png" # e.g., 128x128.png
    output_path="${CURRENT_OUTPUT_SUBDIR}/${output_filename}"

    echo "    Generating ${output_path} (size: ${size}x${size})"

    # Resize the existing 1024x1024 PNG to create derived PNGs
    convert "$initial_png_path" -resize "${size}x${size}" "$output_path"
    if [ $? -ne 0 ]; then
      echo "    Error: Failed to resize ${initial_png_path} to ${output_path}"
    fi
  done
  echo "---" # Blank line for separation
done

echo "Smaller sizes are saved in ./pngs/<original_filename>/ directories."