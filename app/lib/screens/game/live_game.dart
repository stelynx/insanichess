import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insanichess/insanichess.dart' as insanichess;

import '../../bloc/game/live_game_bloc.dart';
import '../../bloc/global/global_bloc.dart';
import '../../router/router.dart';
import '../../services/backend_service.dart';
import '../../services/wss_service.dart';
import '../../style/constants.dart';
import '../../util/extensions/duration.dart';
import '../../widgets/ic_board.dart';
import '../../widgets/ic_button.dart';
import '../../widgets/ic_game_history_tape.dart';

class LiveGameScreenArgs {
  final String liveGameId;

  const LiveGameScreenArgs({required this.liveGameId});
}

class LiveGameScreen extends StatelessWidget {
  final LiveGameScreenArgs args;

  const LiveGameScreen({Key? key, required this.args}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LiveGameBloc>(
      create: (BuildContext context) => LiveGameBloc(
        liveGameId: args.liveGameId,
        globalBloc: GlobalBloc.instance,
        backendService: BackendService.instance,
        wssService: WssService.instance,
      ),
      child: const _LiveGameScreen(),
    );
  }
}

class _LiveGameScreen extends StatelessWidget {
  const _LiveGameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LiveGameBloc bloc = BlocProvider.of<LiveGameBloc>(context);

    final double logoSize = getLogoSize(context);

    return BlocConsumer<LiveGameBloc, LiveGameState>(
      listener: (BuildContext context, LiveGameState state) {
        if (state.failedToJoinTheGame) {
          showCupertinoDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: const Text('Failed to join the game'),
                content: const Text(
                    'Unfortunately, we were unable to connect you with server.'),
                actions: <CupertinoDialogAction>[
                  CupertinoDialogAction(
                    onPressed: () {
                      int i = 0;
                      ICRouter.popUntil(context, () => i++ == 2, 1);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
          return;
        }

        if (state.gameDisbanded) {
          showCupertinoDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: const Text('Game disbanded'),
                content: const Text(
                    'Sadly, white did not move and the game was disbanded.'),
                actions: <CupertinoDialogAction>[
                  CupertinoDialogAction(
                    onPressed: () {
                      int i = 0;
                      ICRouter.popUntil(context, () => i++ == 2, 1);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
          return;
        }

        if (state.game!.isGameOver) {
          final String title;
          final String content;
          switch (state.game!.status) {
            case insanichess.GameStatus.draw:
              title = 'Game drawn';
              content = 'Fair and square!';
              break;
            case insanichess.GameStatus.whiteCheckmated:
              if (state.myColor == insanichess.PieceColor.white) {
                title = 'Victory!';
                content = 'Great job, you captured the enemy king!';
              } else {
                title = 'Defeat';
                content = 'Oh snap, the opponent captured your king!';
              }
              break;
            case insanichess.GameStatus.blackCheckmated:
              if (state.myColor == insanichess.PieceColor.black) {
                title = 'Victory!';
                content = 'Great job, you captured the enemy king!';
              } else {
                title = 'Defeat';
                content = 'Oh snap, the opponent captured your king!';
              }
              break;
            case insanichess.GameStatus.whiteFlagged:
              if (state.myColor == insanichess.PieceColor.black) {
                title = 'Victory!';
                content = 'White lost on time.';
              } else {
                title = 'Defeat';
                content = 'You lost on time.';
              }
              break;
            case insanichess.GameStatus.blackFlagged:
              if (state.myColor == insanichess.PieceColor.white) {
                title = 'Victory!';
                content = 'Black lost on time.';
              } else {
                title = 'Defeat';
                content = 'You lost on time.';
              }
              break;
            case insanichess.GameStatus.whiteResigned:
              if (state.myColor == insanichess.PieceColor.black) {
                title = 'Victory!';
                content = 'White resigned.';
              } else {
                title = 'Defeat';
                content = 'You lost by resignation.';
              }
              break;
            case insanichess.GameStatus.blackResigned:
              if (state.myColor == insanichess.PieceColor.white) {
                title = 'Victory!';
                content = 'Black resigned.';
              } else {
                title = 'Defeat';
                content = 'You lost by resignation.';
              }
              break;

            case insanichess.GameStatus.notStarted:
            case insanichess.GameStatus.playing:
              throw StateError(
                'The game is marked as finished but the status is ${state.game!.status}',
              );
          }

          showCupertinoDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: Text(title),
                content: Text(content),
              );
            },
          );
          return;
        }
      },
      builder: (BuildContext context, LiveGameState state) {
        if (state.game == null) {
          return CupertinoPageScaffold(
            child: Center(
              child: Column(
                children: <Widget>[
                  const CupertinoActivityIndicator(),
                  SizedBox(height: logoSize / 20),
                  Text(
                    'Connecting to game\n${bloc.liveGameId}',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        final bool isWhiteBottom =
            state.myColor == insanichess.PieceColor.white;

        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            border: const Border(),
            leading: CupertinoNavigationBarBackButton(
              onPressed: () {
                if (state.game!.isGameOver || state.gameDisbanded) {
                  ICRouter.pop(context);
                  return;
                }

                showCupertinoDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      title: const Text('Abandon and resign the game?'),
                      content: const Text(
                          'Are you sure you want to quit playing this game?'),
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
                            bloc.resign();
                          },
                          child: const Text('Resign'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            middle: Column(
              children: <Widget>[
                Text(
                    '${state.game!.whitePlayer.username} - ${state.game!.blackPlayer.username}'),
                Text(
                  state.game!.id,
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .textStyle
                      .copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ICGameHistoryTape(
                  moves: state.game!.movesPlayed,
                  movesFromFuture: state.game!.movesFromFuture,
                ),
                const Spacer(),
                Text(
                  (isWhiteBottom
                          ? (state.game!.playerOnTurn ==
                                  insanichess.PieceColor.white
                              ? state.game!.remainingTimeBlack
                              : state.game!.remainingTimeBlack -
                                  state.currentMoveDuration)
                          : state.game!.status ==
                                  insanichess.GameStatus.notStarted
                              ? (const Duration(seconds: 30) -
                                  state.currentMoveDuration)
                              : (state.game!.playerOnTurn ==
                                      insanichess.PieceColor.black
                                  ? state.game!.remainingTimeWhite
                                  : state.game!.remainingTimeWhite -
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
                              (!isWhiteBottom &&
                                          state.game!.playerOnTurn ==
                                              insanichess.PieceColor.white) ||
                                      (isWhiteBottom &&
                                          state.game!.playerOnTurn ==
                                              insanichess.PieceColor.black)
                                  ? 1
                                  : 0.5,
                            ),
                      ),
                ),
                const Spacer(),
                ICBoard(
                  game: state.game!,
                  onMove: bloc.move,
                  isWhiteBottom: isWhiteBottom,
                  mirrorTopPieces: false,
                  showLegalMoves: state.showLegalMoves,
                  autoPromoteToQueen: state.autoPromoteToQueen,
                  resetZoomStream: bloc.resetZoomStream,
                  onZoomChanged: bloc.zoomChanged,
                ),
                SizedBox(height: logoSize / 20),
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
                    const SizedBox(width: 10.0),
                    ICGameControlButton(
                      icon: CupertinoIcons.restart,
                      isPressed: state.game!.playerRequestedUndo != null,
                      onPressed: !state.game!.inProgress ||
                              !bloc.canUndo() ||
                              (state.game!.playerRequestedUndo ==
                                      state.myColor &&
                                  state.undoRequestResponded == true)
                          ? null
                          : state.game!.playerRequestedUndo == state.myColor
                              ? bloc.cancelUndo
                              : state.game!.playerRequestedUndo == null
                                  ? bloc.requestUndo
                                  : () => showCupertinoDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            title: const Text('Accept undo?'),
                                            actions: <CupertinoDialogAction>[
                                              CupertinoDialogAction(
                                                onPressed: () {
                                                  // Ok to use navigator here.
                                                  Navigator.of(context).pop();
                                                  bloc.respondToUndo(false);
                                                },
                                                child: const Text('No'),
                                              ),
                                              CupertinoDialogAction(
                                                onPressed: () {
                                                  // Ok to use navigator here.
                                                  Navigator.of(context).pop();
                                                  bloc.respondToUndo(true);
                                                },
                                                child: const Text('Yes'),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                    ),
                    const SizedBox(width: 10.0),
                    ICGameControlButton(
                      icon: CupertinoIcons.square_lefthalf_fill,
                      isPressed: state.game!.playerOfferedDraw != null,
                      onPressed: !state.game!.inProgress ||
                              state.game!.playerOfferedDraw == state.myColor &&
                                  state.drawOfferResponded == true
                          ? null
                          : state.game!.playerOfferedDraw == state.myColor
                              ? bloc.cancelOfferDraw
                              : state.game!.playerOfferedDraw == null
                                  ? bloc.offerDraw
                                  : () => showCupertinoDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            title: const Text(
                                              'Accept draw offer?',
                                            ),
                                            actions: <CupertinoDialogAction>[
                                              CupertinoDialogAction(
                                                onPressed: () {
                                                  // Ok to use navigator here.
                                                  Navigator.of(context).pop();
                                                  bloc.respondToOfferDraw(
                                                      false);
                                                },
                                                child: const Text('No'),
                                              ),
                                              CupertinoDialogAction(
                                                onPressed: () {
                                                  // Ok to use navigator here.
                                                  Navigator.of(context).pop();
                                                  bloc.respondToOfferDraw(true);
                                                },
                                                child: const Text('Yes'),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                    ),
                    const SizedBox(width: 10.0),
                    ICGameControlButton(
                      icon: CupertinoIcons.flag_fill,
                      onPressed: !state.game!.inProgress
                          ? null
                          : () => showCupertinoDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoAlertDialog(
                                    title: const Text('Resign?'),
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
                                          bloc.resign();
                                          () => Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                },
                              ),
                    ),
                    // const SizedBox(width: 10.0),
                    // ICGameControlButton(
                    //   icon: CupertinoIcons.add,
                    //   onPressed: () => showCupertinoDialog(
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return CupertinoAlertDialog(
                    //         title: const Text('Play again?'),
                    //         content: const Text(
                    //           'This action will challenge the opponent to a new game.',
                    //         ),
                    //         actions: <CupertinoDialogAction>[
                    //           CupertinoDialogAction(
                    //             child: const Text('No'),
                    //             onPressed: () => ICRouter.pop(context),
                    //           ),
                    //           CupertinoDialogAction(
                    //             child: const Text('Yes'),
                    //             isDestructiveAction: true,
                    //             onPressed: () {
                    //               bloc.newGame();
                    //               () => ICRouter.pop(context);
                    //             },
                    //           )
                    //         ],
                    //       );
                    //     },
                    //   ),
                    // ),

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
                const Spacer(),
                Text(
                  (!isWhiteBottom
                          ? (state.game!.playerOnTurn ==
                                  insanichess.PieceColor.white
                              ? state.game!.remainingTimeBlack
                              : state.game!.remainingTimeBlack -
                                  state.currentMoveDuration)
                          : state.game!.status ==
                                  insanichess.GameStatus.notStarted
                              ? (const Duration(seconds: 30) -
                                  state.currentMoveDuration)
                              : (state.game!.playerOnTurn ==
                                      insanichess.PieceColor.black
                                  ? state.game!.remainingTimeWhite
                                  : state.game!.remainingTimeWhite -
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
                              (isWhiteBottom &&
                                          state.game!.playerOnTurn ==
                                              insanichess.PieceColor.white) ||
                                      (!isWhiteBottom &&
                                          state.game!.playerOnTurn ==
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
