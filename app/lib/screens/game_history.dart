import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../bloc/game_history/game_history_bloc.dart';
import '../router/router.dart';
import '../router/routes.dart';
import '../services/local_storage_service.dart';
import '../widgets/ic_button.dart';
import '../widgets/ic_drawer.dart';
import '../widgets/util/cupertino_list_section.dart';
import '../widgets/util/cupertino_list_tile.dart';
import 'game/otb_game.dart';

class GameHistoryScreen extends StatelessWidget {
  const GameHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameHistoryBloc>(
      create: (BuildContext context) => GameHistoryBloc(
        localStorageService: LocalStorageService.instance,
      ),
      child: const _GameHistoryScreen(),
    );
  }
}

class _GameHistoryScreen extends StatelessWidget {
  const _GameHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameHistoryBloc bloc = BlocProvider.of<GameHistoryBloc>(context);

    return BlocConsumer<GameHistoryBloc, GameHistoryState>(
      listener: (BuildContext context, GameHistoryState state) {},
      builder: (BuildContext context, GameHistoryState state) {
        final Widget child;
        if (state.isLoading) {
          child = const Center(child: CupertinoActivityIndicator());
        } else if (state.games != null) {
          if (state.games!.isEmpty) {
            child = const Center(
              child: Text('No games'),
            );
          } else {
            child = CupertinoListSection(
              hasLeading: false,
              backgroundColor:
                  CupertinoTheme.of(context).scaffoldBackgroundColor,
              children: state.games!
                  .map<Widget>(
                    (InsanichessGame game) => CupertinoListTile(
                      title: Text(game.id),
                      trailing: const CupertinoListTileChevron(),
                      additionalInfo: Text(
                        game.whiteWon
                            ? '1 - 0'
                            : game.blackWon
                                ? '0 - 1'
                                : '½ - ½',
                      ),
                      onTap: () => ICRouter.pushNamed(
                        context,
                        ICRoute.gameOtb,
                        arguments: OtbGameScreenArgs(
                          gameBeingShown: game,
                          timeControl: null,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            );
          }
        } else {
          child = Container();
        }

        return ICDrawer(
          key: bloc.drawerKey,
          scaffold: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text('Game History'),
              border: const Border(),
              trailing: ICTrailingButton(
                icon: CupertinoIcons.line_horizontal_3,
                // must not shortcut to: bloc.drawerKey.currentState?.open
                onPressed: () => bloc.drawerKey.currentState?.open(),
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }
}
