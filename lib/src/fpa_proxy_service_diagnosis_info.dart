import 'package:json_annotation/json_annotation.dart';

part 'fpa_proxy_service_diagnosis_info.g.dart';

@JsonSerializable()
class FpaProxyServiceDiagnosisInfo {
  FpaProxyServiceDiagnosisInfo({
    required this.installId,
    required this.instanceId,
  });

  @JsonKey(name: 'install_id')
  final String installId;

  @JsonKey(name: 'instance_id')
  final String instanceId;

  factory FpaProxyServiceDiagnosisInfo.fromJson(Map<String, dynamic> json) =>
      _$FpaProxyServiceDiagnosisInfoFromJson(json);

  Map<String, dynamic> toJson() => _$FpaProxyServiceDiagnosisInfoToJson(this);
}
