// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fpa_proxy_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FpaChainInfo _$FpaChainInfoFromJson(Map<String, dynamic> json) => FpaChainInfo(
      address: json['address'] as String,
      port: json['port'] as int? ?? 0,
      chainId: json['chain_id'] as int? ?? 0,
      enableFallback: json['enable_fallback'] as bool? ?? true,
    );

Map<String, dynamic> _$FpaChainInfoToJson(FpaChainInfo instance) =>
    <String, dynamic>{
      'address': instance.address,
      'port': instance.port,
      'chain_id': instance.chainId,
      'enable_fallback': instance.enableFallback,
    };

FpaHttpProxyChainConfig _$FpaHttpProxyChainConfigFromJson(
        Map<String, dynamic> json) =>
    FpaHttpProxyChainConfig(
      chainArray: (json['chain_array'] as List<dynamic>?)
          ?.map((e) => FpaChainInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      chainArraySize: json['chain_array_size'] as int? ?? 0,
      fallbackWhenNoChainAvailable:
          json['fallback_when_no_chain_available'] as bool? ?? true,
    );

Map<String, dynamic> _$FpaHttpProxyChainConfigToJson(
        FpaHttpProxyChainConfig instance) =>
    <String, dynamic>{
      'chain_array': instance.chainArray,
      'chain_array_size': instance.chainArraySize,
      'fallback_when_no_chain_available': instance.fallbackWhenNoChainAvailable,
    };

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

FpaProxyServiceDiagnosisInfo _$FpaProxyServiceDiagnosisInfoFromJson(
        Map<String, dynamic> json) =>
    FpaProxyServiceDiagnosisInfo(
      installId: json['install_id'] as String,
      instanceId: json['instance_id'] as String,
    );

Map<String, dynamic> _$FpaProxyServiceDiagnosisInfoToJson(
        FpaProxyServiceDiagnosisInfo instance) =>
    <String, dynamic>{
      'install_id': instance.installId,
      'instance_id': instance.instanceId,
    };

FpaProxyConnectionInfo _$FpaProxyConnectionInfoFromJson(
        Map<String, dynamic> json) =>
    FpaProxyConnectionInfo(
      dstIpOrDomain: json['dst_ip_or_domain'] as String,
      connectionId: json['connection_id'] as String,
      proxyType: json['proxy_type'] as String,
      dstPort: json['dst_port'] as int? ?? 0,
      localPort: json['local_port'] as int? ?? 0,
    );

Map<String, dynamic> _$FpaProxyConnectionInfoToJson(
        FpaProxyConnectionInfo instance) =>
    <String, dynamic>{
      'dst_ip_or_domain': instance.dstIpOrDomain,
      'connection_id': instance.connectionId,
      'proxy_type': instance.proxyType,
      'dst_port': instance.dstPort,
      'local_port': instance.localPort,
    };

const _$FpaProxyServiceReasonCodeEnumMap = {
  FpaProxyServiceReasonCode.fpaFailedReasonDnsQuery: -101,
  FpaProxyServiceReasonCode.fpaFailedReasonSocketCreate: -102,
  FpaProxyServiceReasonCode.fpaFailedReasonSocketConnect: -103,
  FpaProxyServiceReasonCode.fpaFailedReasonConnectTimeout: -104,
  FpaProxyServiceReasonCode.fpaFailedReasonNoChainIdMatch: -105,
  FpaProxyServiceReasonCode.fpaFailedReasonDataRead: -106,
  FpaProxyServiceReasonCode.fpaFailedReasonDataWrite: -107,
  FpaProxyServiceReasonCode.fpaFailedReasonTooFrequently: -108,
  FpaProxyServiceReasonCode.fpaFailedReasonTooManyConnections: -109,
};
