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

  final bool isLoading;
  final String? createdChallengeId;
  final bool? publicChallengePreaccepted;
  final bool challengeDeclined;
  final BackendFailure? backendFailure;

  const OnlinePlayState({
    required this.timeControl,
    required this.preferColor,
    required this.isPrivate,
    required this.editingTimeControl,
    required this.editingPreferColor,
    required this.startedSeekPrivate,
    required this.startedSeekPublic,
    required this.isLoading,
    required this.createdChallengeId,
    required this.publicChallengePreaccepted,
    required this.challengeDeclined,
    required this.backendFailure,
  });

  OnlinePlayState.initial({
    required InsanichessChallenge? challengePreference,
  })  : timeControl = challengePreference?.timeControl ??
            const InsanichessTimeControl.blitz(),
        preferColor = challengePreference?.preferColor,
        isPrivate = challengePreference?.isPrivate ?? false,
        editingTimeControl = false,
        editingPreferColor = false,
        startedSeekPrivate = false,
        startedSeekPublic = false,
        isLoading = false,
        createdChallengeId = null,
        publicChallengePreaccepted = null,
        challengeDeclined = false,
        backendFailure = null;

  OnlinePlayState copyWith({
    InsanichessTimeControl? timeControl,
    insanichess.PieceColor? preferColor,
    bool? isPrivate,
    bool? preferNoColor,
    bool? editingTimeControl,
    bool? editingPreferColor,
    bool? startedSeekPrivate,
    bool? startedSeekPublic,
    bool? isLoading,
    String? createdChallengeId,
    bool? publicChallengePreaccepted,
    bool? challengeDeclined,
    BackendFailure? backendFailure,
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
      isLoading: isLoading ?? this.isLoading,
      createdChallengeId: createdChallengeId,
      publicChallengePreaccepted:
          publicChallengePreaccepted ?? this.publicChallengePreaccepted,
      challengeDeclined: challengeDeclined ?? this.challengeDeclined,
      backendFailure: backendFailure,
    );
  }
}
