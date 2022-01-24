import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/join_game_with_id/join_game_with_id_bloc.dart';
import '../../router/router.dart';
import '../../router/routes.dart';
import '../../services/backend_service.dart';
import '../../style/constants.dart';
import '../../util/failures/backend_failure.dart';
import '../../widgets/ic_button.dart';
import '../../widgets/ic_text_field.dart';
import '../game/live_game.dart';

class JoinGameWithIdScreen extends StatelessWidget {
  const JoinGameWithIdScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<JoinGameWithIdBloc>(
      create: (BuildContext context) => JoinGameWithIdBloc(
        backendService: BackendService.instance,
      ),
      child: const _JoinGameWithIdScreen(),
    );
  }
}

class _JoinGameWithIdScreen extends StatelessWidget {
  const _JoinGameWithIdScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final JoinGameWithIdBloc bloc =
        BlocProvider.of<JoinGameWithIdBloc>(context);

    final double logoSize = getLogoSize(context);

    return BlocConsumer<JoinGameWithIdBloc, JoinGameWithIdState>(
      listener: (BuildContext context, JoinGameWithIdState state) {
        if (state.joiningSuccessful == true) {
          ICRouter.popAndPushNamed(
            context,
            ICRoute.gameLive,
            arguments: LiveGameScreenArgs(liveGameId: state.gameId),
          );
        }
      },
      builder: (BuildContext context, JoinGameWithIdState state) {
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: const Text('Join Game With ID'),
            border: const Border(),
            leading: CupertinoNavigationBarBackButton(
              onPressed: () => ICRouter.pop(context),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Text(
                        'To join a game with your friend, ask him to send you the game id of the game he created.'),
                    SizedBox(height: logoSize / 10),
                    ICTextField(
                      placeholder: 'Game ID',
                      onChanged: bloc.changeId,
                    ),
                    SizedBox(height: logoSize / 40),
                    ICPrimaryButton(
                      text: 'Join',
                      onPressed: state.isLoading ? null : bloc.join,
                    ),
                    if (state.backendFailure != null) ...[
                      SizedBox(height: logoSize / 10),
                      Text(
                        state.backendFailure is NotFoundBackendFailure
                            ? 'Challenge with given id was not found'
                            : state.backendFailure is ForbiddenBackendFailure
                                ? 'You cannot join this challenge'
                                : 'Something went wrong on our side',
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: CupertinoColors.systemRed),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
