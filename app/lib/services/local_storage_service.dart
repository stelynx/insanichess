class LocalStorageService {
  static LocalStorageService? _instance;
  static LocalStorageService get instance => _instance!;

  LocalStorageService._();

  factory LocalStorageService() {
    if (_instance != null) {
      throw StateError('LocalStorageService already created');
    }

    _instance = LocalStorageService._();
    return _instance!;
  }
}
