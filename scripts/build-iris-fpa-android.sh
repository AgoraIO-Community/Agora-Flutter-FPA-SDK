#!/usr/bin/env bash

set -e

ROOT_PATH=$(pwd)
IRIS_PROJECT_PATH=$1

BUILD_TYPE="Debug"
ABIS="arm64-v8a armeabi-v7a x86_64"
SO_NAME="libAgoraFpaWrapper.so"
LIBS_PATH="${ROOT_PATH}/example/android/app/libs"

bash $IRIS_PROJECT_PATH/fpa/ci/build-android.sh

if [ ! -d 'third_party' ];then
    mkdir -p third_party
    mkdir -p third_party/include
fi

if [[ ! -d $LIBS_PATH ]];then
    mkdir -p $LIBS_PATH
fi

echo "Copying $IRIS_PROJECT_PATH/build/android/arm64-v8a/output/fpa/include/ to $ROOT_PATH/third_party/include/"
cp -r "$IRIS_PROJECT_PATH/build/android/arm64-v8a/output/fpa/include/" "$ROOT_PATH/third_party/include/"

cp -r "$IRIS_PROJECT_PATH/third_party/agora/fpa/libs/so_jar/AgoraFpaService.jar" "$LIBS_PATH" 

for ABI in ${ABIS};
do
    echo "Copying $IRIS_PROJECT_PATH/build/android/$ABI/output/fpa/$BUILD_TYPE/$SO_NAME to $LIBS_PATH/$ABI/$SO_NAME"
    mkdir -p "$LIBS_PATH/$ABI/" && \
    cp -r "$IRIS_PROJECT_PATH/build/android/$ABI/output/fpa/$BUILD_TYPE/$SO_NAME" \
          "$LIBS_PATH/$ABI/$SO_NAME" 

    cp -r "$IRIS_PROJECT_PATH/third_party/agora/fpa/libs/so_jar/$ABI/libagora_fpa_sdk.so" \
          "$LIBS_PATH/$ABI/libagora_fpa_sdk.so" 

    cp -r "$IRIS_PROJECT_PATH/third_party/agora/fpa/libs/so_jar/$ABI/libagora_fpa_service.so" \
          "$LIBS_PATH/$ABI/libagora_fpa_service.so" 
done;







