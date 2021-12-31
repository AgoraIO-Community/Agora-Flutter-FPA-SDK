import 'package:json_annotation/json_annotation.dart';

import 'fpa_chain_info.dart';

part 'fpa_http_proxy_chain_config.g.dart';

@JsonSerializable()
class FpaHttpProxyChainConfig {
  FpaHttpProxyChainConfig({
    this.chainArray,
    this.chainArraySize = 0,
    this.fallbackWhenNoChainAvailable = true,
  });
  @JsonKey(name: 'chain_array')
  final List<FpaChainInfo>? chainArray;

  @JsonKey(name: 'chain_array_size')
  final int chainArraySize;

  @JsonKey(name: 'fallback_when_no_chain_available')
  final bool fallbackWhenNoChainAvailable;

  factory FpaHttpProxyChainConfig.fromJson(Map<String, dynamic> json) =>
      _$FpaHttpProxyChainConfigFromJson(json);

  Map<String, dynamic> toJson() => _$FpaHttpProxyChainConfigToJson(this);
}
