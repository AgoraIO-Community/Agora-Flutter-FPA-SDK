// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fpa_http_proxy_chain_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FpaHttpProxyChainConfig _$FpaHttpProxyChainConfigFromJson(
        Map<String, dynamic> json) =>
    FpaHttpProxyChainConfig(
      chainArray: (json['chain_array'] as List<dynamic>?)
          ?.map((e) => FpaChainInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      chainArraySize: json['chain_array_size'] as int? ?? 0,
      fallbackWhenNoChainAvailable:
          json['fallback_when_no_chain_available'] as bool? ?? true,
    );

Map<String, dynamic> _$FpaHttpProxyChainConfigToJson(
        FpaHttpProxyChainConfig instance) =>
    <String, dynamic>{
      'chain_array': instance.chainArray,
      'chain_array_size': instance.chainArraySize,
      'fallback_when_no_chain_available': instance.fallbackWhenNoChainAvailable,
    };
