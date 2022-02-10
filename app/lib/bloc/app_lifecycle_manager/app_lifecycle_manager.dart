import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/backend_service.dart';
import '../global/global_bloc.dart';

class AppLifecycleManager extends Cubit<AppLifecycleState>
    with WidgetsBindingObserver {
  final GlobalBloc _globalBloc;
  final BackendService _backendService;

  AppLifecycleManager({
    required GlobalBloc globalBloc,
    required BackendService backendService,
  })  : _globalBloc = globalBloc,
        _backendService = backendService,
        super(AppLifecycleState.resumed) {
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance!.removeObserver(this);
    return super.close();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (_globalBloc.state.playerMyself == null) return;

    emit(state);

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        return this.state != AppLifecycleState.resumed
            ? null
            : await _backendService.notifyPlayerOnline(
                _globalBloc.state.playerMyself!,
                isOnline: false,
              );
      case AppLifecycleState.resumed:
        return this.state == AppLifecycleState.resumed
            ? null
            : await _backendService.notifyPlayerOnline(
                _globalBloc.state.playerMyself!,
                isOnline: true,
              );
    }
  }
}
