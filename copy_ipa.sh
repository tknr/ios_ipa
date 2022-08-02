#!/bin/bash
export IFS=$'\n'

rm -f public/*.*

BUNDLE_ID_PREFIX="com.example."
PKEY=~/.config/zsign/sample.p12
PROB=~/.config/zsign/sample.mobileprovision
source ~/.config/zsign/config

IPA_LIST=''
for SRC_IPA in `find ipa -iname "*.ipa"` ;do
BASENAME_IPA=`basename ${SRC_IPA}`
DST_IPA="public/${SRC_IPA#ipa/}"
echo "${SRC_IPA} => ${DST_IPA}"
NEW_BUNDLE_NAME=`basename ${SRC_IPA} .ipa | awk 'BEGIN{FS=" v"}{print $1}' | tr -d " ()_.0-9"`
echo "${NEW_BUNDLE_NAME}"
BUNDLE_ID="${BUNDLE_ID_PREFIX}${NEW_BUNDLE_NAME}"
echo "${BUNDLE_ID}"

zsign -k ${PKEY} -m ${PROB} -n "${NEW_BUNDLE_NAME}" -b "${BUNDLE_ID}" -o ${DST_IPA} ${SRC_IPA}	
IPA_LIST+="<li><a href='${BASENAME_IPA}'>${BASENAME_IPA}</li>\n";
done

cat src/index.html | sed -e "s|#IPA_LIST#|${IPA_LIST}|g" > public/index.html 
