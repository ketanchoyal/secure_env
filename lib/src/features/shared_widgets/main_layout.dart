import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../routing/app_router.dart';

// Provider to manage the selected navigation index
final selectedNavIndexProvider = StateProvider<int>((ref) => 0);

// Define NavigationRail widths
const double _extendedRailWidth = 200;

class MainLayout extends ConsumerWidget {
  final Widget child; // The screen content to display

  const MainLayout({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedNavIndexProvider);
    final goRouter = ref.read(goRouterProvider);

    // Function to handle navigation rail item taps
    void onDestinationSelected(int index) {
      ref.read(selectedNavIndexProvider.notifier).state = index;
      switch (index) {
        case 0: // Dashboard
          goRouter.go(AppRoutes.dashboard);
          break;
        case 1: // Settings
          goRouter.go(AppRoutes.settings);
          break;
        // Add more cases for other destinations
      }
    }

    final isSmallScreen = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      body: Row(
        children: [
          Column(
            children: [
              Flexible(
                child: NavigationRail(
                  minExtendedWidth: _extendedRailWidth,
                  extended: !isSmallScreen,
                  unselectedLabelTextStyle:
                      Theme.of(context).textTheme.bodySmall,
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
              ),
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
