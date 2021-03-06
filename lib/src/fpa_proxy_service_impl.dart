import 'dart:convert';
import 'dart:ffi' as ffi;
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:agora_fpa_service/agora_fpa_service.dart';
import 'package:agora_fpa_service/src/fpa_proxy_service_observer_json.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'native_iris_fpa_bindings.dart';

const int kBasicResultLength = 512;

class FpaProxyServiceImpl implements FpaProxyService {
  static DynamicLibrary _loadAgoraFpaServiceLib() {
    return Platform.isAndroid
        ? DynamicLibrary.open("libAgoraFpaWrapper.so")
        : DynamicLibrary.process();
  }

  @visibleForTesting
  FpaProxyServiceImpl(NativeIrisFpaBinding binding) {
    _binding = binding;
  }

  static const String kLocalHost = '127.0.0.1';

  static FpaProxyServiceImpl get instance => _instance;
  static FpaProxyServiceImpl _instance =
      FpaProxyServiceImpl(NativeIrisFpaBinding(_loadAgoraFpaServiceLib()));
  @visibleForTesting
  static set instance(FpaProxyServiceImpl instance) {
    _instance = instance;
  }

  late final NativeIrisFpaBinding _binding;
  ffi.Pointer<ffi.Void>? _irisFpaPtr;
  ffi.Pointer<ffi.Void>? _irisEventHandlerPtr;
  FpaProxyServiceObserver? _fpaObserver;
  ReceivePort? _dartNativeReceivePort;
  int _dartNativePort = -1;

  void _checkReturnCode(int ret) {
    if (ret < 0) {
      throw FpaProxyServiceException(ret);
    }
  }

  @override
  void start(FpaProxyServiceConfig config) {
    if (null != _irisFpaPtr) {
      return;
    }

    _irisFpaPtr = _binding.CreateIrisFpaProxyService();
    final p =
        jsonEncode({'config': config.toJson()}).toNativeUtf8().cast<ffi.Int8>();

    try {
      final ret = _binding.CallIrisFpaProxyServiceApi(
        _irisFpaPtr!,
        ApiTypeProxyService.KServiceStart,
        p,
        ffi.nullptr,
      );

      _dartNativeReceivePort = ReceivePort()..listen(onEventHandlerHandle);
      _dartNativePort = _dartNativeReceivePort!.sendPort.nativePort;

      _irisEventHandlerPtr = _binding.SetIrisFpaProxyServiceEventHandlerFlutter(
          _irisFpaPtr!, ffi.NativeApi.initializeApiDLData, _dartNativePort);

      setParameters('{"fpa.app_type":4}');

      _checkReturnCode(ret);
    } catch (e) {
      _irisFpaPtr = null;
      _irisEventHandlerPtr = null;
      rethrow;
    } finally {
      calloc.free(p);
    }
  }

  @override
  void stop() {
    try {
      final ret = _binding.CallIrisFpaProxyServiceApi(
        _irisFpaPtr!,
        ApiTypeProxyService.KServiceStop,
        ffi.nullptr,
        ffi.nullptr,
      );
      _binding.UnsetIrisFpaProxyServiceEventHandler(
        _irisFpaPtr!,
        _irisEventHandlerPtr!,
      );
      _checkReturnCode(ret);
    } catch (e) {
      debugPrint('[FpaProxyService] stop() with error ${e.toString()} ');
    } finally {
      _irisFpaPtr = null;
      _irisEventHandlerPtr = null;
      _fpaObserver = null;
      _dartNativeReceivePort?.close();
      _dartNativeReceivePort = null;
    }
  }

  @visibleForTesting
  static void onEventHandlerHandle(dynamic data) {
    final dataList = List.from(data);
    final event = dataList[0];
    final res = dataList[1] as String;

    switch (event) {
      case 'onAccelerationSuccess':
        final infoJson = FpaProxyConnectionInfoJson.fromJson(jsonDecode(res));
        _instance._fpaObserver?.onAccelerationSuccess(infoJson.info);
        break;
      case 'onConnected':
        final infoJson = FpaProxyConnectionInfoJson.fromJson(jsonDecode(res));
        _instance._fpaObserver?.onConnected(infoJson.info);
        break;
      case 'onDisconnectedAndFallback':
        final fallback = DisconnectedAndFallbackJson.fromJson(jsonDecode(res));
        _instance._fpaObserver?.onDisconnectedAndFallback(
          fallback.info,
          fallback.reason,
        );
        break;
      case 'onConnectionFailed':
        final connectionFailed = ConnectionFailedJson.fromJson(jsonDecode(res));
        _instance._fpaObserver?.onConnectionFailed(
          connectionFailed.info,
          connectionFailed.reason,
        );
        break;
    }
  }

  @override
  void setObserver(FpaProxyServiceObserver observer) {
    _fpaObserver = observer;
  }

  @override
  int getHttpProxyPort() {
    final ffi.Pointer<ffi.Int8> result =
        calloc.allocate(kBasicResultLength).cast<ffi.Int8>();
    try {
      final ret = _binding.CallIrisFpaProxyServiceApi(
        _irisFpaPtr!,
        ApiTypeProxyService.KServiceGetHttpProxyPort,
        ffi.nullptr,
        result,
      );

      _checkReturnCode(ret);

      return int.parse(result.cast<Utf8>().toDartString());
    } catch (e) {
      debugPrint(
          '[FpaProxyService] getHttpProxyPort() with error ${e.toString()}');
      return FpaProxyServiceErrorCode.unableBindSocketPort;
    } finally {
      calloc.free(result);
    }
  }

  @override
  int getTransparentProxyPort(FpaChainInfo info) {
    final ffi.Pointer<ffi.Int8> result =
        calloc.allocate(kBasicResultLength).cast<ffi.Int8>();

    final param =
        jsonEncode({'info': info.toJson()}).toNativeUtf8().cast<ffi.Int8>();
    try {
      final ret = _binding.CallIrisFpaProxyServiceApi(
        _irisFpaPtr!,
        ApiTypeProxyService.KServiceGetTransparentProxyPort,
        param,
        result,
      );

      _checkReturnCode(ret);

      return int.tryParse(result.cast<Utf8>().toDartString()) ?? 0;
    } catch (e) {
      debugPrint(
          '[FpaProxyService] getTransparentProxyPort() with error ${e.toString()}');
      return FpaProxyServiceErrorCode.unableBindSocketPort;
    } finally {
      calloc.free(param);
      calloc.free(result);
    }
  }

  @override
  void setParameters(String params) {
    final p = jsonEncode({
      // TODO(littlegnal): Change the key to 'param'
      'parameters': params,
    });
    final pN = p.toNativeUtf8().cast<ffi.Int8>();
    try {
      final ret = _binding.CallIrisFpaProxyServiceApi(
        _irisFpaPtr!,
        ApiTypeProxyService.KServiceSetParameters,
        pN,
        ffi.nullptr,
      );
      _checkReturnCode(ret);
    } catch (e) {
      debugPrint(
          '[FpaProxyService] setParameters() with error ${e.toString()}');
    } finally {
      calloc.free(pN);
    }
  }

  @override
  void setOrUpdateHttpProxyChainConfig(FpaHttpProxyChainConfig config) {
    final p = jsonEncode({'config': config.toJson()});
    final pN = p.toNativeUtf8().cast<ffi.Int8>();
    try {
      final ret = _binding.CallIrisFpaProxyServiceApi(
        _irisFpaPtr!,
        ApiTypeProxyService.KServiceSetOrUpdateHttpProxyChainConfig,
        pN,
        ffi.nullptr,
      );

      _checkReturnCode(ret);
    } catch (e) {
      debugPrint(
          '[FpaProxyService] setOrUpdateHttpProxyChainConfig() with error ${e.toString()} ');
    } finally {
      calloc.free(pN);
    }
  }

  @override
  FpaProxyServiceDiagnosisInfo getDiagnosisInfo() {
    final ffi.Pointer<ffi.Int8> result =
        calloc.allocate(kBasicResultLength).cast<ffi.Int8>();

    try {
      final ret = _binding.CallIrisFpaProxyServiceApi(
        _irisFpaPtr!,
        ApiTypeProxyService.KServiceGetDiagnosisInfo,
        ffi.nullptr,
        result,
      );

      _checkReturnCode(ret);

      final res = result.cast<Utf8>().toDartString();
      final info = FpaProxyServiceDiagnosisInfo.fromJson(jsonDecode(res));

      return info;
    } catch (e) {
      debugPrint(
          '[FpaProxyService] getDiagnosisInfo() with error ${e.toString()} ');
      return FpaProxyServiceDiagnosisInfo(installId: '', instanceId: '');
    } finally {
      calloc.free(result);
    }
  }

  @override
  String getSDKVersionInner() {
    final ffi.Pointer<ffi.Int8> result =
        calloc.allocate(kBasicResultLength).cast<ffi.Int8>();

    try {
      final ret = _binding.CallIrisFpaProxyServiceApi(
        _irisFpaPtr!,
        ApiTypeProxyService.KServiceGetAgoraFpaProxyServiceSdkVersion,
        ffi.nullptr,
        result,
      );

      _checkReturnCode(ret);

      return result.cast<Utf8>().toDartString();
    } catch (e) {
      debugPrint(
          '[FpaProxyService] getSDKVersion() with error ${e.toString()} ');
      return '';
    } finally {
      calloc.free(result);
    }
  }

  @override
  String getBuildInfoInner() {
    final ffi.Pointer<ffi.Int8> result =
        calloc.allocate(kBasicResultLength).cast<ffi.Int8>();

    try {
      final ret = _binding.CallIrisFpaProxyServiceApi(
        _irisFpaPtr!,
        ApiTypeProxyService.KServiceGetAgoraFpaProxyServiceSdkBuildInfo,
        ffi.nullptr,
        result,
      );

      _checkReturnCode(ret);

      return result.cast<Utf8>().toDartString();
    } catch (e) {
      debugPrint(
          '[FpaProxyService] getBuildInfo() with error ${e.toString()} ');
      return '';
    } finally {
      calloc.free(result);
    }
  }
}
