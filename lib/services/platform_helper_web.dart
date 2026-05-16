import 'dart:convert';
import 'package:web/web.dart' as web;

void platformDownloadFile(List<int> bytes, String fileName, String mimeType) {
  final base64String = base64Encode(bytes);
  final anchor = web.HTMLAnchorElement()
    ..href = 'data:$mimeType;base64,$base64String'
    ..download = fileName
    ..style.display = 'none';
    
  web.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
}
