part of 'online_play_bloc.dart';

@immutable
class OnlinePlayState {
  final InsanichessTimeControl timeControl;
  final insanichess.PieceColor? preferColor;
  final bool isPrivate;

  final bool editingTimeControl;
  final bool editingPreferColor;

  final bool startedSeekPrivate;
  final bool startedSeekPublic;

  const OnlinePlayState({
    required this.timeControl,
    required this.preferColor,
    required this.isPrivate,
    required this.editingTimeControl,
    required this.editingPreferColor,
    required this.startedSeekPrivate,
    required this.startedSeekPublic,
  });

  OnlinePlayState.initial({
    required InsanichessChallenge? challengePreference,
  })  : timeControl = challengePreference?.timeControl ??
            const InsanichessTimeControl.blitz(),
        preferColor = challengePreference?.preferColor,
        isPrivate = challengePreference?.isPrivate ?? true,
        editingTimeControl = false,
        editingPreferColor = false,
        startedSeekPrivate = false,
        startedSeekPublic = false;

  OnlinePlayState copyWith({
    InsanichessTimeControl? timeControl,
    insanichess.PieceColor? preferColor,
    bool? isPrivate,
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
      isPrivate: isPrivate ?? this.isPrivate,
      editingTimeControl: editingTimeControl ?? this.editingTimeControl,
      editingPreferColor: editingPreferColor ?? this.editingPreferColor,
      startedSeekPrivate: startedSeekPrivate ?? this.startedSeekPrivate,
      startedSeekPublic: startedSeekPublic ?? this.startedSeekPublic,
    );
  }
}
