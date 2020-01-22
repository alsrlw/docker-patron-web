#!/bin/sh

set -x

# get the source
git clone $1 --branch $2 --single-branch /patron-web

# compile
cd /patron-web
npm install
npm run build-prod

