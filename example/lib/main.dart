import 'package:flutter/material.dart';
import 'package:flutter_splash_studio/flutter_splash_studio.dart';

void main() {
  // 1. Preserve the native splash screen while Flutter engine initializes.
  // This prevents the dreaded "white flash".
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterSplashStudio.preserve(widgetsBinding: widgetsBinding);

  runApp(const CompleteExampleApp());
}

class CompleteExampleApp extends StatelessWidget {
  const CompleteExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Studio Complete Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      // Set the SplashStudio widget as the initial route
      home: SplashStudio(
        // Customization
        title: "My Production App",
        animation: SplashAnimation.particles, // 20+ animations available
        duration: const Duration(seconds: 3),
        showLoader: true,
        enableGlassmorphism: true,
        blurAmount: 10.0,
        
        // Asynchronous Initialization
        onInit: () async {
          // Simulate loading data, initializing Firebase, etc.
          debugPrint("Initializing app resources...");
          await Future.delayed(const Duration(seconds: 2));
          
          // Once the app is ready to render the Flutter splash,
          // remove the native OS splash screen.
          FlutterSplashStudio.remove();
          debugPrint("App resources loaded!");
        },

        // Navigation
        autoNavigate: true,
        nextPage: const HomeScreen(),
      ),
    );
  }
}

/// The main home screen of the application.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 100, color: Colors.green),
            const SizedBox(height: 24),
            const Text(
              'App Initialized Successfully!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('The native splash transitioned into the runtime splash,'),
            const Text('and finally routed here.'),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to the visual editor to test configurations
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const VisualEditorPage()),
                );
              },
              icon: const Icon(Icons.palette),
              label: const Text('Open Visual Editor Demo'),
            ),
          ],
        ),
      ),
    );
  }
}

/// A Visual Editor that allows developers to test different splash configs dynamically.
class VisualEditorPage extends StatefulWidget {
  const VisualEditorPage({super.key});

  @override
  State<VisualEditorPage> createState() => _VisualEditorPageState();
}

class _VisualEditorPageState extends State<VisualEditorPage> {
  SplashTemplate? _selectedTemplate;
  SplashAnimation _selectedAnimation = SplashAnimation.fade;
  bool _showSplash = false;

  void _previewSplash() {
    setState(() {
      _showSplash = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // If previewing, show the SplashStudio widget
    if (_showSplash) {
      return SplashStudio(
        template: _selectedTemplate,
        animation: _selectedAnimation,
        duration: const Duration(seconds: 3),
        title: _selectedTemplate == null ? "My Custom App" : null,
        autoNavigate: true,
        nextPage: const VisualEditorPage(), // Loop back to editor
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Splash Studio Editor'),
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
      body: Row(
        children: [
          // Configuration Panel
          Expanded(
            flex: 1,
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  const Text('Configuration', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Divider(),
                  
                  const Text('Template', style: TextStyle(fontWeight: FontWeight.w600)),
                  DropdownButton<SplashTemplate?>(
                    value: _selectedTemplate,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: null, child: Text('Custom Config')),
                      DropdownMenuItem(value: SplashTemplate.hotstar, child: Text('Hotstar Style')),
                      DropdownMenuItem(value: SplashTemplate.netflix, child: Text('Netflix Style')),
                    ],
                    onChanged: (val) => setState(() => _selectedTemplate = val),
                  ),
                  const SizedBox(height: 16),

                  if (_selectedTemplate == null) ...[
                    const Text('Animation Engine', style: TextStyle(fontWeight: FontWeight.w600)),
                    DropdownButton<SplashAnimation>(
                      value: _selectedAnimation,
                      isExpanded: true,
                      items: SplashAnimation.values.map((anim) {
                        return DropdownMenuItem(
                          value: anim,
                          child: Text(anim.name),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedAnimation = val);
                      },
                    ),
                  ],

                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _previewSplash,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Preview Splash Screen'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Preview Placeholder
          Expanded(
            flex: 2,
            child: Container(
              color: Theme.of(context).colorScheme.background,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone_android, size: 80, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 16),
                    const Text(
                      'Preview Area',
                      style: TextStyle(fontSize: 24),
                    ),
                    const Text(
                      'Click "Preview Splash Screen" to run.',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
