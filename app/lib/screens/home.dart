import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc/game_bloc.dart';
import '../widgets/ic_board.dart';
import '../widgets/ic_game_control_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameBloc>(
      create: (BuildContext context) => GameBloc(),
      child: const _HomeScreen(),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen({Key? key}) : super(key: key);

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
                  board: state.game.board,
                  onMove: bloc.move,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
                      onPressed: bloc.canUndo() ? bloc.undo : null,
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
