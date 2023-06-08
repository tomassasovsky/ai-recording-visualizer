import 'dart:async';

import 'package:ai_recording_visualizer/firebase_options.dart';
import 'package:firebase_dart/firebase_dart.dart';
import 'package:firebase_dart/implementation/pure_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:platform_info/platform_info.dart' as platform_info;
import 'package:url_launcher/url_launcher.dart';

class FirebaseHandler {
  static const _channel = MethodChannel('firebase_dart_flutter');

  static Future<void> setup(
    DotEnv dotEnv, {
    bool isolate = !kIsWeb,
  }) async {
    final isolated = isolate && !kIsWeb;
    WidgetsFlutterBinding.ensureInitialized();

    String? path;
    if (!kIsWeb) {
      final appDir = await getApplicationDocumentsDirectory();
      path = appDir.path;
    }

    FirebaseDart.setup(
      storagePath: path,
      isolated: isolated,
      launchUrl: kIsWeb
          ? null
          : (url, {bool popup = false}) async {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            },
      platform: await _getPlatform(),
    );

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform(dotEnv),
    );
  }

  static Future<Platform> _getPlatform() async {
    final p = platform_info.Platform.instance;

    if (kIsWeb) {
      return Platform.web(
        currentUrl: Uri.base.toString(),
        isMobile: p.isMobile,
        // ignore: avoid_redundant_argument_values
        isOnline: true,
      );
    }

    switch (p.operatingSystem) {
      case platform_info.OperatingSystem.android:
        final i = await PackageInfo.fromPlatform();
        return Platform.android(
          isOnline: true,
          packageId: i.packageName,
          sha1Cert: (await _channel.invokeMethod<String>('getSha1Cert'))!,
        );
      case platform_info.OperatingSystem.iOS:
        final i = await PackageInfo.fromPlatform();
        return Platform.ios(
          isOnline: true,
          appId: i.packageName,
        );
      case platform_info.OperatingSystem.macOS:
        final i = await PackageInfo.fromPlatform();
        return Platform.macos(
          isOnline: true,
          appId: i.packageName,
        );
      case platform_info.OperatingSystem.linux:
        return Platform.linux(
          isOnline: true,
        );
      case platform_info.OperatingSystem.windows:
        return Platform.windows(
          isOnline: true,
        );
      case platform_info.OperatingSystem.fuchsia:
      case platform_info.OperatingSystem.unknown:
        throw UnsupportedError('Unsupported platform: ${p.operatingSystem}');
    }
  }
}
