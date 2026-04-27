import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/social_metrics.dart';

class SocialService {
  // Base endpoints for 2026 API standards
  static const String _ytBaseUrl = "https://www.googleapis.com/youtube/v3";
  static const String _igBaseUrl = "https://graph.facebook.com/v19.0";

  /// Main entry point for YouTube that matches your Main UI needs
  Future<SocialMetrics> fetchYouTubeMetrics(String channelId) async {
    final apiKey = dotenv.env['YOUTUBE_API_KEY'];

    // Check if API Key exists, otherwise go straight to fallback
    if (apiKey != null && apiKey.isNotEmpty) {
      try {
        final url = Uri.parse(
          "$_ytBaseUrl/channels?part=statistics,snippet&id=$channelId&key=$apiKey",
        );
        final response = await http
            .get(url)
            .timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['items'].isNotEmpty) {
            final stats = data['items'][0]['statistics'];
            return SocialMetrics(
              name: data['items'][0]['snippet']['title'],
              count: stats['subscriberCount'] ?? "0",
              secondaryCount: "${stats['viewCount'] ?? 0} views",
              source: 'Official API',
            );
          }
        }
      } catch (e) {
        debugPrint("YouTube API Error: $e. Using fallback...");
      }
    }

    // FALLBACK: Use the original general scraper
    return await _getPublicInfoFallback(
      "https://www.youtube.com/channel/$channelId",
      "subscribers",
    );
  }

  /// Main entry point for Instagram that matches your Main UI needs
  Future<SocialMetrics> fetchInstagramMetrics(String targetHandle) async {
    final token = dotenv.env['INSTAGRAM_ACCESS_TOKEN'];
    final myId = dotenv.env['MY_INSTAGRAM_BUSINESS_ID'];

    if (token != null && myId != null) {
      try {
        final fields =
            "business_discovery.username($targetHandle){followers_count,media_count,name}";
        final url = Uri.parse(
          "$_igBaseUrl/$myId?fields=$fields&access_token=$token",
        );

        final response = await http
            .get(url)
            .timeout(const Duration(seconds: 10));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          return SocialMetrics(
            name: data['business_discovery']['name'],
            count: data['business_discovery']['followers_count'].toString(),
            secondaryCount:
                "${data['business_discovery']['media_count']} posts",
            source: 'Meta Graph API',
          );
        }
      } catch (e) {
        debugPrint("Instagram API Error: $e. Using fallback...");
      }
    }

    // FALLBACK: Use the original general scraper
    return await _getPublicInfoFallback(
      "https://www.instagram.com/$targetHandle/",
      "followers",
    );
  }

  /// Placeholder for X (Twitter) metrics
  Future<SocialMetrics> fetchXMetrics(String handle) async {
    // Current script logic: to be implemented later
    // Returning a mock/fallback for now to visualize the UI
    return SocialMetrics(
      name: "X (@$handle)",
      count: "---",
      secondaryCount: "Awaiting implementation",
      source: "X API (Pending)",
    );
  }

  /// Scraper fallback to ensure data availability
  Future<SocialMetrics> _getPublicInfoFallback(
    String url,
    String keyword,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      );

      if (response.statusCode == 200) {
        var document = parse(response.body);
        String title =
            document.querySelector('title')?.text ?? "No Title Found";
        String metaDesc =
            document
                .querySelector('meta[name="description"]')
                ?.attributes['content'] ??
            "";

        return SocialMetrics(
          name: title.split(' - ')[0],
          count: _parseCountFromText(metaDesc, keyword),
          secondaryCount: metaDesc.length > 50
              ? "${metaDesc.substring(0, 47)}..."
              : metaDesc,
          source: "Web Scraper",
        );
      }
      return SocialMetrics.error("Access Blocked (${response.statusCode})");
    } catch (e) {
      return SocialMetrics.error(e.toString());
    }
  }

  /// Helper to extract numbers from Meta description strings if scraping
  String _parseCountFromText(String text, String keyword) {
    // Simple regex to find numbers near keywords like '1.2K Followers'
    RegExp regExp = RegExp(
      r"(\d+\.?\d*[KMB]?)\s+" + keyword,
      caseSensitive: false,
    );
    var match = regExp.firstMatch(text);
    return match?.group(1) ?? "N/A";
  }
}
