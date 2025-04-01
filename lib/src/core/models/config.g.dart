// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConfigImpl _$$ConfigImplFromJson(Map<String, dynamic> json) => _$ConfigImpl(
      keyMapping: (json['keyMapping'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      ignoreKeys: (json['ignoreKeys'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      format: json['format'] as String? ?? 'both',
      androidResPath: json['androidResPath'] as String?,
    );

Map<String, dynamic> _$$ConfigImplToJson(_$ConfigImpl instance) =>
    <String, dynamic>{
      'keyMapping': instance.keyMapping,
      'ignoreKeys': instance.ignoreKeys,
      'format': instance.format,
      'androidResPath': instance.androidResPath,
    };
