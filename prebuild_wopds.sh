#!/bin/sh

set -x

# get the source
git clone $1 --branch $2 --single-branch /patron-web
git clone $3 --branch $4 --single-branch /opds-web

# compile
cd /opds-web/packages/opds-web-client
npm install
npm run prepublish
cd /patron-web
# Use sed to remove the existing opds-web-client dependency line in package.json
#sed -i '/opds-web-client/d' /patron-web/package.json
# Use sed to set a local path for the opds-web-client dependency line in package.json
sed -i 's/"opds-web-client.*/"opds-web-client": "file:\.\.\/opds-web\/packages\/opds-web-client",/' /patron-web/package.json
npm install
npm run build-prod
