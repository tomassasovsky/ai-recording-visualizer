import 'package:ai_recording_visualizer/environments/environments.dart';
import 'package:secure_dotenv/secure_dotenv.dart';

part 'development_environment.g.dart';

@DotEnvGen(filename: '.env/.env.development')
abstract class DevelopmentEnvironment with Environment {
  // factory to init the generated class
  const factory DevelopmentEnvironment(String encryptionKey, String iv) =
      _$DevelopmentEnvironment;

  // an empty constructor is required
  const DevelopmentEnvironment._();
}
