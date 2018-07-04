#!/usr/bin/env bash

set -f

ZM_URL=$1
PHX_URL=$2
STATIONS=$3

if [ -z "$ZM_URL" ]; then
 echo "missing ZM_URL as parameter 1"
 exit -1
fi

if [ -z "PHX_URL" ]; then
 echo "missing PHX_URL as parameter 2"
 exit -1
fi

if [ -z "STATIONS" ]; then
 echo "missing PHX_URL as parameter 3"
 exit -1
fi

echo "ZM: $ZM_URL"
echo "PHX: $PHX_URL"


count_string () {
    s=$1
    ss=(${s// / })
    echo ${#ss[@]}
}


array=(${STATIONS//,/ })
for i in "${!array[@]}"
do
    echo "==========="
    echo "Station: ${array[i]}"
    ZM_STATION_URL="$ZM_URL/debug/${array[i]}/containers"
    echo "Hit: $ZM_STATION_URL"
    curl -s $ZM_STATION_URL > /tmp/temp-containers.json
    COUNT=`jq '. | length' /tmp/temp-containers.json`
    echo "Bins In Station: $COUNT"
    SURROGATE=0
    NOZONE=""
    IMZONE=""
    OTHERZONE=""
    CTNRS=`jq '.[] | .containerLpn' /tmp/temp-containers.json`
    CARRAY=(${CTNRS// / })
    for j in "${!CARRAY[@]}"
    do
        LPN=`sed 's/\"//g' <<< ${CARRAY[j]}`
        if [[ ! $LPN =~ -.* ]]; then
            PHX_CTNR_URL="$PHX_URL/inventory/containers?containerLpn=$LPN"
            # echo $PHX_CTNR_URL
            curl -s $PHX_CTNR_URL > /tmp/temp-lpn.json
            RESULT_COUNT=`jq '. | length' /tmp/temp-lpn.json`
            if [ $RESULT_COUNT -eq 0 ]; then
                NOZONE="$NOZONE $LPN"
            else
               ZONE_ID=`jq '.[0] | .zoneId' /tmp/temp-lpn.json`
               if [[ $ZONE_ID =~ .*INVENTORY_MANAGEMENT.* ]]; then
                   IMZONE="$IMZONE $LPN"
               else
                   OTHERZONE="$OTHERZONE $LPN"
               fi
            fi
        else
            SURROGATE=$((SURROGATE + 1))
        fi
    done
    echo "Surrogate Bin Count: $SURROGATE"
    echo "Bins within IM Zone: $(count_string "$IMZONE")"
    echo $IMZONE
    echo "Bins in Other Zone: $(count_string "$OTHERZONE")"
    echo $OTHERZONE
    echo "Bins without Zone: $(count_string "$NOZONE")"
    echo $NOZONE
done

