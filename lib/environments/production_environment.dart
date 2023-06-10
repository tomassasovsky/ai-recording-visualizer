import 'package:ai_recording_visualizer/environments/environments.dart';
import 'package:dotenv_gen/dotenv_gen.dart';

part 'production_environment.g.dart';

@DotEnvGen(filename: '.env/.env.production')
abstract class ProductionEnvironment with Environment {
  // factory to init the generated class
  const factory ProductionEnvironment(String encryptionKey) =
      _$ProductionEnvironment;

  // an empty constructor is required
  const ProductionEnvironment._();
}
