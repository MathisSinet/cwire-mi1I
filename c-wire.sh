#!/bin/bash

# Vérification de la présence de l'option -h

for arg in $@
do
    if [ $arg = '-h' ]
    then
        ./help.sh
        exit
    fi
done

