import 'package:flutter/foundation.dart';
import 'platform_helper_mobile.dart'
    if (dart.library.js_interop) 'platform_helper_web.dart';

abstract class PlatformHelper {
  static bool get isWeb => kIsWeb;

  static void downloadFile(List<int> bytes, String fileName, String mimeType) {
    platformDownloadFile(bytes, fileName, mimeType);
  }
}
