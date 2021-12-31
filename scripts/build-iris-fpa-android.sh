#!/usr/bin/env bash

set -e

ROOT_PATH=$(pwd)
IRIS_PROJECT_PATH=../../../iris

BUILD_TYPE="Debug"
ABIS="arm64-v8a armeabi-v7a x86_64"
SO_NAME="libAgoraFpaWrapper.so"

bash $IRIS_PROJECT_PATH/fpa/ci/build-android-flutter.sh

if [ ! -d 'third_party'];then
    mkdir -p third_party
    mkdir -p third_party/include
fi

echo "Copying $IRIS_PROJECT_PATH/build/android/arm64-v8a/output/fpa/include/ to $ROOT_PATH/third_party/include/"
cp -r "$IRIS_PROJECT_PATH/build/android/arm64-v8a/output/fpa/include/" "$ROOT_PATH/third_party/include/"

cp -r "$IRIS_PROJECT_PATH/third_party/agora/fpa/libs/so_jar/AgoraFpaService.jar" "$ROOT_PATH/android/libs/" 

for ABI in ${ABIS};
do
    echo "Copying $IRIS_PROJECT_PATH/build/android/$ABI/output/fpa/$BUILD_TYPE/$SO_NAME to $ROOT_PATH/android/libs/$ABI/$SO_NAME"
    mkdir -p "$ROOT_PATH/android/libs/$ABI/" && \
    cp -r "$IRIS_PROJECT_PATH/build/android/$ABI/output/fpa/$BUILD_TYPE/$SO_NAME" \
          "$ROOT_PATH/android/libs/$ABI/$SO_NAME" 

    cp -r "$IRIS_PROJECT_PATH/third_party/agora/fpa/libs/so_jar/$ABI/libagora_fpa_sdk.so" \
          "$ROOT_PATH/android/libs/$ABI/libagora_fpa_sdk.so" 

    cp -r "$IRIS_PROJECT_PATH/third_party/agora/fpa/libs/so_jar/$ABI/libagora_fpa_service.so" \
          "$ROOT_PATH/android/libs/$ABI/libagora_fpa_service.so" 
done;







