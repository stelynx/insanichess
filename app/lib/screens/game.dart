import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/game/game_bloc.dart';
import '../bloc/global/global_bloc.dart';
import '../services/local_storage_service.dart';
import '../widgets/ic_board.dart';
import '../widgets/ic_button.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameBloc>(
      create: (BuildContext context) => GameBloc(
        localStorageService: LocalStorageService.instance,
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
                    const SizedBox(width: 10.0),
                    if (state.allowUndo) ...[
                      ICGameControlButton(
                        icon: CupertinoIcons.restart,
                        onPressed: bloc.canUndo() ? bloc.undo : null,
                      ),
                      const SizedBox(width: 10.0),
                    ],
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
                    if (!state.showZoomOutButtonOnLeft)
                      ICGameControlButton(
                        icon: CupertinoIcons.zoom_out,
                        onPressed:
                            state.enableZoomButton ? bloc.resetZoom : null,
                      ),
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
