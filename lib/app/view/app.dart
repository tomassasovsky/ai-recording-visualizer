import 'package:ai_recording_visualizer/file_loader/view/file_loader_page.dart';
import 'package:ai_recording_visualizer/l10n/l10n.dart';
import 'package:ai_recording_visualizer/video/video.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      initialRoute: '/file-loader',
      routes: {
        '/file-loader': (context) => const FileLoaderPage(),
        '/video-player': (context) => const VideoPage(),
      },
    );
  }
}
