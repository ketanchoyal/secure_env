import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../routing/app_router.dart';

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
        case 1: // Settings (Placeholder)
          // TODO: Implement settings route
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Settings route not implemented yet.')),
          );
          // context.go(AppRoutes.settings); // Uncomment when settings route exists
          break;
        // Add more cases for other destinations
      }
    }

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            labelType: NavigationRailLabelType.all, // Show labels
            groupAlignment: -0.85, // Align items towards the top
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: FaIcon(FontAwesomeIcons.tableColumns), // Use FontAwesome
                selectedIcon: FaIcon(FontAwesomeIcons.tableColumns), // Keep consistent
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: FaIcon(FontAwesomeIcons.gear), // Use FontAwesome
                selectedIcon: FaIcon(FontAwesomeIcons.gear), // Keep consistent
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
