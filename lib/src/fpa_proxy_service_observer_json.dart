import 'package:json_annotation/json_annotation.dart';
import 'fpa_proxy_service.dart';

part 'fpa_proxy_service_observer_json.g.dart';

@JsonSerializable()
class FpaProxyConnectionInfoJson {
  FpaProxyConnectionInfoJson({required this.info});

  @JsonKey(name: 'info')
  final FpaProxyConnectionInfo info;

  factory FpaProxyConnectionInfoJson.fromJson(Map<String, dynamic> json) =>
      _$FpaProxyConnectionInfoJsonFromJson(json);

  Map<String, dynamic> toJson() => _$FpaProxyConnectionInfoJsonToJson(this);
}

@JsonSerializable()
class DisconnectedAndFallbackJson {
  DisconnectedAndFallbackJson({required this.info, required this.reason});

  @JsonKey(name: 'info')
  final FpaProxyConnectionInfo info;

  @JsonKey(name: 'reason')
  final FpaProxyServiceReasonCode reason;

  factory DisconnectedAndFallbackJson.fromJson(Map<String, dynamic> json) =>
      _$DisconnectedAndFallbackJsonFromJson(json);

  Map<String, dynamic> toJson() => _$DisconnectedAndFallbackJsonToJson(this);
}

@JsonSerializable()
class ConnectionFailedJson {
  ConnectionFailedJson({required this.info, required this.reason});

  @JsonKey(name: 'info')
  final FpaProxyConnectionInfo info;

  @JsonKey(name: 'reason')
  final FpaProxyServiceReasonCode reason;

  factory ConnectionFailedJson.fromJson(Map<String, dynamic> json) =>
      _$ConnectionFailedJsonFromJson(json);

  Map<String, dynamic> toJson() => _$ConnectionFailedJsonToJson(this);
}
