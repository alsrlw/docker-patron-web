#!/bin/sh

set -x

# add some packages
apk add --no-cache bash
apk add --no-cache su-exec

# compile
cp /build/entrypoint.sh /patron-web/entrypoint.sh
cd /patron-web
rm -R /build
npm install --only=production

