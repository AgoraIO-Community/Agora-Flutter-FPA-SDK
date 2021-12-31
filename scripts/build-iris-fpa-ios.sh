#!/usr/bin/env bash

set -e

ROOT_PATH=$(pwd)
IRIS_PROJECT_PATH=../../../iris

BUILD_TYPE="Release"
ARCHI_TYPE="OS64COMBINED"

bash $IRIS_PROJECT_PATH/fpa/ci/build-ios-flutter.sh

cp -r "$IRIS_PROJECT_PATH/third_party/agora/fpa/libs/libs/ALL_ARCHITECTURE/AgoraFPA.framework" "$ROOT_PATH/ios/"
cp -r "$IRIS_PROJECT_PATH/third_party/agora/fpa/libs/libs/ALL_ARCHITECTURE/AgoraFpaProxyService.framework" "$ROOT_PATH/ios/"

echo "Generating framework"
lipo -create "$IRIS_PROJECT_PATH/build/ios/OS64COMBINED/output/fpa/$BUILD_TYPE/AgoraFpaWrapper.framework/AgoraFpaWrapper" "$IRIS_PROJECT_PATH/build/ios/SIMULATOR64/output/fpa/$BUILD_TYPE/AgoraFpaWrapper.framework/AgoraFpaWrapper" -output "$ROOT_PATH/ios/AgoraFpaWrapper.framework/AgoraFpaWrapper"


