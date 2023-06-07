import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

enum DotEnvFlavour {
  development('.env/.env.development'),
  production('.env/.env.production');

  const DotEnvFlavour(this.path);

  final String path;
  Future<void> initialize() async {
    dotenv = DotEnv();
    return dotenv
        .load(fileName: path, mergeWith: Platform.environment)
        .then((value) => dotEnvFlavour = this);
  }

  DotEnv get dotEnv => dotenv;
}

late DotEnvFlavour dotEnvFlavour;
