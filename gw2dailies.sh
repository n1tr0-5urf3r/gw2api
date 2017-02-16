#!/bin/bash

# Check requirements
if ! type "jq" > /dev/null; then
	echo "jq not found!"
	exit 1
fi

# Environment
DIR=/opt/gw2api
TMPPVE=$DIR/pve.tmp
TMPPVP=$DIR/pvp.tmp
TMPWVW=$DIR/wvw.tmp
TMPID=$DIR/ids.tmp
TMPINFO=$DIR/info.tmp

# Get Daily IDs
curl -s https://api.guildwars2.com/v2/achievements/daily | jq .pve > $TMPPVE
curl -s https://api.guildwars2.com/v2/achievements/daily | jq .pvp > $TMPPVP
curl -s https://api.guildwars2.com/v2/achievements/daily | jq .wvw > $TMPWVW

getID(){
cat $1 | grep id | egrep -o "[0-9]{1,4}" | sed 's/ /\n/g' > $TMPID
sort -u -o $TMPID $TMPID
}

getInfo(){
cat $TMPID | while read id; do
	curl -s "https://api.guildwars2.com/v2/achievements?ids=$id&lang=de" > $TMPINFO
	name=$(grep "name" $TMPINFO | sed 's/^.*"name": "//g' | sed 's/",//g')
	descr=$(grep "description" $TMPINFO | sed 's/^.*"description": "//g' | sed 's/",//g')
	req=$(grep "requirement" $TMPINFO | sed 's/^.*"requirement": "//g' | sed 's/",//g')
	icon=$(grep "icon" $TMPINFO | sed 's/^.*"icon": "//g' | sed 's/",//g')

	if [ -z "$icon" ]
	then
		icon=https://wiki.guildwars2.com/images/1/14/Daily_Achievement.png
	fi	
	
	# Ausgabe
	echo "<img src=\"$icon\" alt=\"icon\" align=left>"
	echo "<p>$name<br>"
	if [ -n "$descr" ]
	then
		echo "$descr<br>"
	else
		echo "-<br>"
	fi
	echo "$req<br></p>"
	echo -e "\n"
#	echo "<p>------------------------------------</p>"
done
}

# Here happens the magic
cp $DIR/html_template.html /var/www/html/gw2/dailies.html
echo "<div id="pve"><h1>PvE:</h1>"
getID $TMPPVE
getInfo
echo "</div>"
echo "<div id="pvp"><h1>PvP:</h1>"
getID $TMPPVP
getInfo
echo "</div>"
echo "<div id="wvw"><h1>WvW:</h1>"
getID $TMPWVW
getInfo
echo "</div>"

# Clean up temporary files
rm -f $DIR/*.tmp
