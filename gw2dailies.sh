#!/bin/bash
# Check requirements

if ! type "jq" > /dev/null; then
	echo "jq not found!"
	exit 1
fi

DIR=/opt/gw2api

TMPPVE=$DIR/pve.tmp
TMPPVP=$DIR/pvp.tmp
TMPWVW=$DIR/wvw.tmp
TMPID=$DIR/ids.tmp
TMPINFO=$DIR/info.tmp

curl -s https://api.guildwars2.com/v2/achievements/daily | jq .pve > $TMPPVE
curl -s https://api.guildwars2.com/v2/achievements/daily | jq .pvp > $TMPPVP
curl -s https://api.guildwars2.com/v2/achievements/daily | jq .wvw > $TMPWVW

getID(){
cat $1 | grep id | egrep -o "[0-9]{1,4}" | sed 's/ /\n/g' > $TMPID
}

getInfo(){
cat $TMPID | while read id; do
	curl -s "https://api.guildwars2.com/v2/achievements?ids=$id&lang=de" > $TMPINFO
	name=$(grep "name" $TMPINFO | sed 's/"name": "//g' | sed 's/",//g')
	descr=$(grep "description" $TMPINFO | sed 's/"description": "//g' | sed 's/",//g')
	req=$(grep "requirement" $TMPINFO | sed 's/"requirement": "//g' | sed 's/",//g')
	
	# Ausgabe
	#echo "-----------------------"
	echo "$name"
	echo "$descr"
	echo "$req"
	echo -e "\n"
	echo "-----------------------"
done
}

echo "PvE:"
getID $TMPPVE
getInfo
echo "PvP:"
getID $TMPPVP
getInfo
echo "WvW:"
getID $TMPWVW
getInfo

rm -f $DIR/*.tmp
