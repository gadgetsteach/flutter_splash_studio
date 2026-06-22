import 'package:flutter/material.dart';
import 'package:flutter_splash_studio/flutter_splash_studio.dart';

void main() {
  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Studio Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const VisualEditorPage(),
    );
  }
}

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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Row(
        children: [
          // Editor Panel
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey.shade100,
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  const Text('Configuration', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Divider(),
                  
                  const Text('Template', style: TextStyle(fontWeight: FontWeight.w600)),
                  DropdownButton<SplashTemplate?>(
                    value: _selectedTemplate,
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Custom')),
                      const DropdownMenuItem(value: SplashTemplate.hotstar, child: Text('Hotstar Style')),
                      const DropdownMenuItem(value: SplashTemplate.netflix, child: Text('Netflix Style')),
                    ],
                    onChanged: (val) {
                      setState(() {
                        _selectedTemplate = val;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  if (_selectedTemplate == null) ...[
                    const Text('Animation', style: TextStyle(fontWeight: FontWeight.w600)),
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
                        if (val != null) {
                          setState(() {
                            _selectedAnimation = val;
                          });
                        }
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
          
          // Preview Panel Placeholder
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.phone_android, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Preview Area',
                    style: TextStyle(fontSize: 24, color: Colors.grey),
                  ),
                  const Text(
                    'Click "Preview Splash Screen" to run.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
