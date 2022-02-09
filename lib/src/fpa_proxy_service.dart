import 'package:json_annotation/json_annotation.dart';
import 'package:agora_fpa_service/src/fpa_proxy_service_impl.dart';
import 'package:flutter/material.dart';

part 'fpa_proxy_service.g.dart';

@JsonSerializable()
class FpaChainInfo {
  FpaChainInfo({
    required this.address,
    this.port = 0,
    this.chainId = 0,
    this.enableFallback = true,
  });

  /// ip or domain
  @JsonKey(name: 'address')
  final String address;

  /// port
  @JsonKey(name: 'port')
  final int port;

  /// fpa chain id
  @JsonKey(name: 'chain_id')
  final int chainId;

  /// Whether to fall back to the original link, if not, the link fails
  @JsonKey(name: 'enable_fallback')
  final bool enableFallback;

  factory FpaChainInfo.fromJson(Map<String, dynamic> json) =>
      _$FpaChainInfoFromJson(json);

  Map<String, dynamic> toJson() => _$FpaChainInfoToJson(this);
}

@JsonSerializable()
class FpaHttpProxyChainConfig {
  FpaHttpProxyChainConfig({
    this.chainArray,
    this.chainArraySize = 0,
    this.fallbackWhenNoChainAvailable = true,
  });

  /// [FpaChainInfo] array
  @JsonKey(name: 'chain_array')
  final List<FpaChainInfo>? chainArray;

  /// [FpaChainInfo] array size
  @JsonKey(name: 'chain_array_size')
  final int chainArraySize;

  /// When the http proxy cannot find the corresponding chain configuration, whether to fall back to
  /// the original link, if not, the link fails
  @JsonKey(name: 'fallback_when_no_chain_available')
  final bool fallbackWhenNoChainAvailable;

  factory FpaHttpProxyChainConfig.fromJson(Map<String, dynamic> json) =>
      _$FpaHttpProxyChainConfigFromJson(json);

  Map<String, dynamic> toJson() => _$FpaHttpProxyChainConfigToJson(this);
}

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

@JsonSerializable()
class FpaProxyServiceDiagnosisInfo {
  FpaProxyServiceDiagnosisInfo({
    required this.installId,
    required this.instanceId,
  });

  /// Install id
  @JsonKey(name: 'install_id')
  final String installId;

  /// Instance id
  @JsonKey(name: 'instance_id')
  final String instanceId;

  factory FpaProxyServiceDiagnosisInfo.fromJson(Map<String, dynamic> json) =>
      _$FpaProxyServiceDiagnosisInfoFromJson(json);

  Map<String, dynamic> toJson() => _$FpaProxyServiceDiagnosisInfoToJson(this);
}

abstract class FpaProxyServiceErrorCode {
  /// Everything is OK, No error happen
  static const int none = 0;

  /// Bad parameters when call function
  static const int invalidArgument = -1;

  /// No memory to allocate object
  static const int noMemory = -2;

  /// Not init
  static const int notInitialized = -3;

  /// Initialize failed
  static const int coreInitializeFailed = -4;

  /// Unable to bind a socket port
  static const int unableBindSocketPort = -5;
}

/// fpa fallback error reason code
@JsonEnum(alwaysCreate: true)
enum FpaProxyServiceReasonCode {
  /// Query dns failed(convert request url to ip failed)
  @JsonValue(-101)
  fpaFailedReasonDnsQuery,

  /// Create socket failed
  @JsonValue(-102)
  fpaFailedReasonSocketCreate,

  /// Connect socket failed
  @JsonValue(-103)
  fpaFailedReasonSocketConnect,

  /// Connect remote server timeout(most use at NOT fallback)
  @JsonValue(-104)
  fpaFailedReasonConnectTimeout,

  /// Not match a chain id(most use at http)
  @JsonValue(-105)
  fpaFailedReasonNoChainIdMatch,

  /// Failed to read data
  @JsonValue(-106)
  fpaFailedReasonDataRead,

  /// Failed to write data
  @JsonValue(-107)
  fpaFailedReasonDataWrite,

  /// Call too frequently
  @JsonValue(-108)
  fpaFailedReasonTooFrequently,

  /// Service core connect too many connections
  @JsonValue(-109)
  fpaFailedReasonTooManyConnections,
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

abstract class FpaProxyServiceObserver {
  /// Success of once FPA call(NOT include fallback)
  /// @param info Information of [FpaProxyConnectionInfo]
  void onAccelerationSuccess(FpaProxyConnectionInfo info);

  /// Connect to fpa success
  /// @param info Information of [FpaProxyConnectionInfo]
  void onConnected(FpaProxyConnectionInfo info);

  /// Error happen and fallback when connect(MEAN: will try fallback)
  void onDisconnectedAndFallback(
      FpaProxyConnectionInfo info, FpaProxyServiceReasonCode reason);

  /// Error happen and not fallback when connect(MEAN: not fallback, end of this request)
  /// @param info Information of FpaProxyConnectionInfo
  /// @param reason Reason code of this failed
  void onConnectionFailed(
      FpaProxyConnectionInfo info, FpaProxyServiceReasonCode reason);
}

/// Exceptions are thrown by the [FpaProxyService] functions called.
class FpaProxyServiceException implements Exception {
  FpaProxyServiceException(this.errorCode);

  /// One of the [FpaProxyServiceErrorCode]
  final int errorCode;

  @override
  String toString() {
    return '[FpaProxyServiceException] errorCode: $errorCode';
  }
}

abstract class FpaProxyService {
  static const String kLocalHost = '127.0.0.1';

  static FpaProxyService get instance => FpaProxyServiceImpl.instance;

  /// Start fpa proxy service
  ///
  /// Will throw [FpaProxyServiceException] if not success.
  void start(FpaProxyServiceConfig config);

  /// Stop fpa proxy service
  void stop();

  /// Set [FpaProxyServiceObserver] Observer
  void setObserver(FpaProxyServiceObserver observer);

  /// Get the local http proxy port, Used for http proxy usage scenarios
  int getHttpProxyPort();

  /// Obtain the local transparent proxy port according to the chain information,
  /// Used in transparent proxy scenarios
  int getTransparentProxyPort(FpaChainInfo info);

  /// Set the Parameters
  void setParameters(String params);

  /// Set or update the chain configuration of the http proxy
  void setOrUpdateHttpProxyChainConfig(FpaHttpProxyChainConfig config);

  /// Get information about diagnosis
  FpaProxyServiceDiagnosisInfo getDiagnosisInfo();

  @protected
  String getSDKVersionInner();
  @protected
  String getBuildInfoInner();

  /// Get the Agora Fpa Proxy Service Sdk Version
  static String getSDKVersion() {
    return instance.getSDKVersionInner();
  }

  /// Get the Agora Fpa Proxy Service Sdk build information
  static String getBuildInfo() {
    return instance.getBuildInfoInner();
  }
}
