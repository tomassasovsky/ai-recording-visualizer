import 'package:ai_recording_visualizer/environments/environments.dart';
import 'package:flutter/foundation.dart';

EnvironmentMixin get environment =>
    kDebugMode ? const DevelopmentEnvironment() : const ProductionEnvironment();
