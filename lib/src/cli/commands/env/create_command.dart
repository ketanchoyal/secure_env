import '../../../core/services/environment_service.dart';
import '../base_command.dart';

/// Command to create a new environment
class CreateCommand extends BaseCommand {
  CreateCommand({
    required super.logger,
    required this.environmentService,
  }) {
    argParser
      ..addOption(
        'project',
        abbr: 'p',
        help: 'Project name',
        mandatory: true,
      )
      ..addOption(
        'description',
        abbr: 'd',
        help: 'Environment description',
      )
      ..addOption(
        'template',
        abbr: 't',
        help: 'Template to use for initial values',
      );
  }

  final EnvironmentService environmentService;

  @override
  String get description => 'Create a new environment';

  @override
  String get name => 'create';

  @override
  Future<int> run() => handleErrors(() async {
        final projectName = argResults!['project'] as String;
        final description = argResults!['description'] as String?;
        final template = argResults!['template'] as String?;

        if (argResults!.rest.isEmpty) {
          throw const FormatException('Environment name is required');
        }

        final envName = argResults!.rest.first;

        // Check if environment already exists
        final existingEnv = await environmentService.loadEnvironment(
          name: envName,
          projectName: projectName,
        );

        if (existingEnv != null) {
          throw 'Environment already exists: $envName';
        }

        Map<String, String>? initialValues;
        if (template != null) {
          // Load values from template
          final templateEnv = await environmentService.loadEnvironment(
            name: template,
            projectName: projectName,
          );

          if (templateEnv == null) {
            throw 'Template environment not found: $template';
          }

          initialValues = Map.from(templateEnv.values);
        }

        final env = await environmentService.createEnvironment(
          name: envName,
          projectName: projectName,
          description: description,
          initialValues: initialValues,
        );

        logger.success('Created environment: ${env.name}');
        if (env.description != null) {
          logger.info('Description: ${env.description}');
        }

        return BaseCommand.successExitCode;
      });
}
