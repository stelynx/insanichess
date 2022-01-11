source devops/export_vars.sh

dart pub get
dart run bin/main.dart &

echo "$!" > insanichess_server.pid
