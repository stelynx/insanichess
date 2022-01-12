import '../../config/config.dart';

Uri uriForPath(List<String> path) {
  return Uri.parse('${Config.backendUrl}/${path.join('/')}');
}
