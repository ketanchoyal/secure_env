// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectImpl _$$ProjectImplFromJson(Map<String, dynamic> json) =>
    _$ProjectImpl(
      name: json['name'] as String,
      path: json['path'] as String,
      description: json['description'] as String?,
      environments: (json['environments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      config: json['config'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$ProjectImplToJson(_$ProjectImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'path': instance.path,
      'description': instance.description,
      'environments': instance.environments,
      'config': instance.config,
    };
