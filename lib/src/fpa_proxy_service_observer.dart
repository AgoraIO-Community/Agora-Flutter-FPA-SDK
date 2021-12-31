import 'package:json_annotation/json_annotation.dart';

part 'fpa_proxy_service_observer.g.dart';

@JsonEnum(alwaysCreate: true)
enum FpaProxyEvent {
  @JsonValue(0)
  connected,

  @JsonValue(1)
  connectionFailedAndTryFallback,

  @JsonValue(2)
  connectionFailedAndNoFallback,
}

@JsonSerializable()
class FpaProxyConnectionInfo {
  FpaProxyConnectionInfo({
    required this.dstIpOrDomain,
    required this.connectionId,
    required this.proxyType,
    this.dstPort = 0,
    this.localPort = 0,
  });

  @JsonKey(name: 'dst_ip_or_domain')
  final String dstIpOrDomain;

  @JsonKey(name: 'connection_id')
  final String connectionId;

  @JsonKey(name: 'proxy_type')
  final String proxyType;

  @JsonKey(name: 'dst_port')
  final int dstPort;

  @JsonKey(name: 'local_port')
  final int localPort;

  factory FpaProxyConnectionInfo.fromJson(Map<String, dynamic> json) =>
      _$FpaProxyConnectionInfoFromJson(json);

  Map<String, dynamic> toJson() => _$FpaProxyConnectionInfoToJson(this);
}

/// @nodoc
/// Internal used
@JsonSerializable()
class ProxyEvent {
  ProxyEvent({
    required this.event,
    required this.connectionInfo,
    required this.errorCode,
  });

  @JsonKey(name: 'event')
  final FpaProxyEvent event;

  @JsonKey(name: 'connection_info')
  final FpaProxyConnectionInfo connectionInfo;

  @JsonKey(name: 'err')
  final int errorCode;

  factory ProxyEvent.fromJson(Map<String, dynamic> json) =>
      _$ProxyEventFromJson(json);

  Map<String, dynamic> toJson() => _$ProxyEventToJson(this);
}

abstract class FpaProxyServiceObserver {
  void onProxyEvent(FpaProxyEvent event, FpaProxyConnectionInfo connectionInfo,
      int errorCode);
}
