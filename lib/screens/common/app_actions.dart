import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';

List<Widget> buildGlobalAppActions(BuildContext context) {
  final provider = context.watch<AppProvider>();
  final isDark = provider.themeMode == ThemeMode.dark;

  return [
    IconButton(
      icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
      onPressed: () {
        provider.switchThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
      },
      tooltip: 'Toggle Theme',
    ),
    PopupMenuButton<String>(
      icon: const Icon(Icons.language),
      onSelected: (val) => provider.switchLocale(Locale(val)),
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'en', child: Text('English')),
        const PopupMenuItem(value: 'ja', child: Text('日本語')),
      ],
    ),
  ];
}
