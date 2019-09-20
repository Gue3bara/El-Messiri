#!/bin/bash
set -e

prDir="~/Google/fonts/ofl/"
familyName="ElMessiri"

echo "[INFO] Preparing a new $familyName pull request at $prDir"

cp fonts/vf/$familyName-VF.ttf ~/Google/fonts/ofl/elmessiri/$familyName[wght].ttf

echo "[INFO] Done preparing $familyName pull request at $prDir"
