import 'package:bloc/bloc.dart';
import 'package:insanichess_sdk/insanichess_sdk.dart';
import 'package:meta/meta.dart';

part 'waiting_challenge_accept_event.dart';
part 'waiting_challenge_accept_state.dart';

class WaitingChallengeAcceptBloc
    extends Bloc<_WaitingChallengeAcceptEvent, WaitingChallengeAcceptState> {
  final String challengeId;
  final InsanichessChallenge challenge;

  WaitingChallengeAcceptBloc({
    required this.challengeId,
    required this.challenge,
  }) : super(const WaitingChallengeAcceptState.initial());
}
