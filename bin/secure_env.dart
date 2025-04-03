import 'dart:io';
import 'package:secure_env/src/cli/secure_env_runner.dart';

Future<void> main(List<String> args) async {
  final exitCode = await SecureEnvRunner().run(args);
  exit(exitCode);
}
