import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:insanichess_sdk/insanichess_sdk.dart';
import 'package:meta/meta.dart';

import '../../services/backend_service.dart';
import '../../util/either.dart';
import '../../util/failures/backend_failure.dart';
import '../../widgets/ic_drawer.dart';
import '../global/global_bloc.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<_SettingsEvent, SettingsState> {
  final GlobalKey<ICDrawerState> drawerKey = GlobalKey<ICDrawerState>();
  final GlobalKey<ICDrawerState> drawerKeyOtb = GlobalKey<ICDrawerState>();

  final GlobalBloc _globalBloc;
  final BackendService _backendService;

  SettingsBloc({
    required GlobalBloc globalBloc,
    required BackendService backendService,
  })  : _globalBloc = globalBloc,
        _backendService = backendService,
        super(SettingsState.initial(globalBloc.state.settings!)) {
    on<_HideFailure>(_onHideFailure);
    on<_ToggleShowLegalMoves>(_onToggleShowLegalMoves);
    on<_ToggleShowZoomButtonOnLeft>(_onToggleShowZoomButtonOnLeft);
    on<_ToggleOtbRotateChessBoard>(_onToggleOtbRotateChessboard);
    on<_ToggleOtbMirrorTopPieces>(_onToggleOtbMirrorTopPieces);
    on<_ToggleOtbAllowUndo>(_onToggleOtbAllowUndo);
    on<_ToggleOtbAlwaysPromoteToQueen>(_onToggleOtbAlwaysPromoteToQueen);
    on<_ToggleOtbAutoZoomOutOnMove>(_onToggleOtbAutoZoomOutOnMove);
  }

  // Public API

  void hideFailure() => add(const _HideFailure());
  void toggleOtbRotateChessboard() => add(const _ToggleOtbRotateChessBoard());
  void toggleOtbMirrorTopPieces() => add(const _ToggleOtbMirrorTopPieces());
  void toggleOtbAllowUndo() => add(const _ToggleOtbAllowUndo());
  void toggleOtbAlwaysPromoteToQueen() =>
      add(const _ToggleOtbAlwaysPromoteToQueen());
  void toggleOtbAutoZoomOutOnMove() => add(const _ToggleOtbAutoZoomOutOnMove());
  void toggleShowLegalMoves() => add(const _ToggleShowLegalMoves());
  void toggleShowZoomButtonOnLeft() => add(const _ToggleShowZoomButtonOnLeft());

  // Handlers

  FutureOr<void> _onHideFailure(
    _HideFailure event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith());
  }

  FutureOr<void> _onToggleShowLegalMoves(
    _ToggleShowLegalMoves event,
    Emitter<SettingsState> emit,
  ) async {
    final bool oldValue = state.showLegalMoves;
    final bool newValue = !oldValue;
    emit(state.copyWith(showLegalMoves: newValue));

    final Either<BackendFailure, void> updateResult =
        await _backendService.updateSetting(<String, dynamic>{
      InsanichessSettingsJsonKey.showLegalMoves: newValue,
    });
    if (updateResult.isError()) {
      emit(state.copyWith(
        showLegalMoves: oldValue,
        backendFailure: updateResult.error,
      ));
      return;
    }

    _globalBloc.changeSettings(
        _globalBloc.state.settings!.copyWith(showLegalMoves: newValue));
  }

  FutureOr<void> _onToggleShowZoomButtonOnLeft(
    _ToggleShowZoomButtonOnLeft event,
    Emitter<SettingsState> emit,
  ) async {
    final bool oldValue = state.showZoomOutButtonOnLeft;
    final bool newValue = !oldValue;
    emit(state.copyWith(showZoomOutButtonOnLeft: newValue));

    final Either<BackendFailure, void> updateResult =
        await _backendService.updateSetting(<String, dynamic>{
      InsanichessSettingsJsonKey.showZoomOutButtonOnLeft: newValue,
    });
    if (updateResult.isError()) {
      emit(state.copyWith(
        showZoomOutButtonOnLeft: oldValue,
        backendFailure: updateResult.error,
      ));
      return;
    }

    _globalBloc.changeSettings(_globalBloc.state.settings!
        .copyWith(showZoomOutButtonOnLeft: newValue));
  }

  FutureOr<void> _onToggleOtbRotateChessboard(
    _ToggleOtbRotateChessBoard event,
    Emitter<SettingsState> emit,
  ) async {
    final bool oldValue = state.otbRotateChessboard;
    final bool newValue = !oldValue;
    emit(state.copyWith(otbRotateChessboard: newValue));

    final Either<BackendFailure, void> updateResult =
        await _backendService.updateSetting(<String, dynamic>{
      InsanichessSettingsJsonKey.otb: <String, dynamic>{
        InsanichessOtbSettingsJsonKey.rotateChessboard: newValue,
      },
    });
    if (updateResult.isError()) {
      emit(state.copyWith(
        otbRotateChessboard: oldValue,
        backendFailure: updateResult.error,
      ));
      return;
    }

    _globalBloc.changeSettings(_globalBloc.state.settings!.copyWith(
      otb: _globalBloc.state.settings!.otb.copyWith(rotateChessboard: newValue),
    ));
  }

  FutureOr<void> _onToggleOtbAllowUndo(
    _ToggleOtbAllowUndo event,
    Emitter<SettingsState> emit,
  ) async {
    final bool oldValue = state.otbAllowUndo;
    final bool newValue = !oldValue;
    emit(state.copyWith(otbAllowUndo: newValue));

    final Either<BackendFailure, void> updateResult =
        await _backendService.updateSetting(<String, dynamic>{
      InsanichessSettingsJsonKey.otb: <String, dynamic>{
        InsanichessGameSettingsJsonKey.allowUndo: newValue,
      },
    });
    if (updateResult.isError()) {
      emit(state.copyWith(
        otbAllowUndo: oldValue,
        backendFailure: updateResult.error,
      ));
      return;
    }

    _globalBloc.changeSettings(_globalBloc.state.settings!.copyWith(
      otb: _globalBloc.state.settings!.otb.copyWith(allowUndo: newValue),
    ));
  }

  FutureOr<void> _onToggleOtbMirrorTopPieces(
    _ToggleOtbMirrorTopPieces event,
    Emitter<SettingsState> emit,
  ) async {
    final bool oldValue = state.otbMirrorTopPieces;
    final bool newValue = !oldValue;
    emit(state.copyWith(otbMirrorTopPieces: newValue));

    final Either<BackendFailure, void> updateResult =
        await _backendService.updateSetting(<String, dynamic>{
      InsanichessSettingsJsonKey.otb: <String, dynamic>{
        InsanichessOtbSettingsJsonKey.mirrorTopPieces: newValue,
      },
    });
    if (updateResult.isError()) {
      emit(state.copyWith(
        otbMirrorTopPieces: oldValue,
        backendFailure: updateResult.error,
      ));
      return;
    }

    _globalBloc.changeSettings(_globalBloc.state.settings!.copyWith(
      otb: _globalBloc.state.settings!.otb.copyWith(mirrorTopPieces: newValue),
    ));
  }

  FutureOr<void> _onToggleOtbAlwaysPromoteToQueen(
    _ToggleOtbAlwaysPromoteToQueen event,
    Emitter<SettingsState> emit,
  ) async {
    final bool oldValue = state.otbAlwaysPromoteToQueen;
    final bool newValue = !oldValue;
    emit(state.copyWith(otbAlwaysPromoteToQueen: newValue));

    final Either<BackendFailure, void> updateResult =
        await _backendService.updateSetting(<String, dynamic>{
      InsanichessSettingsJsonKey.otb: <String, dynamic>{
        InsanichessGameSettingsJsonKey.alwaysPromoteToQueen: newValue,
      },
    });
    if (updateResult.isError()) {
      emit(state.copyWith(
        otbAlwaysPromoteToQueen: oldValue,
        backendFailure: updateResult.error,
      ));
      return;
    }

    _globalBloc.changeSettings(_globalBloc.state.settings!.copyWith(
      otb: _globalBloc.state.settings!.otb
          .copyWith(alwaysPromoteToQueen: newValue),
    ));
  }

  FutureOr<void> _onToggleOtbAutoZoomOutOnMove(
    _ToggleOtbAutoZoomOutOnMove event,
    Emitter<SettingsState> emit,
  ) async {
    final AutoZoomOutOnMoveBehaviour oldValue = state.otbAutoZoomOutOnMove;
    final AutoZoomOutOnMoveBehaviour newValue =
        oldValue == AutoZoomOutOnMoveBehaviour.always
            ? AutoZoomOutOnMoveBehaviour.never
            : AutoZoomOutOnMoveBehaviour.always;
    emit(state.copyWith(otbAutoZoomOutOnMove: newValue));

    final Either<BackendFailure, void> updateResult =
        await _backendService.updateSetting(<String, dynamic>{
      InsanichessSettingsJsonKey.otb: <String, dynamic>{
        InsanichessGameSettingsJsonKey.autoZoomOutOnMove:
            newValue == AutoZoomOutOnMoveBehaviour.always ? 3 : 0,
      },
    });
    if (updateResult.isError()) {
      emit(state.copyWith(
        otbAutoZoomOutOnMove: oldValue,
        backendFailure: updateResult.error,
      ));
      return;
    }

    _globalBloc.changeSettings(_globalBloc.state.settings!.copyWith(
      otb: _globalBloc.state.settings!.otb.copyWith(
        autoZoomOutOnMove: newValue,
      ),
    ));
  }
}
