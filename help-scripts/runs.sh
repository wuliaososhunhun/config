#!/bin/sh


for i in `seq 1 200`; do
    echo run $i;
    sbt dzm "test-only com.ocado.cfc.decant.zone.actor.station.components.StationActorOnScratchCustomerToteCompleteEvent";
    rc=$?;
    if [[ $rc != 0 ]];
    then
        break;  # Try   break 2   to see what happens.
    fi
done   
