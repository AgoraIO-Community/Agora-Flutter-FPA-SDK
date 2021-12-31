import 'package:json_annotation/json_annotation.dart';

part 'fpa_proxy_service_config.g.dart';

@JsonSerializable()
class FpaProxyServiceConfig {
  FpaProxyServiceConfig({
    required this.appId,
    required this.token,
    this.logLevel = FpaProxyServiceLogLevel.none,
    this.logFileSizeKb = 0,
    this.logFilePath = '',
  });
  @JsonKey(name: 'app_id')
  final String appId;

  @JsonKey(name: 'token')
  final String token;

  @JsonKey(name: 'log_level')
  final FpaProxyServiceLogLevel logLevel;

  @JsonKey(name: 'log_file_size_kb')
  final int logFileSizeKb;

  @JsonKey(name: 'log_file_path')
  final String logFilePath;

  factory FpaProxyServiceConfig.fromJson(Map<String, dynamic> json) =>
      _$FpaProxyServiceConfigFromJson(json);

  Map<String, dynamic> toJson() => _$FpaProxyServiceConfigToJson(this);
}

/// The log level
/// - 0 indication no log output
/// - 1 information level
/// - 2 warning level
/// - 4 error level
/// - 8 fatal level
@JsonEnum()
enum FpaProxyServiceLogLevel {
  @JsonValue(0)
  none,

  @JsonValue(1)
  info,

  @JsonValue(2)
  warn,

  @JsonValue(4)
  error,

  @JsonValue(8)
  fatal,
}
