#!/bin/bash

echo Keyword: \#${1:-${keyword}}
python ./twitter_local.py $consumer_key $consumer_secret $access_token $access_token_secret $bucket ${1:-${keyword}}
