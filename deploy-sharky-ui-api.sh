#!/bin/bash

VERSION="00001"

helm upgrade \
  --install \
  sharky-ui-api \
  sharky-ui-api \
  --namespace sharky-ui-api \
  --set dockerImage.tag="${VERSION}"

exit 0
