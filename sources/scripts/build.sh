#!/bin/bash
set -e

glyphsSource="ElMessiri"
outputDir="fonts/vf"
familyName="ElMessiri"

echo "[INFO] Starting build script for $familyName font family"

if [ -d .git ]; then
  echo "[TEST] Running from a Git root directory, looks good"
else
  echo "[WARN] Font family Git root not found, please run from the root directory"
  echo "[WARN] Build process cancelled"
  exit 1
fi

echo "[INFO] Making 'fonts/vf' directory if it doesn't already exist"
mkdir -p -v fonts/vf

for i in $glyphsSource; do
  echo "[TEST] Queued source file: $i.glyphs"
done

for i in $glyphsSource; do
  echo "[INFO] Building $i.glyphs with Fontmake, this might take some time..."
  fontmake -g sources/$i.glyphs -o variable \
    --output-path $outputDir/$i-VF.ttf \
    --verbose ERROR
done

echo "[INFO] Removing build directories"
rm -rf instance_ufo master_ufo

echo "[INFO] Fixing DSIG table"
if gftools fix-dsig -f fonts/vf/$familyName-VF.ttf ; then
  echo "[INFO] DSIG fixed"
else
  echo "[ERROR] GFtools is not working, please update or install: https://github.com/googlefonts/gftools"
fi

echo "[INFO] Autohinting with ttfautohint"
if ttfautohint fonts/vf/$familyName-VF.ttf fonts/vf/$familyName-VF-FIX.ttf ; then
  echo "[INFO] Autohinting completed"
  echo "[INFO] Replacing unhinted fonts with hinted fonts"
  mv fonts/vf/$familyName-VF-FIX.ttf fonts/vf/$familyName-VF.ttf 
  echo "[INFO] Fixing hinting with GFtools"
  gftools fix-hinting fonts/vf/$familyName-VF.ttf
  mv fonts/vf/$familyName-VF.ttf.fix fonts/vf/$familyName-VF.ttf
else
  echo "[ERROR] ttfautohint is not working, please update or install: https://www.freetype.org/ttfautohint/"
fi

echo "[INFO] Done building $familyName font family"
