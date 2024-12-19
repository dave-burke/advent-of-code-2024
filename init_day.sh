#!/bin/bash

if [[ $# == 0 ]]; then
	echo "Usage: init_day.sh [day]"
	exit 1
fi

day_file="day${1}.rb"
echo "Setting up ${day_file}"
cp -v template.rb "${day_file}"
sed -i "s/DAY = 0/DAY = $1/" "${day_file}"
chmod 755 "${day_file}"
./"${day_file}"
