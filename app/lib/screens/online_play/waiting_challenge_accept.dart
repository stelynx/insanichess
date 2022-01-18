import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../../bloc/bloc/waiting_challenge_accept_bloc.dart';
import '../../router/router.dart';
import '../../services/backend_service.dart';
import '../../util/functions/to_display_string.dart';
import '../../widgets/ic_button.dart';
import '../../widgets/ic_countdown.dart';

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
        challenge: args.challengeData,
        challengeId: args.challengeId,
        backendService: BackendService.instance,
      ),
      child: const _WaitingChallengeAcceptScreen(),
    );
  }
}

class _WaitingChallengeAcceptScreen extends StatelessWidget {
  const _WaitingChallengeAcceptScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WaitingChallengeAcceptBloc bloc =
        BlocProvider.of<WaitingChallengeAcceptBloc>(context);

    final double paddingBottom = MediaQuery.of(context).padding.bottom;

    return BlocConsumer<WaitingChallengeAcceptBloc,
        WaitingChallengeAcceptState>(
      listener: (BuildContext context, WaitingChallengeAcceptState state) {
        if (state.challengeCancelled) {
          ICRouter.pop<bool>(context, false);
          return;
        }
        if (state.gameId != null) {
          // we shall start a game here
          return;
        }
        if (state.challengeDeclined) {
          ICRouter.pop<bool>(context, true);
        }
      },
      builder: (BuildContext context, WaitingChallengeAcceptState state) {
        return CupertinoPageScaffold(
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 50),
                  const Spacer(),
                  ICCountdown(
                    expiresIn: const Duration(minutes: 1),
                    onExpired: bloc.challengeExpired,
                    // periodicFetchDuration: const Duration(seconds: 1),
                    // periodicFetchCallback: () {},
                  ),
                  const SizedBox(height: 24),
                  const Text('Awaiting opponent'),
                  const SizedBox(height: 24),
                  Text(timeControlToDisplayString(bloc.challenge.timeControl)),
                  const SizedBox(height: 12),
                  Text(
                    'Color: ${preferredColorToDisplayString(bloc.challenge.preferColor)}',
                  ),
                  const Spacer(),
                  ICSecondaryButton(
                    text: 'Cancel challenge',
                    onPressed: state.cancellationInProgress
                        ? null
                        : bloc.cancelChallenge,
                  ),
                  if (paddingBottom == 0) const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
