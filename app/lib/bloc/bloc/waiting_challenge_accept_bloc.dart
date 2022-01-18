import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:insanichess_sdk/insanichess_sdk.dart';
import 'package:meta/meta.dart';

import '../../services/backend_service.dart';
import '../../util/either.dart';
import '../../util/failures/backend_failure.dart';

part 'waiting_challenge_accept_event.dart';
part 'waiting_challenge_accept_state.dart';

class WaitingChallengeAcceptBloc
    extends Bloc<_WaitingChallengeAcceptEvent, WaitingChallengeAcceptState> {
  final InsanichessChallenge challenge;
  final String _challengeId;

  final BackendService _backendService;

  late Timer _challengeDataRefreshTimer;

  WaitingChallengeAcceptBloc({
    required this.challenge,
    required String challengeId,
    required BackendService backendService,
  })  : _challengeId = challengeId,
        _backendService = backendService,
        super(const WaitingChallengeAcceptState.initial()) {
    on<_ChallengeExpired>(_onChallengeExpired);
    on<_CancelChallenge>(_onCancelChallenge);
    on<_FetchChallengeData>(_onFetchChallengeData);

    // For now we do not need a stream here. Might add it later.
    _challengeDataRefreshTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => add(const _FetchChallengeData()),
    );
  }

  @override
  Future<void> close() {
    _challengeDataRefreshTimer.cancel();
    return super.close();
  }

  // Public API

  void challengeExpired() => add(const _ChallengeExpired());
  void cancelChallenge() => add(const _CancelChallenge());

  // Handlers

  FutureOr<void> _onChallengeExpired(
    _ChallengeExpired event,
    Emitter<WaitingChallengeAcceptState> emit,
  ) async {
    emit(state.copyWith(challengeCancelled: true));
  }

  FutureOr<void> _onCancelChallenge(
    _CancelChallenge event,
    Emitter<WaitingChallengeAcceptState> emit,
  ) async {
    emit(state.copyWith(cancellationInProgress: true));

    final Either<BackendFailure, void> nullOrFailure =
        await _backendService.cancelChallenge(_challengeId);

    emit(state.copyWith(
      cancellationInProgress: false,
      challengeCancelled: !nullOrFailure.isError(),
    ));
  }

  FutureOr<void> _onFetchChallengeData(
    _FetchChallengeData event,
    Emitter<WaitingChallengeAcceptState> emit,
  ) async {
    final Either<BackendFailure, InsanichessChallenge> challengeOrNull =
        await _backendService.getChallenge(_challengeId);
    if (challengeOrNull.isError()) {
      // Let server garbage collect the challenge
      emit(state.copyWith(challengeCancelled: true));
    }

    switch (challengeOrNull.value.status) {
      case ChallengeStatus.created:
        break;
      case ChallengeStatus.accepted:
        emit(state.copyWith(gameId: _challengeId));
        break;
      case ChallengeStatus.declined:
        emit(state.copyWith(challengeDeclined: true));
        break;
      case ChallengeStatus.initiated:
        // This case should not occur. If it occurs, let the server garbage
        // collect the challenge.
        emit(state.copyWith(challengeCancelled: true));
    }
  }
}
