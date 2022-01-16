part of 'online_play_bloc.dart';

@immutable
class OnlinePlayState {
  final InsanichessTimeControl timeControl;
  final insanichess.PieceColor? preferColor;

  final bool editingTimeControl;
  final bool editingPreferColor;

  final bool startedSeekPrivate;
  final bool startedSeekPublic;

  const OnlinePlayState({
    required this.timeControl,
    required this.preferColor,
    required this.editingTimeControl,
    required this.editingPreferColor,
    required this.startedSeekPrivate,
    required this.startedSeekPublic,
  });

  // TODO get initial values from local storage
  const OnlinePlayState.initial({
    required this.timeControl,
    required this.preferColor,
  })  : editingTimeControl = false,
        editingPreferColor = false,
        startedSeekPrivate = false,
        startedSeekPublic = false;

  OnlinePlayState copyWith({
    InsanichessTimeControl? timeControl,
    insanichess.PieceColor? preferColor,
    bool? preferNoColor,
    bool? editingTimeControl,
    bool? editingPreferColor,
    bool? startedSeekPrivate,
    bool? startedSeekPublic,
  }) {
    return OnlinePlayState(
      timeControl: timeControl ?? this.timeControl,
      preferColor:
          preferColor ?? (preferNoColor == true ? null : this.preferColor),
      editingTimeControl: editingTimeControl ?? this.editingTimeControl,
      editingPreferColor: editingPreferColor ?? this.editingPreferColor,
      startedSeekPrivate: startedSeekPrivate ?? this.startedSeekPrivate,
      startedSeekPublic: startedSeekPublic ?? this.startedSeekPublic,
    );
  }
}
