import 'package:ai_recording_visualizer/environments/environments.dart';
import 'package:flutter/foundation.dart';

Environment get environment => kDebugMode
    ? const DevelopmentEnvironment(String.fromEnvironment('ENCRYPTION_KEY'))
    : const ProductionEnvironment(String.fromEnvironment('ENCRYPTION_KEY'));
