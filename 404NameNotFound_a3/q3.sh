#!/bin/bash

#Cassandra Sterns      SID: 22209739
#Ethan Doyle           SID: 22210635
cat sample.txt | cut -d ' ' -f 1 --complement | tr ' ' '\n' 
# while read line
# do
#   read -a myvar <<< $line
#   for var in "${myvar[@]:1}"
#     do echo "$var"
#   done
# done