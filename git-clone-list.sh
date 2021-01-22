#!/bin/sh

readarray array <<< $( cat "$1" )

for element in ${array[@]}
do
  echo "cloning $element"
  git clone https://$2@github.com/gravityforms/$element
done

