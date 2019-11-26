#!/bin/bash

VERSION="00011"

helm upgrade --install sharky-ui sharky-ui --namespace sharky-ui --set dockerImage.tag="${VERSION}"

exit 0
