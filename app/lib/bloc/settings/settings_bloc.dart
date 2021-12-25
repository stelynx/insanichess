import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<_SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState.initial());
}
