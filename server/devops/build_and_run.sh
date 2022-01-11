source devops/export_vars.sh

dart pub get
dart compile exe bin/main.dart -o insanichess_server
./insanichess_server &

echo "$!" > insanichess_server.pid
