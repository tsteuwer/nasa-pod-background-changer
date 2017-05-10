#! /bin/bash
LRG_DATE=`date +%y%m%d`
TINY_DATE=`date +%y%m`
REMOTE_URL="https://apod.nasa.gov/apod/ap$LRG_DATE.html"
TMP_FILE_PREFIX="nasapotdapp"
FILE_NAME="$TMP_FILE_PREFIX.html"
FILE_PATH="/tmp/$FILE_NAME"
JPG_FILE_PATH_TMP="/tmp/$TMP_FILE_PREFIX.jpg"

# Find out whether we need weget or curl
if [[ ! -n $( command -v wget ) ]]
then
	curl -O $FILE_PATH $REMOTE_URL
else
	wget -O $FILE_PATH $REMOTE_URL
fi

GREP_FOR="\<a href=\"image/"$TINY_DATE
CONTENTS=$(grep "$GREP_FOR" $FILE_PATH)

REPLACE_WITH=""
LARGE_FILE_NAME="${CONTENTS/<a href=\"/$REPLACE_WITH}"
NEW_FILE_NAME="${LARGE_FILE_NAME/\">/$REPLACE_WITH}"
echo $NEW_FILE_NAME

if [[ ! -n $( command -v wget ) ]]
then
	curl -O $JPG_FILE_PATH_TMP "https://apod.nasa.gov/apod/$NEW_FILE_NAME"
else
	wget -O $JPG_FILE_PATH_TMP "https://apod.nasa.gov/apod/$NEW_FILE_NAME"
fi

gsettings set org.gnome.desktop.background picture-uri "file:///$JPG_FILE_PATH_TMP"

rm $FILE_PATH
