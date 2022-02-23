#!/usr/bin/env bash

for pic in ./**/*.HEIC; do
	if (file "$pic" | grep -q "JPEG"); then
		echo "$pic is actually a jpeg"
		mv -- "$pic" "${pic%.HEIC}.jpg"
	fi
done
