import 'package:json_annotation/json_annotation.dart';

part 'fpa_chain_info.g.dart';

@JsonSerializable()
class FpaChainInfo {
  FpaChainInfo({
    required this.address,
    this.port = 0,
    this.chainId = 0,
    this.enableFallback = true,
  });
  @JsonKey(name: 'address')
  final String address;

  @JsonKey(name: 'port')
  final int port;

  @JsonKey(name: 'chain_id')
  final int chainId;

  @JsonKey(name: 'enable_fallback')
  final bool enableFallback;

  factory FpaChainInfo.fromJson(Map<String, dynamic> json) =>
      _$FpaChainInfoFromJson(json);

  Map<String, dynamic> toJson() => _$FpaChainInfoToJson(this);
}
