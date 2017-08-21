#!/bin/sh

url=$1

if [ "$url" = ""  ]; then
  echo "wrk.sh url [-p] [connections]"
  exit 1
fi

if [ "$2" = "-p" ]; then
  pipeline="-s `dirname $0`/pipeline.lua -- 16"
  connections=$3
else
  pipeline=
  connections=$2
fi

if [ "$connections" = "" ]; then
  connections=256
fi

# echo on
set -x

wrk \
  -H 'Host: localhost' \
  -H 'Accept: text/plain,text/html;q=0.9,application/xhtml+xml;q=0.9,application/xml;q=0.8,*/*;q=0.7' \
  -H 'Connection: keep-alive' \
  --latency \
  -d 15 \
  -c $connections \
  --timeout 8 \
  -t 32 \
  $url \
  $pipeline
