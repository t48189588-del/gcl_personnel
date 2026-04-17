import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';
import 'app_actions.dart';
import '../senior/senior_dashboard.dart';
import '../junior/junior_dashboard.dart';
import '../developer/developer_dashboard.dart';

class RoleGateScreen extends StatelessWidget {
  const RoleGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final loc = AppLocalizations.of(context)!;
    final isDark = provider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.appTitle),
        actions: buildGlobalAppActions(context),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                loc.appTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                loc.selectYourRole,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 50),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 40,
                runSpacing: 40,
                children: [
                   _RoleCard(
                    title: loc.seniorStaff,
                    icon: Icons.admin_panel_settings,
                    color: const Color(0xFF2C3E50),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Theme(
                            data: isDark ? AppTheme.darkTheme : AppTheme.seniorTheme,
                            child: const SeniorDashboard(),
                          ),
                        ),
                      );
                    },
                  ),
                  _RoleCard(
                    title: loc.juniorStaff,
                    icon: Icons.person,
                    color: const Color(0xFF3498DB),
                    onTap: () {
                      _showJuniorPickDialog(context, provider, loc, isDark);
                    },
                  ),
                  _RoleCard(
                    title: loc.developer,
                    icon: Icons.code,
                    color: Colors.green.shade800,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Theme(
                            data: isDark ? AppTheme.darkTheme : ThemeData.light(),
                            child: const DeveloperDashboard(),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showJuniorPickDialog(BuildContext context, AppProvider provider, AppLocalizations loc, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Junior Profile'),
        content: SizedBox(
          width: 300,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: provider.staff.length,
            itemBuilder: (context, index) {
              final s = provider.staff[index];
              if (s.isSenior) return const SizedBox.shrink();
              return ListTile(
                leading: CircleAvatar(child: Text(s.name[0])),
                title: Text(s.name),
                subtitle: Text(s.nativeLanguage),
                onTap: () {
                  provider.loginAsJunior(s.id);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Theme(
                        data: isDark ? AppTheme.darkTheme : AppTheme.juniorTheme,
                        child: const JuniorDashboard(),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: color),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
