import 'dart:io';
import 'package:yaml/yaml.dart';

/// Parses the YAML configuration for the native splash generator.
class ConfigParser {
  /// Looks for `flutter_splash_studio.yaml` or `pubspec.yaml`.
  static Future<Map<String, dynamic>?> parseConfig() async {
    final customConfigFile = File('flutter_splash_studio.yaml');
    final pubspecFile = File('pubspec.yaml');

    if (await customConfigFile.exists()) {
      final content = await customConfigFile.readAsString();
      final yamlMap = loadYaml(content) as Map?;
      return _convertYamlMap(yamlMap);
    } else if (await pubspecFile.exists()) {
      final content = await pubspecFile.readAsString();
      final yamlMap = loadYaml(content) as Map?;
      if (yamlMap != null && yamlMap.containsKey('flutter_splash_studio')) {
        return _convertYamlMap(yamlMap['flutter_splash_studio'] as Map?);
      }
    }
    return null;
  }

  static Map<String, dynamic>? _convertYamlMap(Map? yamlMap) {
    if (yamlMap == null) return null;
    final map = <String, dynamic>{};
    for (final key in yamlMap.keys) {
      final value = yamlMap[key];
      if (value is YamlMap) {
        map[key.toString()] = _convertYamlMap(value);
      } else if (value is YamlList) {
        map[key.toString()] = value.map((e) => e.toString()).toList();
      } else {
        map[key.toString()] = value;
      }
    }
    return map;
  }
}
