// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fpa_proxy_service_observer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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

ProxyEvent _$ProxyEventFromJson(Map<String, dynamic> json) => ProxyEvent(
      event: $enumDecode(_$FpaProxyEventEnumMap, json['event']),
      connectionInfo: FpaProxyConnectionInfo.fromJson(
          json['connection_info'] as Map<String, dynamic>),
      errorCode: json['err'] as int,
    );

Map<String, dynamic> _$ProxyEventToJson(ProxyEvent instance) =>
    <String, dynamic>{
      'event': _$FpaProxyEventEnumMap[instance.event],
      'connection_info': instance.connectionInfo,
      'err': instance.errorCode,
    };

const _$FpaProxyEventEnumMap = {
  FpaProxyEvent.connected: 0,
  FpaProxyEvent.connectionFailedAndTryFallback: 1,
  FpaProxyEvent.connectionFailedAndNoFallback: 2,
};
