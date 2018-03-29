#!/bin/sh

url=$1

if [ "$url" = ""  ]; then
  echo "wrk.sh url [-p] [-j] [-h] [connections]"
  exit 1
fi

accept="'Accept: text/plain,text/html;q=0.9,application/xhtml+xml;q=0.9,application/xml;q=0.8,*/*;q=0.7'"
pipeline=

if [ "$2" = "-p" ]; then
  pipeline="-s `dirname $0`/pipeline.lua -- 16"
  connections=$3
elif [ "$2" = "-j" ]; then
  accept="'Accept: application/json,text/html;q=0.9,application/xhtml+xml;q=0.9,application/xml;q=0.8,*/*;q=0.7'"
  connections=$3
elif [ "$2" = "-h" ]; then
  accept="'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'"
  connections=$3
else
  connections=$2
fi

if [ "$connections" = "" ]; then
  connections=256
fi

# echo on
set -x

wrk \
  -H 'Host: localhost' \
  -H $accept \
  -H 'Connection: keep-alive' \
  --latency \
  -d 15 \
  -c $connections \
  --timeout 8 \
  -t 32 \
  $url \
  $pipeline
