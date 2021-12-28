import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:insanichess_sdk/insanichess_sdk.dart';
import 'package:meta/meta.dart';

import '../../services/local_storage_service.dart';
import '../global/global_bloc.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<_SettingsEvent, SettingsState> {
  final GlobalBloc _globalBloc;

  final StreamSubscription<InsanichessSettings> _settingsStreamSubscription;

  SettingsBloc({
    required GlobalBloc globalBloc,
    required LocalStorageService localStorageService,
  })  : _globalBloc = globalBloc,
        _settingsStreamSubscription = globalBloc.settingsStream.listen(
            (InsanichessSettings settings) =>
                localStorageService.saveSettings(settings)),
        super(SettingsState.initial(globalBloc.state.settings!)) {
    on<_ToggleShowLegalMoves>(_onToggleShowLegalMoves);
    on<_ToggleShowZoomButtonOnLeft>(_onToggleShowZoomButtonOnLeft);
    on<_ToggleOtbRotateChessBoard>(_onToggleOtbRotateChessboard);
    on<_ToggleOtbMirrorTopPieces>(_onToggleOtbMirrorTopPieces);
    on<_ToggleOtbAllowUndo>(_onToggleOtbAllowUndo);
    on<_ToggleOtbAlwaysPromoteToQueen>(_onToggleOtbAlwaysPromoteToQueen);
    on<_ToggleOtbAutoZoomOutOnMove>(_onToggleOtbAutoZoomOutOnMove);
  }

  @override
  Future<void> close() {
    _settingsStreamSubscription.cancel();
    return super.close();
  }

  // Public API

  void toggleOtbRotateChessboard() => add(const _ToggleOtbRotateChessBoard());
  void toggleOtbMirrorTopPieces() => add(const _ToggleOtbMirrorTopPieces());
  void toggleOtbAllowUndo() => add(const _ToggleOtbAllowUndo());
  void toggleOtbAlwaysPromoteToQueen() =>
      add(const _ToggleOtbAlwaysPromoteToQueen());
  void toggleOtbAutoZoomOutOnMove() => add(const _ToggleOtbAutoZoomOutOnMove());
  void toggleShowLegalMoves() => add(const _ToggleShowLegalMoves());
  void toggleShowZoomButtonOnLeft() => add(const _ToggleShowZoomButtonOnLeft());

  // Handlers

  FutureOr<void> _onToggleShowLegalMoves(
    _ToggleShowLegalMoves event,
    Emitter<SettingsState> emit,
  ) async {
    _globalBloc.changeSettings(_globalBloc.state.settings!
        .copyWith(showLegalMoves: !state.showLegalMoves));
    emit(state.copyWith(showLegalMoves: !state.showLegalMoves));
  }

  FutureOr<void> _onToggleShowZoomButtonOnLeft(
    _ToggleShowZoomButtonOnLeft event,
    Emitter<SettingsState> emit,
  ) async {
    _globalBloc.changeSettings(_globalBloc.state.settings!
        .copyWith(showZoomOutButtonOnLeft: !state.showZoomOutButtonOnLeft));
    emit(state.copyWith(
      showZoomOutButtonOnLeft: !state.showZoomOutButtonOnLeft,
    ));
  }

  FutureOr<void> _onToggleOtbRotateChessboard(
    _ToggleOtbRotateChessBoard event,
    Emitter<SettingsState> emit,
  ) async {
    _globalBloc.changeSettings(_globalBloc.state.settings!.copyWith(
      otb: _globalBloc.state.settings!.otb
          .copyWith(rotateChessboard: !state.otbRotateChessboard),
    ));
    emit(state.copyWith(otbRotateChessboard: !state.otbRotateChessboard));
  }

  FutureOr<void> _onToggleOtbAllowUndo(
    _ToggleOtbAllowUndo event,
    Emitter<SettingsState> emit,
  ) async {
    _globalBloc.changeSettings(_globalBloc.state.settings!.copyWith(
      otb: _globalBloc.state.settings!.otb
          .copyWith(allowUndo: !state.otbAllowUndo),
    ));
    emit(state.copyWith(otbAllowUndo: !state.otbAllowUndo));
  }

  FutureOr<void> _onToggleOtbMirrorTopPieces(
    _ToggleOtbMirrorTopPieces event,
    Emitter<SettingsState> emit,
  ) async {
    _globalBloc.changeSettings(_globalBloc.state.settings!.copyWith(
      otb: _globalBloc.state.settings!.otb
          .copyWith(mirrorTopPieces: !state.otbMirrorTopPieces),
    ));
    emit(state.copyWith(otbMirrorTopPieces: !state.otbMirrorTopPieces));
  }

  FutureOr<void> _onToggleOtbAlwaysPromoteToQueen(
    _ToggleOtbAlwaysPromoteToQueen event,
    Emitter<SettingsState> emit,
  ) async {
    _globalBloc.changeSettings(_globalBloc.state.settings!.copyWith(
      otb: _globalBloc.state.settings!.otb
          .copyWith(alwaysPromoteToQueen: !state.otbAlwaysPromoteToQueen),
    ));
    emit(state.copyWith(
        otbAlwaysPromoteToQueen: !state.otbAlwaysPromoteToQueen));
  }

  FutureOr<void> _onToggleOtbAutoZoomOutOnMove(
    _ToggleOtbAutoZoomOutOnMove event,
    Emitter<SettingsState> emit,
  ) async {
    _globalBloc.changeSettings(_globalBloc.state.settings!.copyWith(
      otb: _globalBloc.state.settings!.otb.copyWith(
          autoZoomOutOnMove:
              state.otbAutoZoomOutOnMove == AutoZoomOutOnMoveBehaviour.always
                  ? AutoZoomOutOnMoveBehaviour.never
                  : AutoZoomOutOnMoveBehaviour.always),
    ));
    emit(state.copyWith(
      otbAutoZoomOutOnMove:
          state.otbAutoZoomOutOnMove == AutoZoomOutOnMoveBehaviour.always
              ? AutoZoomOutOnMoveBehaviour.never
              : AutoZoomOutOnMoveBehaviour.always,
    ));
  }
}
