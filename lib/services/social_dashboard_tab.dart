import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/social_service.dart';
import '../models/social_metrics.dart';

class SocialDashboardTab extends StatefulWidget {
  const SocialDashboardTab({super.key});

  @override
  State<SocialDashboardTab> createState() => _SocialDashboardTabState();
}

class _SocialDashboardTabState extends State<SocialDashboardTab> {
  final SocialService _socialService = SocialService();

  // Data from README
  final String youtubeChannelId = "UCXeW6dvL52EJgPPNJMlVt0A";
  final String instagramHandle = "gclkyutech";

  late Future<SocialMetrics> _youtubeFuture;
  late Future<SocialMetrics> _instagramFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _youtubeFuture = _socialService.fetchYouTubeMetrics(youtubeChannelId);
      _instagramFuture = _socialService.fetchInstagramMetrics(instagramHandle);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => _refreshData(),
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildMetricCard(
            title: "YouTube Stats",
            icon: Icons.play_circle_filled,
            iconColor: Colors.red,
            future: _youtubeFuture,
            metricLabel: "Subscribers",
          ),
          const SizedBox(height: 16),
          _buildMetricCard(
            title: "Instagram Stats",
            icon: Icons.camera_alt,
            iconColor: Colors.purple,
            future: _instagramFuture,
            metricLabel: "Followers",
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
  }) {
    return FutureBuilder<SocialMetrics>(
      future: future,
      builder: (context, snapshot) {
        final bool isLoading =
            snapshot.connectionState == ConnectionState.waiting;
        final data = snapshot.data;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: iconColor, size: 28),
                    const SizedBox(width: 8),
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const Spacer(),
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
                    "Error: ${data?.source ?? snapshot.error}",
                    style: const TextStyle(color: Colors.red),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "$metricLabel: ${data.count}",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      if (data.secondaryCount != null)
                        Text(
                          data.secondaryCount!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
