// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'environment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EnvironmentImpl _$$EnvironmentImplFromJson(Map<String, dynamic> json) =>
    _$EnvironmentImpl(
      name: json['name'] as String,
      projectName: json['projectName'] as String,
      values: Map<String, String>.from(json['values'] as Map),
      isEncrypted: json['isEncrypted'] as bool? ?? false,
      description: json['description'] as String?,
      lastModified: json['lastModified'] == null
          ? null
          : DateTime.parse(json['lastModified'] as String),
    );

Map<String, dynamic> _$$EnvironmentImplToJson(_$EnvironmentImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'projectName': instance.projectName,
      'values': instance.values,
      'isEncrypted': instance.isEncrypted,
      'description': instance.description,
      'lastModified': instance.lastModified?.toIso8601String(),
    };
