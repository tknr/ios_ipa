#!/bin/bash
export IFS=$'\n'

IPA_LIST=''
for SRC_IPA in `find ipa -iname "*.ipa"`
do
	echo ${SRC_IPA}
	NEW_BUNDLE_NAME=`basename ${SRC_IPA} | cut -d "." -f 1 | cut -d "_" -f 1`
	DST_IPA="public/${NEW_BUNDLE_NAME}.ipa"
	BUNDLE_ID_PREFIX="com.example."
	PKEY=~/.config/zsign/sample.p12
	PROB=~/.config/zsign/sample.mobileprovision
	source ~/.config/zsign/config
	zsign -k ${PKEY} -m ${PROB} -n "${NEW_BUNDLE_NAME}" -b "${BUNDLE_ID_PREFIX}${NEW_BUNDLE_NAME}" -o ${DST_IPA} ${SRC_IPA}	
	IPA_LIST+="<li><a href='${NEW_BUNDLE_NAME}.ipa'>${NEW_BUNDLE_NAME}.ipa</li>\n";
done

cat src/index.html | sed -e "s|#IPA_LIST#|${IPA_LIST}|g" > public/index.html 
