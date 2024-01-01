class WatchProvider {
  final String logoPath;
  final int providerId;
  final String providerName;
  final int displayPriority;

  WatchProvider(
      {required this.logoPath,
      required this.providerId,
      required this.providerName,
      required this.displayPriority});

  WatchProvider.fromJson(Map item)
      : logoPath = item["logo_path"],
        providerId = item["provider_id"],
        providerName = item["provider_name"],
        displayPriority = item["display_priority"];
}
