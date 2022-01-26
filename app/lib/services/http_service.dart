import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../util/functions/uri_for_path.dart';

class HttpService {
  static HttpService? _instance;
  static HttpService get instance => _instance!;

  HttpService._()
      : _failedRequestStreamController = StreamController<void>.broadcast();

  factory HttpService() {
    if (_instance != null) {
      throw StateError('HttpService already created');
    }

    _instance = HttpService._();
    return _instance!;
  }

  StreamController<void> _failedRequestStreamController;
  Stream<void> get failedRequestStream => _failedRequestStreamController.stream;

  Future<http.Response?> get(List<String> pathSegments,
      {Map<String, String>? headers}) async {
    try {
      return await http.get(uriForPath(pathSegments), headers: headers);
    } on SocketException catch (_) {
      _failedRequestStreamController.add(null);
    }
  }

  Future<http.Response?> post(List<String> pathSegments,
      {Map<String, String>? headers, Object? body}) async {
    try {
      return await http.post(
        uriForPath(pathSegments),
        headers: headers,
        body: body,
      );
    } on SocketException catch (_) {
      _failedRequestStreamController.add(null);
    }
  }

  Future<http.Response?> patch(List<String> pathSegments,
      {Map<String, String>? headers, Object? body}) async {
    try {
      return await http.patch(
        uriForPath(pathSegments),
        headers: headers,
        body: body,
      );
    } on SocketException catch (_) {
      _failedRequestStreamController.add(null);
    }
  }

  Future<http.Response?> delete(List<String> pathSegments,
      {Map<String, String>? headers}) async {
    try {
      return await http.delete(
        uriForPath(pathSegments),
        headers: headers,
      );
    } on SocketException catch (_) {
      _failedRequestStreamController.add(null);
    }
  }
}
