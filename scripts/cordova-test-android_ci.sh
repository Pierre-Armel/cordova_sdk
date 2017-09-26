#!/usr/bin/env bash

# Get the current directory (/scripts/ directory)
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Traverse up to get to the root directory
ROOT_DIR="$(dirname "$SCRIPTS_DIR")"
EXAMPLE_DIR=example_ci
SDK_PLUGIN_NAME=com.adjust.sdk
TESTING_PLUGIN_NAME=com.adjust.sdktesting
SDK_PLUGIN_DIR=plugin
TESTING_PLUGIN_DIR=cordova-plugin-adjust-testing

RED='\033[0;31m' 	# Red color
GREEN='\033[0;32m' 	# Green color
NC='\033[0m' 		# No Color

#echo -e "${GREEN}>>> Updating git submodules ${NC}"
#cd ${ROOT_DIR}
#git submodule update --init --recursive

echo -e "${GREEN}>>> Running Android build script ${NC}"
cd ${ROOT_DIR}
ext/Android/build.sh; \mv -v ext/Android/adjust-android.jar ${SDK_PLUGIN_DIR}/src/Android/adjust-android.jar
ext/Android/build_test_ci.sh; \mv -v ext/Android/adjust-testing.jar ${TESTING_PLUGIN_DIR}/src/Android/adjust-testing.jar

echo -e "${GREEN}>>> Installing Android platform ${NC}"
cd ${ROOT_DIR}/${EXAMPLE_DIR}
cordova platform add android

echo -e "${GREEN}>>> Re-installing plugins ${NC}"
cordova plugin remove ${SDK_PLUGIN_NAME}
cordova plugin remove ${TESTING_PLUGIN_NAME}

cordova plugin add ${ROOT_DIR}/${SDK_PLUGIN_DIR}
cordova plugin add ${ROOT_DIR}/${TESTING_PLUGIN_DIR}
cordova plugin add cordova-plugin-console
cordova plugin add cordova-plugin-customurlscheme --variable URL_SCHEME=adjustExample
cordova plugin add cordova-plugin-dialogs
cordova plugin add cordova-plugin-whitelist
cordova plugin add https://github.com/apache/cordova-plugin-device.git
cordova plugin add cordova-universal-links-plugin

echo -e "${GREEN}>>> Running Cordova build Android ${NC}"
cordova run android
