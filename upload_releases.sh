#! /bin/bash

echo "Uploading releases"
find *.tgz | xargs -n 1 bosh upload release
