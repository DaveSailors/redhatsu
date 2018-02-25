#!/bin/bash

declare -A MYMAP     # Create an associative array

MYMAP[foo]=bar       # Put a value into an associative array

echo
echo ${MYMAP[foo]}   # Get a value out of an associative array

unset MYMAP          # You need to unset and re-declare to get a cleared associative array

declare -A MYMAP=( [foo a]=bar [baz b]=quux )

echo
echo "${!MYMAP[@]}"  # Print all keys - quoted, but quotes removed by echo

echo
# Looping through keys and values in an associative array
for K in "${!MYMAP[@]}"; do echo $K --- ${MYMAP[$K]}; done

echo
echo
echo
