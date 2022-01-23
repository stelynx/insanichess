import '../../config/config.dart';

Uri uriForPath(List<String> path, {bool isWss = false}) {
  return Uri(
    scheme: isWss ? Config.backendWssScheme : Config.backendApiScheme,
    host: Config.backendHost,
    port: Config.backendPort,
    pathSegments: path,
  );
}
