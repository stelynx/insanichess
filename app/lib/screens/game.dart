import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../bloc/game/game_bloc.dart';
import '../bloc/global/global_bloc.dart';
import '../services/local_storage_service.dart';
import '../widgets/ic_board.dart';
import '../widgets/ic_button.dart';

class GameScreenArgs {
  final InsanichessGame? gameBeingShown;

  const GameScreenArgs({required this.gameBeingShown});
}

class GameScreen extends StatelessWidget {
  final GameScreenArgs args;

  const GameScreen({Key? key, required this.args}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameBloc>(
      create: (BuildContext context) => GameBloc(
        localStorageService: LocalStorageService.instance,
        gameBeingShown: args.gameBeingShown,
        isOtb: true,
        settings: GlobalBloc.instance.state.settings!,
      ),
      child: const _GameScreen(),
    );
  }
}

class _GameScreen extends StatelessWidget {
  const _GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameBloc bloc = BlocProvider.of<GameBloc>(context);

    return BlocConsumer<GameBloc, GameState>(
      listener: (BuildContext context, GameState state) {},
      builder: (BuildContext context, GameState state) {
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            leading: CupertinoNavigationBarBackButton(
              onPressed: () {
                if (!state.game.inProgress) {
                  Navigator.of(context).pop();
                  return;
                }

                showCupertinoDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      title: const Text('Quit game?'),
                      content: const Text(
                          'This action will delete the game in progress. Are you sure you want to quit playing this game?'),
                      actions: <CupertinoDialogAction>[
                        CupertinoDialogAction(
                          child: const Text('Keep Playing'),
                          onPressed: Navigator.of(context).pop,
                        ),
                        CupertinoDialogAction(
                          isDestructiveAction: true,
                          onPressed: () {
                            int i = 0;
                            Navigator.of(context).popUntil((_) => i++ == 2);
                          },
                          child: const Text('Quit'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            middle: Text('Game ${state.game.id}'),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ICBoard(
                  game: state.game,
                  onMove: bloc.move,
                  isWhiteBottom: state.isWhiteBottom,
                  mirrorTopPieces: state.mirrorTopPieces,
                  showLegalMoves: state.showLegalMoves,
                  autoPromoteToQueen: state.autoPromoteToQueen,
                  resetZoomStream: bloc.resetZoomStream,
                  onZoomChanged: bloc.zoomChanged,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (state.showZoomOutButtonOnLeft) ...[
                      ICGameControlButton(
                        icon: CupertinoIcons.zoom_out,
                        onPressed:
                            state.enableZoomButton ? bloc.resetZoom : null,
                      ),
                      const SizedBox(width: 10.0),
                    ],
                    ICGameControlButton(
                      icon: CupertinoIcons.back,
                      onPressed: bloc.canGoBackward() ? bloc.backward : null,
                    ),
                    const SizedBox(width: 10.0),
                    ICGameControlButton(
                      icon: CupertinoIcons.forward,
                      onPressed: bloc.canGoForward() ? bloc.forward : null,
                    ),
                    if (bloc.isLiveGame()) ...[
                      const SizedBox(width: 10.0),
                      if (state.allowUndo) ...[
                        ICGameControlButton(
                          icon: CupertinoIcons.restart,
                          onPressed: bloc.canUndo() ? bloc.undo : null,
                        ),
                        const SizedBox(width: 10.0),
                      ],
                      ICGameControlButton(
                        icon: CupertinoIcons.flag_fill,
                        onPressed: !state.game.inProgress
                            ? null
                            : () => showCupertinoDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CupertinoAlertDialog(
                                      title: const Text('Agree to a draw?'),
                                      content: const Text(
                                        'Are you sure you want to finish the game with a draw? The action cannot be undone.',
                                      ),
                                      actions: <CupertinoDialogAction>[
                                        CupertinoDialogAction(
                                          child: const Text('No'),
                                          onPressed: Navigator.of(context).pop,
                                        ),
                                        CupertinoDialogAction(
                                          child: const Text('Yes'),
                                          isDefaultAction: true,
                                          onPressed: () {
                                            bloc.agreeToDraw();
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    );
                                  },
                                ),
                      ),
                      const SizedBox(width: 10.0),
                      ICGameControlButton(
                        icon: CupertinoIcons.add,
                        onPressed: () => showCupertinoDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              title: const Text('Restart game?'),
                              content: const Text(
                                'Are you sure you want to restart the game? The action cannot be undone.',
                              ),
                              actions: <CupertinoDialogAction>[
                                CupertinoDialogAction(
                                  child: const Text('No'),
                                  onPressed: Navigator.of(context).pop,
                                ),
                                CupertinoDialogAction(
                                  child: const Text('Yes'),
                                  isDestructiveAction: true,
                                  onPressed: () {
                                    bloc.newGame();
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                    if (!state.showZoomOutButtonOnLeft) ...[
                      const SizedBox(width: 10.0),
                      ICGameControlButton(
                        icon: CupertinoIcons.zoom_out,
                        onPressed:
                            state.enableZoomButton ? bloc.resetZoom : null,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
