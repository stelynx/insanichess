import 'dart:convert';
import 'dart:io';

Future<Map<String, dynamic>> parseBodyFromRequest(HttpRequest request) async {
  final String content = await utf8.decodeStream(request);
  return jsonDecode(content);
}
