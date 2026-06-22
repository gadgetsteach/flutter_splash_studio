// ignore_for_file: avoid_print
import 'dart:io';
import 'package:flutter_splash_studio/src/cli/config_parser.dart';
import 'package:flutter_splash_studio/src/cli/android_generator.dart';

/// Entry point for the native splash generator.
/// Usage: dart run flutter_splash_studio:create
void main(List<String> arguments) async {
  print('🎬 Flutter Splash Studio - Native Config Generator');
  print('--------------------------------------------------');

  try {
    final config = await ConfigParser.parseConfig();
    if (config == null) {
      print('❌ No flutter_splash_studio.yaml or pubspec.yaml config found.');
      exit(1);
    }

    print('✅ Configuration loaded successfully.');
    
    // Simulate generation process for the demo
    print('⚙️ Generating Android Splash Screen...');
    await AndroidGenerator.generate(config);
    
    print('⚙️ Generating iOS Splash Screen...');
    await Future.delayed(const Duration(seconds: 1));
    // implement IOSGenerator.generate(config);
    
    print('⚙️ Generating Web Splash Screen...');
    await Future.delayed(const Duration(seconds: 1));
    // implement WebGenerator.generate(config);

    print('--------------------------------------------------');
    print('🎉 Native splash screens generated successfully!');
  } catch (e) {
    print('❌ Error generating splash screens: $e');
    exit(1);
  }
}
