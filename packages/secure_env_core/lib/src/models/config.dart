import 'package:freezed_annotation/freezed_annotation.dart';

part 'config.freezed.dart';
part 'config.g.dart';

@freezed
abstract class Config with _$Config {
  const factory Config({
    @Default({}) Map<String, String> keyMapping,
    @Default([]) List<String> ignoreKeys,
    @Default('both') String format,
    String? androidResPath,
  }) = _Config;

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);
}
