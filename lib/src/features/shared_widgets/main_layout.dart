import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../routing/app_router.dart';
import 'package:secure_env_gui/src/features/settings/settings_screen.dart';

// Provider to manage the selected navigation index
final selectedNavIndexProvider = StateProvider<int>((ref) => 0);

class MainLayout extends ConsumerWidget {
  final Widget child; // The screen content to display

  const MainLayout({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedNavIndexProvider);

    // Function to handle navigation rail item taps
    void onDestinationSelected(int index) {
      ref.read(selectedNavIndexProvider.notifier).state = index;
      switch (index) {
        case 0: // Dashboard
          context.go(AppRoutes.dashboard);
          break;
        case 1: // Settings
          context.go(AppRoutes.settings);
          break;
        // Add more cases for other destinations
      }
    }

    final isSmallScreen = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            minExtendedWidth: 200,
            extended: !isSmallScreen,
            unselectedLabelTextStyle: Theme.of(context).textTheme.bodySmall,
            selectedLabelTextStyle:
                Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            labelType: NavigationRailLabelType.none, // Show labels
            groupAlignment: -0.85, // Align items towards the top
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                padding: EdgeInsets.all(2),
                icon: FaIcon(
                  FontAwesomeIcons.tableColumns,
                  size: 18,
                ), // Use FontAwesome
                selectedIcon: FaIcon(
                  FontAwesomeIcons.tableColumns,
                  size: 20,
                ), // Keep consistent
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(
                  FontAwesomeIcons.gear,
                  size: 18,
                ),
                selectedIcon: Icon(
                  FontAwesomeIcons.gear,
                  size: 20,
                ),
                label: Text('Settings'),
              ),
              // Add more destinations here
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // Main content area
          Expanded(
            child: child, // Display the routed screen content
          ),
        ],
      ),
    );
  }
}
