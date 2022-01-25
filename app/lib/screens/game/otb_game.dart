import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insanichess/insanichess.dart' as insanichess;
import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../../bloc/game/otb_game_bloc.dart';
import '../../bloc/global/global_bloc.dart';
import '../../router/router.dart';
import '../../services/local_storage_service.dart';
import '../../util/extensions/duration.dart';
import '../../widgets/ic_board.dart';
import '../../widgets/ic_button.dart';
import '../../widgets/ic_game_history_tape.dart';

class OtbGameScreenArgs {
  final InsanichessGame? gameBeingShown;
  final InsanichessTimeControl? timeControl;

  const OtbGameScreenArgs({
    required this.gameBeingShown,
    required this.timeControl,
  }) : assert((gameBeingShown == null && timeControl != null) ||
            (gameBeingShown != null && timeControl == null));
}

class OtbGameScreen extends StatelessWidget {
  final OtbGameScreenArgs args;

  const OtbGameScreen({Key? key, required this.args}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OtbGameBloc>(
      create: (BuildContext context) => OtbGameBloc(
        localStorageService: LocalStorageService.instance,
        gameBeingShown: args.gameBeingShown,
        timeControl: args.timeControl,
        settings: GlobalBloc.instance.state.settings!,
      ),
      child: const _OtbGameScreen(),
    );
  }
}

class _OtbGameScreen extends StatelessWidget {
  const _OtbGameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OtbGameBloc bloc = BlocProvider.of<OtbGameBloc>(context);

    final double iconSize =
        min(24, (MediaQuery.of(context).size.width - 8 * 6) / 7);

    return BlocConsumer<OtbGameBloc, OtbGameState>(
      listener: (BuildContext context, OtbGameState state) {},
      builder: (BuildContext context, OtbGameState state) {
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            border: const Border(),
            leading: CupertinoNavigationBarBackButton(
              onPressed: () {
                if (!state.game.inProgress) {
                  ICRouter.pop(context);
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
                          onPressed: () => ICRouter.pop(context),
                        ),
                        CupertinoDialogAction(
                          isDestructiveAction: true,
                          onPressed: () {
                            int i = 0;
                            ICRouter.popUntil(context, () => i++ == 2, 1);
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
                ICGameHistoryTape(
                  moves: state.game.movesPlayed,
                  movesFromFuture: state.game.movesFromFuture,
                ),
                const Spacer(),
                Text(
                  (state.isWhiteBottom
                          ? (state.game.playerOnTurn ==
                                  insanichess.PieceColor.white
                              ? state.game.remainingTimeBlack
                              : state.game.remainingTimeBlack -
                                  state.currentMoveDuration)
                          : (state.game.playerOnTurn ==
                                  insanichess.PieceColor.black
                              ? state.game.remainingTimeWhite
                              : state.game.remainingTimeWhite -
                                  state.currentMoveDuration))
                      .toClockString(),
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .textStyle
                      .copyWith(
                        fontSize: 24,
                        color: CupertinoTheme.of(context)
                            .primaryColor
                            .withOpacity(
                              (!state.isWhiteBottom &&
                                          state.game.playerOnTurn ==
                                              insanichess.PieceColor.white) ||
                                      (state.isWhiteBottom &&
                                          state.game.playerOnTurn ==
                                              insanichess.PieceColor.black)
                                  ? 1
                                  : 0.5,
                            ),
                      ),
                ),
                const Spacer(),
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
                        size: iconSize,
                        onPressed:
                            state.enableZoomButton ? bloc.resetZoom : null,
                      ),
                      const SizedBox(width: 6.0),
                    ],
                    ICGameControlButton(
                      icon: CupertinoIcons.back,
                      size: iconSize,
                      onPressed: bloc.canGoBackward() ? bloc.backward : null,
                    ),
                    const SizedBox(width: 6.0),
                    ICGameControlButton(
                      icon: CupertinoIcons.forward,
                      size: iconSize,
                      onPressed: bloc.canGoForward() ? bloc.forward : null,
                    ),
                    if (bloc.isLiveGame()) ...[
                      const SizedBox(width: 6.0),
                      if (state.allowUndo) ...[
                        ICGameControlButton(
                          icon: CupertinoIcons.restart,
                          size: iconSize,
                          onPressed: bloc.canUndo() ? bloc.undo : null,
                        ),
                        const SizedBox(width: 6.0),
                      ],
                      ICGameControlButton(
                        icon: CupertinoIcons.square_lefthalf_fill,
                        size: iconSize,
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
                                          onPressed: () =>
                                              ICRouter.pop(context),
                                        ),
                                        CupertinoDialogAction(
                                          child: const Text('Yes'),
                                          isDefaultAction: true,
                                          onPressed: () {
                                            bloc.agreeToDraw();
                                            () => ICRouter.pop(context);
                                          },
                                        )
                                      ],
                                    );
                                  },
                                ),
                      ),
                      const SizedBox(width: 6.0),
                      ICGameControlButton(
                        icon: CupertinoIcons.flag_fill,
                        size: iconSize,
                        onPressed: !state.game.inProgress
                            ? null
                            : () => showCupertinoDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CupertinoAlertDialog(
                                      title: Text(
                                        state.game.playerOnTurn ==
                                                insanichess.PieceColor.white
                                            ? 'White resigns?'
                                            : 'Black resigns?',
                                      ),
                                      content: const Text(
                                        'Are you sure you want to resign? The action cannot be undone.',
                                      ),
                                      actions: <CupertinoDialogAction>[
                                        CupertinoDialogAction(
                                          child: const Text('No'),
                                          // Ok to call navigator here.
                                          onPressed: Navigator.of(context).pop,
                                        ),
                                        CupertinoDialogAction(
                                          child: const Text('Yes'),
                                          isDefaultAction: true,
                                          onPressed: () {
                                            () => Navigator.of(context).pop();
                                            bloc.resign();
                                          },
                                        )
                                      ],
                                    );
                                  },
                                ),
                      ),
                      const SizedBox(width: 6.0),
                      ICGameControlButton(
                        icon: CupertinoIcons.add,
                        size: iconSize,
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
                                  onPressed: () => ICRouter.pop(context),
                                ),
                                CupertinoDialogAction(
                                  child: const Text('Yes'),
                                  isDestructiveAction: true,
                                  onPressed: () {
                                    bloc.newGame();
                                    () => ICRouter.pop(context);
                                  },
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                    if (!state.showZoomOutButtonOnLeft) ...[
                      const SizedBox(width: 6.0),
                      ICGameControlButton(
                        icon: CupertinoIcons.zoom_out,
                        size: iconSize,
                        onPressed:
                            state.enableZoomButton ? bloc.resetZoom : null,
                      ),
                    ],
                  ],
                ),
                const Spacer(),
                Text(
                  (!state.isWhiteBottom
                          ? (state.game.playerOnTurn ==
                                  insanichess.PieceColor.white
                              ? state.game.remainingTimeBlack
                              : state.game.remainingTimeBlack -
                                  state.currentMoveDuration)
                          : (state.game.playerOnTurn ==
                                  insanichess.PieceColor.black
                              ? state.game.remainingTimeWhite
                              : state.game.remainingTimeWhite -
                                  state.currentMoveDuration))
                      .toClockString(),
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .textStyle
                      .copyWith(
                        fontSize: 24,
                        color: CupertinoTheme.of(context)
                            .primaryColor
                            .withOpacity(
                              (state.isWhiteBottom &&
                                          state.game.playerOnTurn ==
                                              insanichess.PieceColor.white) ||
                                      (!state.isWhiteBottom &&
                                          state.game.playerOnTurn ==
                                              insanichess.PieceColor.black)
                                  ? 1
                                  : 0.5,
                            ),
                      ),
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
