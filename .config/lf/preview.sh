#!/bin/sh

file="$1"

if file --mime-type "$file" | grep -qE 'image/(jepg|png|gif|webp|bmp|svg+xml)';then
  chafa --fill=block --sixel "$file"
  exit 0
fi 

file "$file"
