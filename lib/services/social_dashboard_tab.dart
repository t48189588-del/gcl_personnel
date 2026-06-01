import 'package:flutter/material.dart';
import '../services/social_service.dart';
import '../models/social_metrics.dart';
import '../l10n/app_localizations.dart';

class SocialDashboardTab extends StatefulWidget {
  const SocialDashboardTab({super.key});

  @override
  State<SocialDashboardTab> createState() => _SocialDashboardTabState();
}

class _SocialDashboardTabState extends State<SocialDashboardTab> {
  final SocialService _socialService = SocialService();

  final String youtubeChannelId = "UCXeW6dvL52EJgPPNJMlVt0A";
  final String instagramHandle = "gclkyutech";

  late Future<SocialMetrics> _youtubeFuture;
  late Future<SocialMetrics> _instagramFuture;
  late Future<SocialMetrics> _xFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _youtubeFuture = _socialService.fetchYouTubeMetrics(youtubeChannelId);
      _instagramFuture = _socialService.fetchInstagramMetrics(instagramHandle);
      _xFuture = _socialService.fetchXMetrics("gclkyutech"); 
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMetricCard(
            title: loc.youtubeStats,
            icon: Icons.play_circle_filled,
            iconColor: Colors.red,
            future: _youtubeFuture,
            metricLabel: loc.subscribers,
            secondaryMetricLabel: loc.views,
          ),
          const SizedBox(width: 16),
          _buildMetricCard(
            title: loc.instagramStats,
            icon: Icons.camera_alt,
            iconColor: Colors.purple,
            future: _instagramFuture,
            metricLabel: loc.followers,
            secondaryMetricLabel: loc.posts,
          ),
          const SizedBox(width: 16),
          _buildMetricCard(
            title: loc.xStats,
            icon: Icons.alternate_email,
            iconColor: Colors.black,
            future: _xFuture,
            metricLabel: loc.followers,
            secondaryMetricLabel: "",
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Social Stats',
            onPressed: _refreshData,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Future<SocialMetrics> future,
    required String metricLabel,
    required String secondaryMetricLabel,
  }) {
    final loc = AppLocalizations.of(context)!;
    return FutureBuilder<SocialMetrics>(
      future: future,
      builder: (context, snapshot) {
        final bool isLoading = snapshot.connectionState == ConnectionState.waiting;
        final data = snapshot.data;

        return SizedBox(
          width: 300,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: iconColor, size: 28),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(title, style: Theme.of(context).textTheme.titleMedium, overflow: TextOverflow.ellipsis),
                      ),
                      if (data != null)
                        Chip(
                          label: Text(
                            data.source,
                            style: const TextStyle(fontSize: 10),
                          ),
                          backgroundColor: data.isError
                              ? Colors.red.shade100
                              : Colors.green.shade100,
                        ),
                    ],
                  ),
                  const Divider(),
                  if (isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (snapshot.hasError || data == null || data.isError)
                    Text(
                      "${loc.error}: ${data?.source ?? snapshot.error}",
                      style: const TextStyle(color: Colors.red),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "$metricLabel: ${data.count}",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        if (data.secondaryCount != null && secondaryMetricLabel.isNotEmpty)
                          Text(
                            "${data.secondaryCount} $secondaryMetricLabel",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
