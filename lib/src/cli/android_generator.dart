import 'dart:io';

import 'package:flutter/foundation.dart';

class AndroidGenerator {
  static Future<void> generate(Map<String, dynamic> config) async {
    final String color = config['color'] ?? '#FFFFFF';
    final String? imagePath = config['image'];

    // 1. Create colors.xml
    final colorsXml = '''<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="splash_color">$color</color>
</resources>
''';

    final colorsDir = Directory('android/app/src/main/res/values');
    if (!await colorsDir.exists()) {
      await colorsDir.create(recursive: true);
    }
    await File('${colorsDir.path}/colors.xml').writeAsString(colorsXml);

    // 2. Copy image if provided
    String drawableItem = '';
    if (imagePath != null) {
      final imageFile = File(imagePath);
      if (await imageFile.exists()) {
        final drawableDir = Directory('android/app/src/main/res/drawable');
        if (!await drawableDir.exists()) {
          await drawableDir.create(recursive: true);
        }
        
        // Simple copy. In a production package, we'd scale this to mdpi, hdpi, etc.
        final destination = '${drawableDir.path}/splash.png';
        await imageFile.copy(destination);
        
        drawableItem = '''
    <item>
        <bitmap android:gravity="center" android:src="@drawable/splash" />
    </item>''';
      } else {
        if (kDebugMode) {
          print('⚠️ Warning: Image file not found at $imagePath');
        }
      }
    }

    // 3. Create launch_background.xml
    final launchBackgroundXml = '''<?xml version="1.0" encoding="utf-8"?>
<!-- Modify this file to customize your launch splash screen -->
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="@color/splash_color" />$drawableItem
</layer-list>
''';

    final drawableDir = Directory('android/app/src/main/res/drawable');
    if (!await drawableDir.exists()) {
      await drawableDir.create(recursive: true);
    }
    await File('${drawableDir.path}/launch_background.xml').writeAsString(launchBackgroundXml);
  }
}
