import 'dart:io';
import '../src/cli/secure_env_runner.dart';
import 'package:secure_env_core/secure_env_core.dart';
import '../src/utils/mason_logger_adapter.dart';

Future<void> main(List<String> args) async {
  final environmentService = EnvironmentService(
    logger: MasonLoggerAdapter(),
  );
  final runner = SecureEnvRunner(
    environmentService: environmentService,
  );
  final exitCode = await runner.run(args);
  exit(exitCode);
}
