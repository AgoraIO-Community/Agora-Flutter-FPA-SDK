// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fpa_proxy_service_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FpaProxyServiceConfig _$FpaProxyServiceConfigFromJson(
        Map<String, dynamic> json) =>
    FpaProxyServiceConfig(
      appId: json['app_id'] as String,
      token: json['token'] as String,
      logLevel: $enumDecodeNullable(
              _$FpaProxyServiceLogLevelEnumMap, json['log_level']) ??
          FpaProxyServiceLogLevel.none,
      logFileSizeKb: json['log_file_size_kb'] as int? ?? 0,
      logFilePath: json['log_file_path'] as String? ?? '',
    );

Map<String, dynamic> _$FpaProxyServiceConfigToJson(
        FpaProxyServiceConfig instance) =>
    <String, dynamic>{
      'app_id': instance.appId,
      'token': instance.token,
      'log_level': _$FpaProxyServiceLogLevelEnumMap[instance.logLevel],
      'log_file_size_kb': instance.logFileSizeKb,
      'log_file_path': instance.logFilePath,
    };

const _$FpaProxyServiceLogLevelEnumMap = {
  FpaProxyServiceLogLevel.none: 0,
  FpaProxyServiceLogLevel.info: 1,
  FpaProxyServiceLogLevel.warn: 2,
  FpaProxyServiceLogLevel.error: 4,
  FpaProxyServiceLogLevel.fatal: 8,
};
