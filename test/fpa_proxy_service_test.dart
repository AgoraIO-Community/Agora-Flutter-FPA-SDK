import 'dart:convert';
import 'dart:ffi';

import 'package:agora_fpa_service/agora_fpa_service.dart';
import 'package:agora_fpa_service/src/fpa_proxy_service_impl.dart';
import 'package:agora_fpa_service/src/fpa_proxy_service_observer_json.dart';
import 'package:agora_fpa_service/src/native_iris_fpa_bindings.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_native_iris_fpa_bindings.dart';

class TestFpaProxyServiceObserver implements FpaProxyServiceObserver {
  bool isOnAccelerationSuccessCalled = false;
  bool isOnConnectedCalled = false;
  bool isOnConnectionFailedCalled = false;
  bool isOnDisconnectedAndFallbackCalled = false;
  @override
  void onAccelerationSuccess(FpaProxyConnectionInfo info) {
    isOnAccelerationSuccessCalled = true;
  }

  @override
  void onConnected(FpaProxyConnectionInfo info) {
    isOnConnectedCalled = true;
  }

  @override
  void onConnectionFailed(
      FpaProxyConnectionInfo info, FpaProxyServiceReasonCode reason) {
    isOnConnectionFailedCalled = true;
  }

  @override
  void onDisconnectedAndFallback(
      FpaProxyConnectionInfo info, FpaProxyServiceReasonCode reason) {
    isOnDisconnectedAndFallbackCalled = true;
  }
}

void main() {
  late FpaProxyServiceImpl fpaProxyServiceImpl;
  late FakeNativeIrisFpaBindings fakeNativeIrisFpaBinding;

  setUp(() {
    fakeNativeIrisFpaBinding = FakeNativeIrisFpaBindings();
    fpaProxyServiceImpl = FpaProxyServiceImpl(fakeNativeIrisFpaBinding);
    FpaProxyServiceImpl.instance = fpaProxyServiceImpl;
  });

  group('FpaProxyService ', () {
    test('start', () {
      final config = FpaProxyServiceConfig(appId: '123', token: 'abc');
      FpaProxyService.instance.start(config);

      expect(
        fakeNativeIrisFpaBinding.apiCalled('CreateIrisFpaProxyService'),
        isTrue,
      );
      expect(
        fakeNativeIrisFpaBinding.apiCalled(
          'CallIrisFpaProxyServiceApi',
          servicePtr: nullptr,
          apiType: ApiTypeProxyService.KServiceStart,
          params: jsonEncode({'config': config.toJson()}),
        ),
        isTrue,
      );
      expect(
        fakeNativeIrisFpaBinding
            .apiCalled('SetIrisFpaProxyServiceEventHandlerFlutter'),
        isTrue,
      );

      expect(
        fakeNativeIrisFpaBinding.apiCalled(
          'CallIrisFpaProxyServiceApi',
          servicePtr: nullptr,
          apiType: ApiTypeProxyService.KServiceSetParameters,
          params: jsonEncode({
            'parameters': '{"fpa.app_type":4}',
          }),
        ),
        isTrue,
      );
    });

    test('stop', () {
      final config = FpaProxyServiceConfig(appId: '123', token: 'abc');
      FpaProxyService.instance.start(config);
      FpaProxyService.instance.stop();
      expect(
        fakeNativeIrisFpaBinding.apiCalled(
          'CallIrisFpaProxyServiceApi',
          servicePtr: nullptr,
          apiType: ApiTypeProxyService.KServiceStop,
        ),
        isTrue,
      );
      expect(
        fakeNativeIrisFpaBinding
            .apiCalled('UnsetIrisFpaProxyServiceEventHandler'),
        isTrue,
      );
    });

    test('getHttpProxyPort', () {
      fakeNativeIrisFpaBinding.mockResult(
        ApiTypeProxyService.KServiceGetHttpProxyPort,
        '10',
      );

      final config = FpaProxyServiceConfig(appId: '123', token: 'abc');
      FpaProxyService.instance.start(config);

      final port = FpaProxyService.instance.getHttpProxyPort();
      expect(port, 10);

      expect(
        fakeNativeIrisFpaBinding.apiCalled(
          'CallIrisFpaProxyServiceApi',
          servicePtr: nullptr,
          apiType: ApiTypeProxyService.KServiceGetHttpProxyPort,
        ),
        isTrue,
      );
    });

    test('getTransparentProxyPort', () {
      fakeNativeIrisFpaBinding.mockResult(
        ApiTypeProxyService.KServiceGetTransparentProxyPort,
        '10',
      );

      final config = FpaProxyServiceConfig(appId: '123', token: 'abc');
      FpaProxyService.instance.start(config);

      final info = FpaChainInfo(address: '127.0.0.1');
      final port = FpaProxyService.instance.getTransparentProxyPort(info);
      expect(port, 10);

      expect(
        fakeNativeIrisFpaBinding.apiCalled(
          'CallIrisFpaProxyServiceApi',
          servicePtr: nullptr,
          apiType: ApiTypeProxyService.KServiceGetTransparentProxyPort,
        ),
        isTrue,
      );
    });

    test('setParameters', () {
      final config = FpaProxyServiceConfig(appId: '123', token: 'abc');
      FpaProxyService.instance.start(config);

      FpaProxyService.instance.setParameters('param');

      expect(
        fakeNativeIrisFpaBinding.apiCalled(
          'CallIrisFpaProxyServiceApi',
          servicePtr: nullptr,
          apiType: ApiTypeProxyService.KServiceSetParameters,
          params: jsonEncode({
            'parameters': 'param',
          }),
        ),
        isTrue,
      );
    });

    test('setOrUpdateHttpProxyChainConfig', () {
      final config = FpaProxyServiceConfig(appId: '123', token: 'abc');
      FpaProxyService.instance.start(config);

      final FpaHttpProxyChainConfig cc = FpaHttpProxyChainConfig();
      FpaProxyService.instance.setOrUpdateHttpProxyChainConfig(cc);

      expect(
        fakeNativeIrisFpaBinding.apiCalled(
          'CallIrisFpaProxyServiceApi',
          servicePtr: nullptr,
          apiType: ApiTypeProxyService.KServiceSetOrUpdateHttpProxyChainConfig,
          params: jsonEncode({'config': cc.toJson()}),
        ),
        isTrue,
      );
    });

    test('getDiagnosisInfo', () {
      final expectInfo =
          FpaProxyServiceDiagnosisInfo(installId: '10', instanceId: '20');
      fakeNativeIrisFpaBinding.mockResult(
        ApiTypeProxyService.KServiceGetDiagnosisInfo,
        jsonEncode(expectInfo.toJson()),
      );

      final config = FpaProxyServiceConfig(appId: '123', token: 'abc');
      FpaProxyService.instance.start(config);

      final info = FpaProxyService.instance.getDiagnosisInfo();
      expect(info.installId, expectInfo.installId);
      expect(info.instanceId, expectInfo.instanceId);
      expect(
        fakeNativeIrisFpaBinding.apiCalled(
          'CallIrisFpaProxyServiceApi',
          servicePtr: nullptr,
          apiType: ApiTypeProxyService.KServiceGetDiagnosisInfo,
        ),
        isTrue,
      );
    });

    test('getSDKVersion', () {
      fakeNativeIrisFpaBinding.mockResult(
        ApiTypeProxyService.KServiceGetAgoraFpaProxyServiceSdkVersion,
        '1.0.0',
      );

      final config = FpaProxyServiceConfig(appId: '123', token: 'abc');
      FpaProxyService.instance.start(config);

      final version = FpaProxyService.getSDKVersion();
      expect(version, '1.0.0');

      expect(
        fakeNativeIrisFpaBinding.apiCalled(
          'CallIrisFpaProxyServiceApi',
          servicePtr: nullptr,
          apiType:
              ApiTypeProxyService.KServiceGetAgoraFpaProxyServiceSdkVersion,
        ),
        isTrue,
      );
    });

    test('getBuildInfo', () {
      fakeNativeIrisFpaBinding.mockResult(
        ApiTypeProxyService.KServiceGetAgoraFpaProxyServiceSdkBuildInfo,
        'stable build',
      );

      final config = FpaProxyServiceConfig(appId: '123', token: 'abc');
      FpaProxyService.instance.start(config);

      final version = FpaProxyService.getBuildInfo();
      expect(version, 'stable build');

      expect(
        fakeNativeIrisFpaBinding.apiCalled(
          'CallIrisFpaProxyServiceApi',
          servicePtr: nullptr,
          apiType:
              ApiTypeProxyService.KServiceGetAgoraFpaProxyServiceSdkBuildInfo,
        ),
        isTrue,
      );
    });
  });

  group('FpaProxyService FpaProxyServiceObserver ', () {
    test('onAccelerationSuccess', () {
      final observer = TestFpaProxyServiceObserver();
      FpaProxyService.instance.setObserver(observer);
      final info = FpaProxyConnectionInfo(
        dstIpOrDomain: 'localhost',
        connectionId: '10',
        proxyType: '10',
      );
      final infoJson = FpaProxyConnectionInfoJson(info: info);
      FpaProxyServiceImpl.onEventHandlerHandle([
        'onAccelerationSuccess',
        jsonEncode(infoJson.toJson()),
      ]);
      expect(observer.isOnAccelerationSuccessCalled, isTrue);
    });

    test('onConnected', () {
      final observer = TestFpaProxyServiceObserver();
      FpaProxyService.instance.setObserver(observer);
      final info = FpaProxyConnectionInfo(
        dstIpOrDomain: 'localhost',
        connectionId: '10',
        proxyType: '10',
      );
      final infoJson = FpaProxyConnectionInfoJson(info: info);
      FpaProxyServiceImpl.onEventHandlerHandle([
        'onConnected',
        jsonEncode(infoJson.toJson()),
      ]);
      expect(observer.isOnConnectedCalled, isTrue);
    });

    test('onDisconnectedAndFallback', () {
      final observer = TestFpaProxyServiceObserver();
      FpaProxyService.instance.setObserver(observer);
      final info = FpaProxyConnectionInfo(
        dstIpOrDomain: 'localhost',
        connectionId: '10',
        proxyType: '10',
      );
      final DisconnectedAndFallbackJson disconnectedAndFallbackJson =
          DisconnectedAndFallbackJson(
        info: info,
        reason: FpaProxyServiceReasonCode.fpaFailedReasonDnsQuery,
      );
      FpaProxyServiceImpl.onEventHandlerHandle([
        'onDisconnectedAndFallback',
        jsonEncode(disconnectedAndFallbackJson.toJson()),
      ]);
      expect(observer.isOnDisconnectedAndFallbackCalled, isTrue);
    });

    test('onConnectionFailed', () {
      final observer = TestFpaProxyServiceObserver();
      FpaProxyService.instance.setObserver(observer);
      final info = FpaProxyConnectionInfo(
        dstIpOrDomain: 'localhost',
        connectionId: '10',
        proxyType: '10',
      );
      final ConnectionFailedJson connectionFailedJson = ConnectionFailedJson(
        info: info,
        reason: FpaProxyServiceReasonCode.fpaFailedReasonDnsQuery,
      );
      FpaProxyServiceImpl.onEventHandlerHandle([
        'onConnectionFailed',
        jsonEncode(connectionFailedJson.toJson()),
      ]);
      expect(observer.isOnConnectionFailedCalled, isTrue);
    });
  });
}
