# Flutter Splash Studio 🎬

Build the most advanced splash screen package available for Flutter with visual editor support, Material 3 design system integration, custom animations, theme-aware splash screens, and prebuilt templates similar to apps like Disney+ Hotstar, Netflix, and Google.

`flutter_splash_studio` is a complete end-to-end solution. It handles the **Native Launch Screen** (the screen shown by Android/iOS before Flutter loads) AND provides a highly customizable **Runtime Splash Widget** for complex animations and routing.

## ✨ Core Features

* **Native Splash Generation**: CLI tool to configure Android/iOS native splash screens.
* **Runtime Splash Screen Widget**: Highly customizable `SplashStudio` widget.
* **20+ Animation Engines**: Fade, Scale, Slide, Bounce, Particles, Ripple, Confetti, and more.
* **Prebuilt Templates**: Hotstar, Netflix, Google, YouTube inspired styles.
* **Theme-Aware**: Automatically uses Material 3 `ColorScheme` for Light/Dark mode.
* **Advanced Effects**: Glassmorphism, Background Blur, Particles, Custom Loaders.
* **Async Initialization**: Built-in support for awaiting API calls before navigating.

---

## 🚀 1. Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_splash_studio: ^0.0.1
```

Run:
```bash
flutter pub get
```

---

## ⚙️ 2. Native Splash Screen Setup (CLI)

To configure the *native* splash screen (the very first screen shown by the OS), create a configuration file named `flutter_splash_studio.yaml` in the root of your project:

```yaml
# flutter_splash_studio.yaml
color: "#FFFFFF"
image: "assets/splash.png"
```

Then, run the generator:
```bash
dart run flutter_splash_studio:create
```

This will automatically generate the required XML and Plist files for Android and iOS.

### Preserving the Native Splash Screen

To ensure a seamless transition from the native boot screen to your Flutter app without a white flash, preserve the native splash screen until your app is fully initialized.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_splash_studio/flutter_splash_studio.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  
  // Hold the native splash screen visible
  FlutterSplashStudio.preserve(widgetsBinding: widgetsBinding);
  
  runApp(const MyApp());
}
```

---

## 🎨 3. Runtime Splash Widget (Usage)

Once Flutter has loaded, you can display a beautifully animated programmatic splash screen. Set `SplashStudio` as the `home` or initial route of your app.

### Example A: Basic Custom Splash

```dart
import 'package:flutter/material.dart';
import 'package:flutter_splash_studio/flutter_splash_studio.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashStudio(
        logo: const AssetImage('assets/logo.png'),
        title: 'My Awesome App',
        animation: SplashAnimation.particles, // 20+ animations available!
        duration: const Duration(seconds: 3),
        autoNavigate: true,
        nextPage: const HomeScreen(), // Where to go next
      ),
    );
  }
}
```

### Example B: Prebuilt Templates

Want your app to look like a top-tier production app immediately? Use a template!

```dart
SplashStudio(
  template: SplashTemplate.netflix, // Or .hotstar, .youtube, etc.
  duration: const Duration(seconds: 4),
  autoNavigate: true,
  nextPage: const HomeScreen(),
)
```

### Example C: Async Initialization (API Calls)

You can pass a Future to `onInit`. The splash screen will wait for *both* the animation `duration` and the `onInit` future to complete before navigating.

```dart
SplashStudio(
  logo: const AssetImage('assets/logo.png'),
  animation: SplashAnimation.fade,
  onInit: () async {
    // Fetch data, initialize Firebase, check auth status, etc.
    await Future.delayed(const Duration(seconds: 2));
    // FlutterSplashStudio.remove() can also be called here!
    FlutterSplashStudio.remove(); 
  },
  autoNavigate: true,
  nextPage: const HomeScreen(),
)
```

---

## 🛠️ 4. Configuration Properties

`SplashStudio` is highly customizable. Here are the core properties you can override:

| Property | Type | Description |
|---|---|---|
| `template` | `SplashTemplate?` | Overrides styling with a prebuilt layout (e.g. Netflix). |
| `animation` | `SplashAnimation` | The entrance animation type (Fade, Scale, Particles, Ripple, etc). |
| `duration` | `Duration` | Minimum time the splash screen will be shown. |
| `onInit` | `Future Function()?` | Async function to run while splash is displaying. |
| `autoNavigate` | `bool` | If true, automatically routes to `nextPage` when done. |
| `nextPage` | `Widget?` | The screen to route to. |
| `logo` | `ImageProvider?` | The central logo image. |
| `title` | `String?` | The text below the logo. |
| `backgroundColor` | `Color?` | Custom background color (defaults to Theme Surface). |
| `backgroundGradient`| `Gradient?` | Custom gradient background. |
| `enableGlassmorphism`| `bool` | Applies a translucent frosted glass effect to the container. |
| `blurAmount` | `double?` | The intensity of the glassmorphism blur. |
| `showLoader` | `bool` | Shows a loading indicator below the logo. |

---

## 📱 5. Live Visual Editor

This package ships with a **Live Visual Editor**! You can test all templates, animations, and color schemes dynamically.

To use it, simply run the `example` project included in this repository:

```bash
cd example
flutter run
```

---

## 📜 License

MIT License. See LICENSE file for details.
