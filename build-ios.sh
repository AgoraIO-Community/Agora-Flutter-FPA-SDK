#! /usr/bin/env bash
set -e

plugin_path=$(pwd)

cd ../../../fpa_service

bash build-ios.sh

ROOT_DIR=$(pwd)
output_path="${ROOT_DIR}/sys/iOS/fpa/libs"
fpa_sdk_path="${ROOT_DIR}/prebuilds/iOS/FPA_SDK/AgoraFPA.framework"
lib="AgoraFpaService"

# TODO: Remove this part when CI supported
# Copy AgoraFPA.framework, AgoraFpaService.framework to flutter plugin
flutter_plugin_path="${plugin_path}/ios"
echo "Copying ${fpa_sdk_path} -> ${flutter_plugin_path}/AgoraFPA.framework"
cp -r "${fpa_sdk_path}" "${flutter_plugin_path}/AgoraFPA.framework"
echo "Copying ${output_path}/${lib}.framework ${flutter_plugin_path}/${lib}.framework"
cp -r "${output_path}/${lib}.framework" "${flutter_plugin_path}/${lib}.framework"

cd ${plugin_path}/example
echo "Building iOS..."
flutter build ios --no-codesign