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

  WaitingChallengeAcceptBloc({
    required this.challenge,
    required String challengeId,
    required BackendService backendService,
  })  : _challengeId = challengeId,
        _backendService = backendService,
        super(const WaitingChallengeAcceptState.initial()) {
    on<_ChallengeExpired>(_onChallengeExpired);
    on<_CancelChallenge>(_onCancelChallenge);
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
}
