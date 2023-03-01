#!/bin/bash

while read line
do
  read -a myvar <<< $line
  for var in "${myvar[@]:1}"
    do echo "$var"
  done
done