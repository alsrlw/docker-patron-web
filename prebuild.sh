#!/bin/sh

set -x

# get the source
git clone https://github.com/NYPL-Simplified/circulation-patron-web.git /patron-web

# compile
cd /patron-web
npm install
npm run prepublish

