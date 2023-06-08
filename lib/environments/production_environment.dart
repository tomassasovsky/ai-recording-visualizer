// ignore_for_file: non_constant_identifier_names
import 'package:ai_recording_visualizer/environments/environments.dart';
import 'package:dotenv_gen/dotenv_gen.dart';

part 'production_environment.g.dart';

@DotEnvGen(filename: '.env/.env.production')
abstract class ProductionEnvironment with EnvironmentMixin {
  // factory to init the generated class
  const factory ProductionEnvironment() = _$ProductionEnvironment;

  // an empty constructor is required
  const ProductionEnvironment._();

  @override
  String get FIREBASE_WEB_API_KEY;
  @override
  String get FIREBASE_WEB_APP_ID;
  @override
  String get FIREBASE_ANDROID_API_KEY;
  @override
  String get FIREBASE_ANDROID_APP_ID;
  @override
  String get FIREBASE_IOS_API_KEY;
  @override
  String get FIREBASE_IOS_APP_ID;
  @override
  String get FIREBASE_IOS_CLIENT_ID;
  @override
  String get FIREBASE_MACOS_API_KEY;
  @override
  String get FIREBASE_MACOS_APP_ID;
  @override
  String get FIREBASE_MACOS_CLIENT_ID;
  @override
  String get FIREBASE_WINDOWS_API_KEY;
  @override
  String get FIREBASE_WINDOWS_APP_ID;
  @override
  String get FIREBASE_LINUX_API_KEY;
  @override
  String get FIREBASE_LINUX_APP_ID;
  @override
  String get FIREBASE_FUCHSIA_API_KEY;
  @override
  String get FIREBASE_FUCHSIA_APP_ID;
  @override
  String get FIREBASE_MESSAGING_SENDER_ID;
  @override
  String get FIREBASE_PROJECT_ID;
  @override
  String get FIREBASE_MEASUREMENT_ID;
}
