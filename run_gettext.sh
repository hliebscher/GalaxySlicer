#!/bin/sh

#  GalaxySlicer gettext
#  Created by SoftFever on 27/5/23.
#

# Check for --full argument
FULL_MODE=false
for arg in "$@"
do
    if [ "$arg" == "--full" ]; then
        FULL_MODE=true
    fi
done

if $FULL_MODE; then
    xgettext --keyword=L --keyword=_L --keyword=_u8L --keyword=L_CONTEXT:1,2c --keyword=_L_PLURAL:1,2 --add-comments=TRN --from-code=UTF-8 --no-location --debug --boost -f ./localization/i18n/list.txt -o ./localization/i18n/GalaxySlicer.pot
    ./build_arm64/src/hints/Release/hintsToPot.app/Contents/MacOS/hintsToPot ./resources ./localization/i18n
fi


echo $PWD
pot_file="./localization/i18n/GalaxySlicer.pot"
for dir in ./localization/i18n/*/
do
    dir=${dir%*/}      # remove the trailing "/"
    lang=${dir##*/}    # extract the language identifier

    if [ -f "$dir/GalaxySlicer_${lang}.po" ]; then
        if $FULL_MODE; then
            msgmerge -N -o $dir/GalaxySlicer_${lang}.po $dir/GalaxySlicer_${lang}.po $pot_file
         fi
        mkdir -p ./resources/i18n/${lang}/
        msgfmt --check-format -o ./resources/i18n/${lang}/GalaxySlicer.mo $dir/GalaxySlicer_${lang}.po
    fi
done
