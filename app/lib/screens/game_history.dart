import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insanichess/insanichess.dart' as insanichess;
import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../bloc/game_history/game_history_bloc.dart';
import '../router/routes.dart';
import '../services/local_storage_service.dart';
import '../widgets/util/cupertino_list_section.dart';
import '../widgets/util/cupertino_list_tile.dart';
import 'game.dart';

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
                        game.status == insanichess.GameStatus.whiteWon
                            ? '1 - 0'
                            : game.status == insanichess.GameStatus.blackWon
                                ? '0 - 1'
                                : '½ - ½',
                      ),
                      onTap: () => Navigator.of(context).pushNamed(
                        ICRoute.game,
                        arguments: GameScreenArgs(gameBeingShown: game),
                      ),
                    ),
                  )
                  .toList(),
            );
          }
        } else {
          child = Container();
        }

        return CupertinoPageScaffold(
          navigationBar: const CupertinoNavigationBar(
            middle: Text('Game History'),
            border: Border(),
          ),
          child: child,
        );
      },
    );
  }
}
