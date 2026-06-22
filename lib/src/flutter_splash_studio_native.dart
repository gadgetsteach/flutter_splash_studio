import 'package:flutter/widgets.dart';

/// A utility class for interacting with the native splash screen.
/// Similar to `flutter_native_splash`, this can be used to hold the native splash screen
/// on screen until the Flutter engine and your app are fully initialized.
class FlutterSplashStudio {
  /// Preserves the native splash screen until [remove] is called.
  /// 
  /// You must pass the [WidgetsBinding] instance, which is usually obtained
  /// by calling `WidgetsFlutterBinding.ensureInitialized()`.
  /// 
  /// Example:
  /// ```dart
  /// WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  /// FlutterSplashStudio.preserve(widgetsBinding: widgetsBinding);
  /// ```
  static void preserve({required WidgetsBinding widgetsBinding}) {
    widgetsBinding.deferFirstFrame();
  }

  /// Removes the native splash screen.
  /// 
  /// Call this when your app is ready to render its first frame.
  /// 
  /// Example:
  /// ```dart
  /// FlutterSplashStudio.remove();
  /// ```
  static void remove() {
    WidgetsBinding.instance.allowFirstFrame();
  }
}
