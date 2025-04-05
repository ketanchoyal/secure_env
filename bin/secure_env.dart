import 'dart:io';
import 'package:secure_env/src/cli/secure_env_runner.dart';
import 'package:secure_env/src/core/services/environment_service.dart';

Future<void> main(List<String> args) async {
  final environmentService = EnvironmentService();
  final runner = SecureEnvRunner(environmentService: environmentService);
  final exitCode = await runner.run(args);
  exit(exitCode);
}
