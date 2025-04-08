import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import '../../../routing/app_router.dart'; // For GoRouter access

/// Shows a standardized WoltModalSheet for the application.
///
/// Parameters:
/// - [context]: The build context.
/// - [ref]: WidgetRef for accessing providers (like GoRouter).
/// - [title]: The title displayed in the modal's top bar.
/// - [pageContent]: The main widget to display as the modal's content.
/// - [onPrimaryAction]: The callback function to execute when the primary action
///   button (e.g., 'Save', 'Import', 'Add') is pressed. Typically involves
///   validating and saving form data. Return true from the callback if the
///   modal should be popped automatically after the action, false otherwise.
/// - [primaryActionText]: The text for the primary action button (defaults to 'Save').
/// - [isPrimaryActionEnabledProvider]: Optional provider to dynamically enable/disable the primary action button.
/// - [hasSabGradient]: Controls the gradient visibility on the sticky action bar.
/// - [isTopBarLayerAlwaysVisible]: Controls top bar visibility.
/// - [pagePadding]: Padding around the [pageContent]. Defaults handle common cases.
void showAppModalSheet({
  required BuildContext context,
  required WidgetRef ref,
  required String title,
  required Widget pageContent,
  required Future<bool> Function()?
  onPrimaryAction, // Make async, return bool to control pop
  String primaryActionText = 'Save',
  Provider<bool>?
  isPrimaryActionEnabledProvider, // Optional provider for enabling button

  bool hasSabGradient = false,
  bool isTopBarLayerAlwaysVisible = true,
  EdgeInsets pagePadding = const EdgeInsets.fromLTRB(
    16,
    16,
    16,
    96,
  ), // Default padding
}) {
  WoltModalSheet.show<void>(
    context: context,
    // Use a Consumer to react to the isPrimaryActionEnabledProvider
    pageListBuilder: (modalSheetContext) {
      // Use a WoltModalSheetPage ancestor to properly access Theme data

      return [
        WoltModalSheetPage(
          hasSabGradient: hasSabGradient,
          isTopBarLayerAlwaysVisible: isTopBarLayerAlwaysVisible,

          // Standardized Top Bar Title
          topBarTitle: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: Theme.of(modalSheetContext).textTheme.titleLarge,
            ),
          ),

          // Standardized Sticky Action Bar
          stickyActionBar: Builder(
            builder: (actionBarContext) {
              // Create the action button row with optional Consumer wrapper
              Widget buildActionButtons({bool? isEnabled}) {
                // If isEnabled is null, only onPrimaryAction determines enabled state
                final isPrimaryEnabled = isEnabled ?? true;

                return Row(
                  children: [
                    // Cancel button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => ref.read(goRouterProvider).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Primary action button
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            (isPrimaryEnabled && onPrimaryAction != null)
                                ? () async {
                                  bool shouldPop = await onPrimaryAction();
                                  if (shouldPop && actionBarContext.mounted) {
                                    ref.read(goRouterProvider).pop();
                                  }
                                }
                                : null,
                        child: Text(primaryActionText),
                      ),
                    ),
                  ],
                );
              }

              // Wrap with Consumer if provider exists
              Widget buttonsRow =
                  isPrimaryActionEnabledProvider != null
                      ? Consumer(
                        builder: (context, consumerRef, _) {
                          final isEnabled = consumerRef.watch(
                            isPrimaryActionEnabledProvider,
                          );
                          return buildActionButtons(isEnabled: isEnabled);
                        },
                      )
                      : buildActionButtons();

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: buttonsRow,
              );
            },
          ),

          // Main Content Area
          child: Padding(
            padding: pagePadding,
            child: SingleChildScrollView(child: pageContent),
          ),
        ),
      ];
    },
    onModalDismissedWithBarrierTap: () {
      ref
          .read(goRouterProvider)
          .pop(); // Also pop using GoRouter on barrier tap
    },
    // Potentially add useRootNavigator: true if issues arise with nested navigators
  );
}
