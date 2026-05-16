void platformDownloadFile(List<int> bytes, String fileName, String mimeType) {
  // Mobile downloads via browser anchor tags are not supported.
  // In the future, this could be implemented using path_provider and open_file.
  // For now, we return silently as the UI should disable the button on mobile.
}
