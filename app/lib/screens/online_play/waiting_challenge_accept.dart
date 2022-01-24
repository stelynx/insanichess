import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../../bloc/waiting_challenge_accept/waiting_challenge_accept_bloc.dart';
import '../../router/router.dart';
import '../../router/routes.dart';
import '../../services/backend_service.dart';
import '../../style/colors.dart';
import '../../util/functions/to_display_string.dart';
import '../../widgets/ic_button.dart';
import '../../widgets/ic_countdown.dart';
import '../game/live_game.dart';

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
        if (state.challengeDeclined) {
          ICRouter.pop<bool>(context, true);
        }
        if (state.gameId != null) {
          ICRouter.popAndPushNamed(
            context,
            ICRoute.gameLive,
            arguments: LiveGameScreenArgs(liveGameId: state.gameId!),
          );
          return;
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
                  const Spacer(),
                  const SizedBox(height: 80),
                  const Spacer(),
                  ICCountdown(
                    expiresIn: const Duration(minutes: 1),
                    onExpired: bloc.challengeExpired,
                    periodicFetchDuration: const Duration(seconds: 1),
                    periodicFetchCallback: bloc.fetchData,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (state.idCopiedToClipboard)
                        Icon(
                          CupertinoIcons.check_mark,
                          color: CupertinoTheme.of(context)
                              .scaffoldBackgroundColor,
                          size: CupertinoTheme.of(context)
                              .textTheme
                              .textStyle
                              .fontSize,
                        ),
                      ICTextButton(
                        text: 'Copy ID to clipboard',
                        onPressed: bloc.copyIdToClipboard,
                      ),
                      if (state.idCopiedToClipboard)
                        Icon(
                          CupertinoIcons.check_mark,
                          color: ICColor.confirm,
                          size: CupertinoTheme.of(context)
                              .textTheme
                              .textStyle
                              .fontSize,
                        ),
                    ],
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
