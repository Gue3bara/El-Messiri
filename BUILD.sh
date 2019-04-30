#!/bin/sh

# -----------------------------------------------------------------------------
# VARIABLES -------------------------------------------------------------------

thisFont="ElMessiri"    # The name of the font family

# -----------------------------------------------------------------------------
# BASH SCRIPT -----------------------------------------------------------------

set -o xtrace
echo "[+] Starting build script"
source ~/Py/Venvs/type/bin/activate
set -e

cd sources

#echo "[+] Generating static fonts"
#mkdir -p ../fonts/static
#fontmake -g $thisFont.glyphs -i -o ttf --output-dir ../fonts/static/

echo "[+] Generating variable fonts"
mkdir -p ../fonts/variable
fontmake -g $thisFont.glyphs -o variable \
    --output-path ../fonts/variable/$thisFont-Roman-VF.ttf

rm -rf master_ufo/ instance_ufo/

echo "[+] Post processing"

#echo "[+] Post processing static fonts"
#ttfs=$(ls ../fonts/static/*.ttf)
#echo $ttfs
#for ttf in $ttfs
#do
#    gftools fix-dsig -f $ttf;
#    gftools fix-nonhinting $ttf "$ttf.fix";
#    mv "$ttf.fix" $ttf;
#done
#rm ../fonts/ttfs/*backup*.ttf

echo "[+] Post processing variable fonts fonts"
vfs=$(ls ../fonts/variable/*.ttf)
for vf in $vfs
do
    gftools fix-dsig -f $vf;
    gftools fix-nonhinting $vf "$vf.fix";
    mv "$vf.fix" $vf;
    ttx -f -x "MVAR" $vf; # Drop MVAR. Table has issue in DW
    rtrip=$(basename -s .ttf $vf)
    new_file=../fonts/variable/$rtrip.ttx;
    rm $vf;
    ttx $new_file
    rm ../fonts/variable/*.ttx
    cp $vf ~/Google/fonts/ofl/elmessiri/
done
rm ../fonts/variable/*backup*.ttf

#gftools fix-vf-meta $vfs;
#for vf in $vfs
#do
#    mv "$vf.fix" $vf;
#done

cd ..

# -----------------------------------------------------------------------------
# Autohinting -----------------------------------------------------------------

#statics=$(ls fonts/ttfs/*.ttf)
#echo hello
#for file in $statics; do 
#    echo "fix DSIG in " ${file}
#    gftools fix-dsig --autofix ${file}
#
#    echo "TTFautohint " ${file}
#    # autohint with detailed info
#    hintedFile=${file/".ttf"/"-hinted.ttf"}
#    ttfautohint -I ${file} ${hintedFile} 
#    cp ${hintedFile} ${file}
#    rm -rf ${hintedFile}
#done


# ============================================================================
# Build woff2 fonts ==========================================================

# requires https://github.com/bramstein/homebrew-webfonttools

#rm -rf fonts/woff2
#
#ttfs=$(ls fonts/*/*.ttf)
#for ttf in $ttfs; do
#    woff2_compress $ttf
#done
#
#mkdir -p fonts/woff2
#woff2s=$(ls fonts/*/*.woff2)
#for woff2 in $woff2s; do
#    mv $woff2 fonts/woff2/$(basename $woff2)
#done
# ============================================================================
# Build woff fonts ==========================================================

# requires https://github.com/bramstein/homebrew-webfonttools

#rm -rf fonts/woff
#
#ttfs=$(ls fonts/*/*.ttf)
#for ttf in $ttfs; do
#    sfnt2woff-zopfli $ttf
#done
#
#mkdir -p fonts/woff
#woffs=$(ls fonts/*/*.woff)
#for woff in $woffs; do
#    mv $woff fonts/woff/$(basename $woff)
#done
