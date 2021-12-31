import 'package:agora_fpa_service/src/fpa_chain_info.dart';
import 'package:agora_fpa_service/src/fpa_proxy_service_impl.dart';
import 'package:flutter/material.dart';

import 'fpa_http_proxy_chain_config.dart';
import 'fpa_proxy_service_config.dart';
import 'fpa_proxy_service_diagnosis_info.dart';
import 'fpa_proxy_service_observer.dart';

class FpaProxyServiceException implements Exception {
  FpaProxyServiceException(this.errorCode);

  final int errorCode;

  @override
  String toString() {
    return '[FpaProxyServiceException] errorCode: $errorCode';
  }
}

abstract class FpaProxyService {
  static const String kLocalHost = '127.0.0.1';

  static FpaProxyService get instance => FpaProxyServiceImpl.instance;

  /// Will throw [FpaProxyServiceException] if not success.
  void start(FpaProxyServiceConfig config);

  void stop();

  void setObserver(FpaProxyServiceObserver observer);

  int getHttpProxyPort();

  int getTransparentProxyPort(FpaChainInfo info);

  void setParameters(String params);

  void setOrUpdateHttpProxyChainConfig(FpaHttpProxyChainConfig config);

  FpaProxyServiceDiagnosisInfo getDiagnosisInfo();

  @protected
  String getSDKVersionInner();
  @protected
  String getBuildInfoInner();

  static String getSDKVersion() {
    return instance.getSDKVersionInner();
  }

  static String getBuildInfo() {
    return instance.getBuildInfoInner();
  }
}
