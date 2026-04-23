class SocialMetrics {
  final String name;
  final String count;
  final String? secondaryCount;
  final String source;
  final bool isError;

  SocialMetrics({
    required this.name,
    required this.count,
    this.secondaryCount,
    required this.source,
    this.isError = false,
  });

  factory SocialMetrics.error(String message) {
    return SocialMetrics(
      name: "Error",
      count: "N/A",
      source: message,
      isError: true,
    );
  }
}
