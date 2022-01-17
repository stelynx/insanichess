import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../../bloc/bloc/waiting_challenge_accept_bloc.dart';

class WaitingChallengeAcceptScreenArgs {
  final String challengeId;
  final InsanichessChallenge challengeData;

  const WaitingChallengeAcceptScreenArgs({
    required this.challengeId,
    required this.challengeData,
  });
}

class WaitingChallengeAcceptScreen extends StatelessWidget {
  final WaitingChallengeAcceptScreenArgs args;

  const WaitingChallengeAcceptScreen({
    Key? key,
    required this.args,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WaitingChallengeAcceptBloc>(
      create: (BuildContext context) => WaitingChallengeAcceptBloc(
        challengeId: args.challengeId,
        challenge: args.challengeData,
      ),
      child: const _WaitingChallengeAcceptScreen(),
    );
  }
}

class _WaitingChallengeAcceptScreen extends StatelessWidget {
  const _WaitingChallengeAcceptScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WaitingChallengeAcceptBloc,
        WaitingChallengeAcceptState>(
      listener: (BuildContext context, WaitingChallengeAcceptState state) {},
      builder: (BuildContext context, WaitingChallengeAcceptState state) {
        // TODO implement screen
        return Container();
      },
    );
  }
}
