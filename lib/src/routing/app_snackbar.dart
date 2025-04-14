import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global key for accessing the ScaffoldMessenger from anywhere in the app.
final scaffoldMessengerKeyProvider =
    Provider<GlobalKey<ScaffoldMessengerState>>(
  (ref) => GlobalKey<ScaffoldMessengerState>(
      debugLabel: 'global_scaffold_messenger'),
);

/// Snackbar provider to show snackbars from anywhere in the app.
final snackbarProvider = Provider<_SnackbarService>(
  (ref) {
    final service = _SnackbarService(ref.read(scaffoldMessengerKeyProvider));
    return service;
  },
);

class _SnackbarService {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey;

  _SnackbarService(this._scaffoldMessengerKey);

  void showSnackbar({
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    final messenger = _scaffoldMessengerKey.currentState;
    if (messenger != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration,
          action: action,
        ),
      );
    }
  }
}
