import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'providers/app_provider.dart';
import 'services/hive_service.dart';
import 'screens/common/role_gate_screen.dart';
import 'theme/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize local storage
  await HiveService.init();
  
  await dotenv.load(fileName: ".env"); // Load API keys before app starts

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppProvider()..loadData(),
        ),
      ],
      child: const GCLPersonnelApp(),
    ),
  );
}

class GCLPersonnelApp extends StatelessWidget {
  const GCLPersonnelApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return MaterialApp(
      title: 'GCL Personnel Ledger',
      debugShowCheckedModeBanner: false,
      locale: provider.locale,
      themeMode: provider.themeMode,
      theme: AppTheme.seniorTheme, 
      darkTheme: AppTheme.darkTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ja'),
      ],
      home: const RoleGateScreen(),
    );
  }
}
