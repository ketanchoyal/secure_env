import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/project.dart';
import '../services/project_service.dart';

/// Provider for the ProjectService
final projectServiceProvider = Provider<ProjectService>((ref) {
  return ProjectService();
});

/// Provider for the list of projects
final projectListProvider = FutureProvider<List<Project>>((ref) async {
  final service = ref.watch(projectServiceProvider);
  return service.listProjects();
});
