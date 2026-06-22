# Flutter Splash Studio 🎬

The most advanced splash screen package available for Flutter. 
Build beautiful, theme-aware, highly animated programmatic splash screens and generate native boot screens all from one package.

## Features

✨ **20+ Animation Engines**: Fade, Scale, Slide, Bounce, Particles, Ripple, and more.  
🎨 **Prebuilt Templates**: Hotstar, Netflix, Google, YouTube, Instagram inspired styles.  
📱 **Native Generation**: CLI tool to generate native boot screens for Android, iOS, and Web (Architecture implemented, fully coming soon).  
🌗 **Theme Aware**: Automatically uses Material 3 ColorScheme and supports dark/light mode switching seamlessly.  
🎛️ **Visual Editor**: Included example app features a live visual editor to test configurations instantly.  

## Installation

Add it to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_splash_studio: ^0.0.1
```

## Quick Start (Runtime Widget)

Use `SplashStudio` as the initial route of your application to show beautiful animated splash screens.

### Using a Prebuilt Template

```dart
import 'package:flutter_splash_studio/flutter_splash_studio.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashStudio(
        template: SplashTemplate.netflix,
        duration: const Duration(seconds: 4),
        autoNavigate: true,
        nextPage: const HomeScreen(),
      ),
    );
  }
}
```

### Custom Animation with your Logo

```dart
import 'package:flutter_splash_studio/flutter_splash_studio.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashStudio(
        logo: const AssetImage('assets/logo.png'),
        title: 'My Awesome App',
        animation: SplashAnimation.particles,
        duration: const Duration(seconds: 3),
        autoNavigate: true,
        nextPage: const HomeScreen(),
      ),
    );
  }
}
```

## Native Splash Generation (CLI)

You can generate the native boot splash (the screen shown before the Flutter engine loads) by creating a `flutter_splash_studio.yaml` config file:

```yaml
color: "#FFFFFF"
image: "assets/splash.png"
android_12:
  image: "assets/splash_android12.png"
```

Then run:
```bash
dart run flutter_splash_studio:create
```

### Preserving the Native Splash Screen

Like `flutter_native_splash`, you can preserve the native splash screen until your app is fully ready. This ensures a seamless transition to your app.

```dart
import 'package:flutter_splash_studio/flutter_splash_studio.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterSplashStudio.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

// Later, when your app is ready (e.g., after API calls):
FlutterSplashStudio.remove();
```

## Running the Live Visual Editor

To try out all animations and templates, run the included example project:

```bash
cd example
flutter run
```
