import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:insanichess/insanichess.dart' as insanichess;
import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../../widgets/ic_drawer.dart';

part 'online_play_event.dart';
part 'online_play_state.dart';

class OnlinePlayBloc extends Bloc<_OnlinePlayEvent, OnlinePlayState> {
  final GlobalKey<ICDrawerState> drawerKey = GlobalKey<ICDrawerState>();

  OnlinePlayBloc()
      : super(const OnlinePlayState.initial(
          timeControl: InsanichessTimeControl.blitz(),
          preferColor: null,
        )) {
    on<_ToggleEditingTimeControl>(_onToggleEditingTimeControl);
    on<_ToggleEditingPreferColor>(_onToggleEditingPreferColor);
  }

  // Public API

  void toggleEditingTimeControl() => add(const _ToggleEditingTimeControl());
  void toggleEditingPreferColor() => add(const _ToggleEditingPreferColor());

  // Handlers

  FutureOr<void> _onToggleEditingTimeControl(
    _ToggleEditingTimeControl event,
    Emitter<OnlinePlayState> emit,
  ) async {
    emit(state.copyWith(editingTimeControl: !state.editingTimeControl));
  }

  FutureOr<void> _onToggleEditingPreferColor(
    _ToggleEditingPreferColor event,
    Emitter<OnlinePlayState> emit,
  ) async {
    emit(state.copyWith(editingPreferColor: !state.editingPreferColor));
  }
}
