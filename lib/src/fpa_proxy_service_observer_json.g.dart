// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fpa_proxy_service_observer_json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FpaProxyConnectionInfoJson _$FpaProxyConnectionInfoJsonFromJson(
        Map<String, dynamic> json) =>
    FpaProxyConnectionInfoJson(
      info:
          FpaProxyConnectionInfo.fromJson(json['info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FpaProxyConnectionInfoJsonToJson(
        FpaProxyConnectionInfoJson instance) =>
    <String, dynamic>{
      'info': instance.info,
    };

DisconnectedAndFallbackJson _$DisconnectedAndFallbackJsonFromJson(
        Map<String, dynamic> json) =>
    DisconnectedAndFallbackJson(
      info:
          FpaProxyConnectionInfo.fromJson(json['info'] as Map<String, dynamic>),
      reason: $enumDecode(_$FpaProxyServiceReasonCodeEnumMap, json['reason']),
    );

Map<String, dynamic> _$DisconnectedAndFallbackJsonToJson(
        DisconnectedAndFallbackJson instance) =>
    <String, dynamic>{
      'info': instance.info,
      'reason': _$FpaProxyServiceReasonCodeEnumMap[instance.reason],
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

ConnectionFailedJson _$ConnectionFailedJsonFromJson(
        Map<String, dynamic> json) =>
    ConnectionFailedJson(
      info:
          FpaProxyConnectionInfo.fromJson(json['info'] as Map<String, dynamic>),
      reason: $enumDecode(_$FpaProxyServiceReasonCodeEnumMap, json['reason']),
    );

Map<String, dynamic> _$ConnectionFailedJsonToJson(
        ConnectionFailedJson instance) =>
    <String, dynamic>{
      'info': instance.info,
      'reason': _$FpaProxyServiceReasonCodeEnumMap[instance.reason],
    };
