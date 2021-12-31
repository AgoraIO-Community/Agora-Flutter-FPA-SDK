import 'dart:async';
import 'dart:io';

import 'package:agora_fpa_service/agora_fpa_service.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> implements FpaProxyServiceObserver {
  static const String uploadHttpUrl = "http://148.153.93.30:30103/upload";
  static const String downloadHttpUrl = "http://148.153.93.30:30103/10MB.txt";
  static const String uploadHttpsUrl =
      "https://frank-web-demo.rtns.sd-rtn.com:30113/upload";
  static const String downloadHttpsUrl =
      "https://frank-web-demo.rtns.sd-rtn.com:30113/1MB.txt";

  late final Dio _dio;
  late final LogSink _logSink;

  bool _uploadHttpsEnabled = false;
  bool _uploadHttpEnabled = false;

  bool _enableFpa = true;

  int _downloadUploadTimes = 1;
  bool _isEditDownloadUploadTimes = false;

  late String _logFilePath;

  bool _isInit = false;

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _downloadUploadTimes.toString());
    _init();
  }

  void _init() async {
    final status = await Permission.storage.request();

    if (!status.isGranted) return;

    final externalStorage = await getApplicationDocumentsDirectory();
    _logFilePath =
        path.join(externalStorage.absolute.path, 'agora', 'fp_log_sdk.log');

    FpaProxyServiceConfig fpaConfig = FpaProxyServiceConfig(
      appId: 'aab8b8f5a8cd4469a63042fcfafe7063',
      token: 'aab8b8f5a8cd4469a63042fcfafe7063',
      logFileSizeKb: 1024,
      logLevel: FpaProxyServiceLogLevel.error,
      logFilePath: _logFilePath,
    );
    try {
      FpaProxyService.instance.start(fpaConfig);
    } on FpaProxyServiceException catch (e) {
      _logSink.sink('start', 'with exception: ${e.toString()}');
      return;
    }

    FpaHttpProxyChainConfig chainConfig = FpaHttpProxyChainConfig(
      chainArray: [
        FpaChainInfo(
          chainId: 259,
          address: 'www.qq.com',
          port: 80,
          enableFallback: true,
        ),
        FpaChainInfo(
          chainId: 254,
          address: 'frank-web-demo.rtns.sd-rtn.com',
          port: 30113,
          enableFallback: true,
        ),
        FpaChainInfo(
          chainId: 204,
          address: '148.153.93.30',
          port: 30103,
          enableFallback: true,
        ),
      ],
      fallbackWhenNoChainAvailable: true,
    );

    FpaProxyService.instance.setOrUpdateHttpProxyChainConfig(chainConfig);

    FpaProxyService.instance.setObserver(this);

    _dio = Dio();
    _resetFpa(true);
    _logSink = LogSink();

    setState(() {
      _isInit = true;
    });
  }

  @override
  void onProxyEvent(FpaProxyEvent event, FpaProxyConnectionInfo connectionInfo,
      int errorCode) {
    _logSink.sink(
      'onProxyEvent',
      'event: $event, connectionInfo: ${connectionInfo.toString()}, errorCode: $errorCode',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    FpaProxyService.instance.stop();
    super.dispose();
  }

  void _resetFpa(bool enable) {
    if (enable) {
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        // config the http client
        client.findProxy = (uri) {
          return 'PROXY ${FpaProxyService.kLocalHost}:${FpaProxyService.instance.getHttpProxyPort()}';
        };
      };
    } else {
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.findProxy = null;
      };
    }
  }

  String _prefixFPATag(String input) {
    return '${_enableFpa ? '[FPA] ' : ''} $input';
  }

  void _download(String url, String fileName, int times) async {
    final status = await Permission.storage.request();

    if (!status.isGranted) return;

    for (int ct = 0; ct < times; ct++) {
      _downloadInner(url, fileName, ct + 1);
    }
  }

  Future<void> _downloadInner(
      String url, String fileName, int currentTime) async {
    final externalStorage = await getApplicationDocumentsDirectory();

    Stopwatch stopwatch = Stopwatch();
    stopwatch.start();
    final key = fileName;
    try {
      _logSink.sink(
        key,
        _prefixFPATag(
          '(times: $currentTime)Downloading...',
        ),
        appendTimestampToTag: false,
      );
      await _dio.download(
        url,
        path.join(externalStorage.absolute.path, fileName),
        onReceiveProgress: (int count, int total) {},
      );
      stopwatch.stop();
      setState(() {
        if (url.startsWith('https')) {
          _uploadHttpsEnabled = true;
        } else {
          _uploadHttpEnabled = true;
        }
      });

      _logSink.sink(
        key,
        _prefixFPATag(
          '(times: $currentTime)Download complated, time: ${stopwatch.elapsedMilliseconds}ms',
        ),
        appendTimestampToTag: false,
      );
    } catch (e) {
      _logSink.sink(
        key,
        _prefixFPATag(
          '(times: $currentTime)Download error: ${e.toString()}',
        ),
        appendTimestampToTag: false,
      );
    }
  }

  Future<void> _upload(String url, String fileName, int times) async {
    for (int ct = 0; ct < times; ct++) {
      _uploadInner(url, fileName, ct + 1);
    }
  }

  Future<void> _uploadInner(
      String url, String fileName, int currentTime) async {
    final externalStorage = await getApplicationDocumentsDirectory();

    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
          path.join(externalStorage.absolute.path, fileName),
          filename: fileName),
    });

    Stopwatch stopwatch = Stopwatch();
    stopwatch.start();
    final key = fileName;

    try {
      _logSink.sink(
        key,
        _prefixFPATag(
          '(times: $currentTime)Uploading...',
        ),
        appendTimestampToTag: false,
      );
      await _dio.post(url,
          data: formData, onSendProgress: (int count, int total) {});
      stopwatch.stop();
      _logSink.sink(
        key,
        _prefixFPATag(
          '(times: $currentTime)Upload complated, time: ${stopwatch.elapsedMilliseconds}ms',
        ),
        appendTimestampToTag: false,
      );
    } catch (e) {
      _logSink.sink(
        key,
        _prefixFPATag(
          '(times: $currentTime)Upload error: ${e.toString()}',
        ),
        appendTimestampToTag: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fpa Service example app'),
        ),
        body: !_isInit
            ? Container()
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SwitchListTile(
                        title: Text(
                          'Enable FPA${_enableFpa ? ' (fpa port: ${FpaProxyService.instance.getHttpProxyPort()})' : ''}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        value: _enableFpa,
                        onChanged: (changed) {
                          _enableFpa = changed;
                          _resetFpa(_enableFpa);
                          setState(() {});
                        }),
                    if (_enableFpa)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('log file path: $_logFilePath'),
                          Text(
                              'sdk version: ${FpaProxyService.getSDKVersion()}'),
                          Text('build info: ${FpaProxyService.getBuildInfo()}'),
                        ],
                      ),
                    Row(
                      children: [
                        const Text('Download/Upload times: '),
                        if (_isEditDownloadUploadTimes)
                          Expanded(
                            child: TextField(
                              controller: _controller,
                            ),
                          ),
                        if (!_isEditDownloadUploadTimes)
                          Text('$_downloadUploadTimes'),
                        ElevatedButton(
                          onPressed: () {
                            if (_isEditDownloadUploadTimes) {
                              _downloadUploadTimes =
                                  int.parse(_controller.value.text);
                            }

                            _isEditDownloadUploadTimes =
                                !_isEditDownloadUploadTimes;

                            // _outputMap.clear();
                            setState(() {});
                          },
                          child:
                              Text(_isEditDownloadUploadTimes ? 'OK' : 'Edit'),
                        ),
                      ],
                    ),
                    const Text(downloadHttpsUrl),
                    ElevatedButton(
                      onPressed: () {
                        _download(downloadHttpsUrl, 'download1M.pptx',
                            _downloadUploadTimes);
                      },
                      child: Text(_prefixFPATag('Download Https')),
                    ),
                    const Text(uploadHttpsUrl),
                    ElevatedButton(
                      onPressed: _uploadHttpsEnabled
                          ? () {
                              _upload(uploadHttpsUrl, 'download1M.pptx',
                                  _downloadUploadTimes);
                            }
                          : null,
                      child: Text(_prefixFPATag('Upload Https')),
                    ),
                    const Text(downloadHttpUrl),
                    ElevatedButton(
                      onPressed: () {
                        _download(downloadHttpUrl, 'download10M.pptx',
                            _downloadUploadTimes);
                      },
                      child: Text(_prefixFPATag('Download Http')),
                    ),
                    const Text(uploadHttpUrl),
                    ElevatedButton(
                        onPressed: _uploadHttpEnabled
                            ? () {
                                _upload(uploadHttpUrl, 'download10M.pptx',
                                    _downloadUploadTimes);
                              }
                            : null,
                        child: Text(_prefixFPATag('Upload Http'))),
                    TransparentProxyWidget(
                      logSink: _logSink,
                      downloadUploadTimes: _downloadUploadTimes,
                    ),
                    OutputLogWidget(
                      logSink: _logSink,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class LogSink extends ChangeNotifier {
  final StringBuffer stringBuffer = StringBuffer();

  void sink(String tag, String log, {bool appendTimestampToTag = true}) {
    String logNew = log;
    final now = DateTime.now();
    logNew = '${now.hour}:${now.minute}:${now.second} $logNew';

    stringBuffer.writeln('${now.hour}:${now.minute}:${now.second} [$tag] $log');
    stringBuffer.writeln();

    notifyListeners();
  }

  String getOutput() {
    return stringBuffer.toString();
  }

  void clear() {
    stringBuffer.clear();
    notifyListeners();
  }
}

class OutputLogWidget extends StatefulWidget {
  const OutputLogWidget({Key? key, required this.logSink}) : super(key: key);

  final LogSink logSink;

  @override
  _OutputLogWidgetState createState() => _OutputLogWidgetState();
}

class _OutputLogWidgetState extends State<OutputLogWidget> {
  late final LogSink _logSink;

  @override
  void initState() {
    super.initState();

    _logSink = widget.logSink;
    _logSink.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Log',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextButton(
                onPressed: () {
                  _logSink.clear();
                },
                child: const Text('Clear'))
          ],
        ),
        Text(_logSink.getOutput()),
      ],
    );
  }
}

class TransparentProxyWidget extends StatefulWidget {
  const TransparentProxyWidget({
    Key? key,
    required this.logSink,
    required this.downloadUploadTimes,
  }) : super(key: key);

  final LogSink logSink;
  final int downloadUploadTimes;

  @override
  _TransparentProxyWidgetState createState() => _TransparentProxyWidgetState();
}

class _TransparentProxyWidgetState extends State<TransparentProxyWidget> {
  late final LogSink _logSink;

  final List<List<Object>> _chainInfos = [
    [
      FpaChainInfo(
        address: 'BAD',
        port: -1,
        chainId: -1,
        enableFallback: true,
      ),
      'Error data',
    ],
    [
      FpaChainInfo(
        address: '164.52.28.236',
        port: 30102,
        chainId: 203,
        enableFallback: true,
      ),
      'nomal domain, normal chain, can fallback',
    ],
    [
      FpaChainInfo(
        address: '164.52.28.236',
        port: 30102,
        chainId: 10086,
        enableFallback: false,
      ),
      'normal domain, un-normal chain, can not fallback'
    ],
    [
      FpaChainInfo(
        address: '164.52.28.236',
        port: 30102,
        chainId: 10011,
        enableFallback: true,
      ),
      'normal domain, un-normal chain, can fallback'
    ],
  ];

  int _selectedChainInfoIndex = 0;

  int _port = 0;

  String _formatChainInfo(List<Object> infos) {
    FpaChainInfo chainInfo = infos[0] as FpaChainInfo;
    String des = infos[1] as String;
    return '${chainInfo.address}:${chainInfo.port}@${chainInfo.chainId} ${chainInfo.enableFallback}\n $des';
  }

  @override
  void initState() {
    super.initState();

    _logSink = widget.logSink;
  }

  void _refreshPort() {
    if (_selectedChainInfoIndex == 0) return;

    FpaProxyServiceDiagnosisInfo info =
        FpaProxyService.instance.getDiagnosisInfo();

    _logSink.sink(
      'TransparentProxy',
      'FpaProxyServiceDiagnosisInfo installId: ${info.installId}, instanceId: ${info.instanceId}',
    );

    final chainInfo = _chainInfos[_selectedChainInfoIndex][0] as FpaChainInfo;

    _port = FpaProxyService.instance.getTransparentProxyPort(chainInfo);

    if (_port <= 0) {
      _logSink.sink(
        'TransparentProxy',
        'can not get transparent port in ${chainInfo.toString()}',
      );
    }
  }

  void _connectAll() {
    for (int i = 0; i < widget.downloadUploadTimes; i++) {
      _connect(_port, i);
    }
  }

  void _connect(int port, int currentTime) async {
    late final Socket socket;
    try {
      socket = await Socket.connect(FpaProxyService.kLocalHost, port);
    } catch (e) {
      _logSink.sink(
        'TransparentProxy',
        '(times: $currentTime) Error in connect socket: ${e.toString()}',
      );
    }

    socket.listen(
      (data) {
        if (data != null) {
          String readData = String.fromCharCodes(data).trim();
          _logSink.sink(
            'TransparentProxy',
            '(times: $currentTime) Read data (port:$_port):\n$readData\nsize:${readData.length}',
          );
        }
      },
      onError: (error, StackTrace trace) {
        _logSink.sink(
          'TransparentProxy',
          '(times: $currentTime) Error in socket request(port:$_port): ${error.toString()}',
        );
      },
      onDone: () {
        socket.destroy();
      },
      cancelOnError: false,
    );

    socket.write('GET /1KB.txt? HTTP/1.1\r\nHost: 127.0.0.1\r\n\r\n');
    await socket.flush();
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<int>> items = [];
    for (int i = 0; i < _chainInfos.length; i++) {
      final info = _chainInfos[i];
      items.add(DropdownMenuItem<int>(
        child: Text(
          _formatChainInfo(info),
          style: const TextStyle(fontSize: 10),
        ),
        value: i,
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transparent proxy (port: $_port)',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        DropdownButton<int>(
          hint: const Text('Select chain info'),
          value: _selectedChainInfoIndex,
          items: items,
          onChanged: (value) {
            setState(() {
              _selectedChainInfoIndex = value as int;
              _refreshPort();
            });
          },
        ),
        ElevatedButton(
          onPressed: _port <= 0
              ? null
              : () {
                  _connectAll();
                },
          child: const Text('Start transparent proxy'),
        ),
      ],
    );
  }
}
