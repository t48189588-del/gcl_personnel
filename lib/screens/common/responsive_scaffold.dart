import 'package:flutter/material.dart';

class ResponsiveScaffold extends StatelessWidget {
  final Widget? appBar;
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<NavigationRailDestination> railDestinations;
  final List<NavigationDestination> bottomDestinations;

  const ResponsiveScaffold({
    super.key,
    this.appBar,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.railDestinations,
    required this.bottomDestinations,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 800) {
          return Scaffold(
            appBar: appBar as PreferredSizeWidget?,
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: onDestinationSelected,
                  labelType: NavigationRailLabelType.all,
                  destinations: railDestinations,
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: body),
              ],
            ),
          );
        } else {
          return Scaffold(
            appBar: appBar as PreferredSizeWidget?,
            body: body,
            bottomNavigationBar: NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              destinations: bottomDestinations,
            ),
          );
        }
      },
    );
  }
}
