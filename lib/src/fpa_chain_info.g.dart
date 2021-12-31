// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fpa_chain_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FpaChainInfo _$FpaChainInfoFromJson(Map<String, dynamic> json) => FpaChainInfo(
      address: json['address'] as String,
      port: json['port'] as int? ?? 0,
      chainId: json['chain_id'] as int? ?? 0,
      enableFallback: json['enable_fallback'] as bool? ?? true,
    );

Map<String, dynamic> _$FpaChainInfoToJson(FpaChainInfo instance) =>
    <String, dynamic>{
      'address': instance.address,
      'port': instance.port,
      'chain_id': instance.chainId,
      'enable_fallback': instance.enableFallback,
    };
