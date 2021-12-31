// import 'dart:convert';

// import 'package:agora_fpa_service/src/native_fpa_service.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:agora_fpa_service/agora_fpa_service.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';

// import 'fpa_service_test.mocks.dart';

// class _AgoraFpaServiceObserver implements FpaServiceObserver {
//   @override
//   void onEvent(int event, int errorCode) {}

//   @override
//   void onTokenWillExpireEvent(String token) {}
// }

// @GenerateMocks([],
//     customMocks: [MockSpec<NativeFpaService>(returnNullOnMissingStub: true)])
// void main() {
//   late FpaProxyService agoraFpaService;
//   late NativeFpaService nativeAgoraFpaService;
//   setUp(() {
//     nativeAgoraFpaService = MockNativeFpaService();
//     agoraFpaService = FpaProxyService.mock(nativeAgoraFpaService);
//   });
//   group('NativeAgoraFpaService', () {
//     test('init called', () {
//       final config = FpaProxyServiceConfig(appId: 'appId', token: 'token');
//       when(nativeAgoraFpaService.init(config)).thenReturn(0);
//       final ret = agoraFpaService.start(config);
//       expect(ret, 0);
//     });

//     test('init with observer called', () {
//       final observer = _AgoraFpaServiceObserver();

//       final config = FpaProxyServiceConfig(appId: 'appId', token: 'token');
//       when(nativeAgoraFpaService.init(config, observer: observer))
//           .thenReturn(0);
//       final ret = agoraFpaService.start(config, observer: observer);
//       expect(ret, 0);
//     });

//     test('destroy called', () {
//       agoraFpaService.destroy();
//       verify(nativeAgoraFpaService.destroy()).called(1);
//     });

//     test('getHttpProxyPort called', () {
//       when(nativeAgoraFpaService.getHttpProxyPort()).thenReturn(8888);
//       final ret = agoraFpaService.getHttpProxyPort();
//       expect(ret, 8888);
//     });

//     test('renewToken called', () {
//       when(nativeAgoraFpaService.renewToken('new token')).thenReturn(0);
//       final ret = agoraFpaService.renewToken('new token');
//       expect(ret, 0);
//     });

//     test('setParameters called', () {
//       when(nativeAgoraFpaService.setParameters('p')).thenReturn(0);
//       final ret = agoraFpaService.setParameters('p');
//       expect(ret, 0);
//     });

//     test('updateChainIdTable called', () {
//       final chainIdTable = jsonEncode(const {});
//       when(nativeAgoraFpaService.updateChainIdInfo(chainIdTable)).thenReturn(0);
//       final ret = agoraFpaService.updateChainIdTable(const {});
//       expect(ret, 0);
//     });
//   });
// }
