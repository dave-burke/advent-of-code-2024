#!/bin/bash

if [[ $# == 0 ]]; then
	echo "Usage: get_puzzle_html.sh [day]"
	exit 1
fi
if [[ $# == 1 ]]; then
	year="$(date +%Y)"
	day="${1}"
fi
if [[ $# == 2 ]]; then
	year="${1}"
	day="${2}"
fi

url="https://adventofcode.com/${year}/day/${day}"
echo "${url}"

dir="$(dirname $(realpath $0))/html"
mkdir -pv "${dir}"
cd "${dir}"
wget --page-requisites --adjust-extension --span-hosts --convert-links --backup-converted "${url}"

