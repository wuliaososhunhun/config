#!/bin/sh


for i in `seq 1 200`; do
    echo run $i;
    sbt dzm "test-only XXX";
    rc=$?;
    if [[ $rc != 0 ]];
    then
        break;
    fi
done   
