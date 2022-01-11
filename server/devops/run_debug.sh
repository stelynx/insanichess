source devops/export_vars.sh

export INSANICHESS_IS_DEBUG=true

dart pub get
dart run bin/main.dart 
