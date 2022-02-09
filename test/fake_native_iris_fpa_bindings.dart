import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'dart:convert';

import 'package:agora_fpa_service/src/native_iris_fpa_bindings.dart';

class IrisApiCall {
  late Pointer<Void> service_ptr;
  late int api_type;
  late String params;
  late String result;
}

class ApiCall {
  late String method;
  IrisApiCall? irisApiCall;
}

class FakeNativeIrisFpaBindings implements NativeIrisFpaBinding {
  final List<ApiCall> apiCallQueue = [];
  final Map<int, String> _mockResult = {};

  void mockResult(int apiType, String result) {
    _mockResult[apiType] = result;
  }

  bool apiCalled(
    String method, {
    Pointer<Void>? servicePtr,
    int? apiType,
    String? params,
    String? result,
    int times = 1,
  }) {
    int callTimes = 0;
    bool apiCalled = false;
    ApiCall apiCall;
    for (final call in apiCallQueue.reversed) {
      if (call.method == method) {
        callTimes++;
        apiCalled = true;
        if (servicePtr != null) {
          apiCalled = apiCalled && servicePtr == call.irisApiCall!.service_ptr;
        }
        if (apiType != null) {
          apiCalled = apiCalled && apiType == call.irisApiCall!.api_type;
        }
        if (params != null) {
          apiCalled = apiCalled && params == call.irisApiCall!.params;
        }
        if (result != null) {
          apiCalled = apiCalled && result == call.irisApiCall!.result;
        }

        if (apiCalled) break;
      }
    }

    // apiCalled = apiCalled && callTimes == times;

    return apiCalled;
  }

  @override
  int CallIrisFpaProxyServiceApi(Pointer<Void> service_ptr, int api_type,
      Pointer<Int8> params, Pointer<Int8> result) {
    // return result.cast();

    final irisApiCall = IrisApiCall()
      ..service_ptr = service_ptr
      ..api_type = api_type
      ..params = params == nullptr ? '' : params.cast<Utf8>().toDartString();

    if (result != nullptr) {
      if (_mockResult.containsKey(api_type)) {
        final units = utf8.encode(_mockResult[api_type]!);
        // final Pointer<Uint8> result = allocator<Uint8>(units.length + 1);
        final Int8List nativeString = result.asTypedList(units.length + 1);
        nativeString.setAll(0, units);
        nativeString[units.length] = 0;

        // irisApiCall.result = _mockResult[api_type]!;
      } else {
        // irisApiCall.result = result.cast<Utf8>().toDartString();
      }
    } else {
      irisApiCall.result = '';
    }

    final apiCall = ApiCall()
      ..method = 'CallIrisFpaProxyServiceApi'
      ..irisApiCall = irisApiCall;

    apiCallQueue.add(apiCall);
    return 0;
  }

  @override
  int CallIrisFpaProxyServiceApiWithBuffer(
      Pointer<Void> service_ptr,
      int api_type,
      Pointer<Int8> params,
      Pointer<Void> buffer,
      Pointer<Int8> result) {
    apiCallQueue.add(
      ApiCall()
        ..method = 'CallIrisFpaProxyServiceApiWithBuffer'
        ..irisApiCall = (IrisApiCall()
          ..service_ptr = service_ptr
          ..api_type = api_type
          ..params = params == nullptr ? '' : params.cast<Utf8>().toDartString()
          ..result =
              result == nullptr ? '' : result.cast<Utf8>().toDartString()),
    );
    return 0;
  }

  @override
  Pointer<Void> CreateIrisFpaProxyService() {
    apiCallQueue.add(ApiCall()..method = 'CreateIrisFpaProxyService');
    return nullptr;
  }

  @override
  void DestroyIrisFpaProxyService(Pointer<Void> service_ptr) {
    apiCallQueue.add(ApiCall()..method = 'DestroyIrisFpaProxyService');
  }

  @override
  Pointer<Void> SetIrisFpaProxyServiceEventHandler(
      Pointer<Void> service_ptr, Pointer<IrisCEventHandler> event_handler) {
    apiCallQueue.add(ApiCall()..method = 'SetIrisFpaProxyServiceEventHandler');
    return nullptr;
  }

  @override
  Pointer<Void> SetIrisFpaProxyServiceEventHandlerFlutter(
      Pointer<Void> service_ptr,
      Pointer<Void> init_dart_api_data,
      int dart_send_port) {
    apiCallQueue
        .add(ApiCall()..method = 'SetIrisFpaProxyServiceEventHandlerFlutter');
    return nullptr;
  }

  @override
  void UnsetIrisFpaProxyServiceEventHandler(
      Pointer<Void> service_ptr, Pointer<Void> handle) {
    apiCallQueue
        .add(ApiCall()..method = 'UnsetIrisFpaProxyServiceEventHandler');
  }
}
