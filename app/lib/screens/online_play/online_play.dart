import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/online_play/online_play_bloc.dart';
import '../../util/functions/to_display_string.dart';
import '../../widgets/ic_button.dart';
import '../../widgets/ic_drawer.dart';
import '../../widgets/util/cupertino_list_section.dart';
import '../../widgets/util/cupertino_list_tile.dart';

class OnlinePlayScreen extends StatelessWidget {
  const OnlinePlayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnlinePlayBloc>(
      create: (BuildContext context) => OnlinePlayBloc(),
      child: const _OnlinePlayScreen(),
    );
  }
}

class _OnlinePlayScreen extends StatelessWidget {
  const _OnlinePlayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OnlinePlayBloc bloc = BlocProvider.of<OnlinePlayBloc>(context);

    return BlocConsumer<OnlinePlayBloc, OnlinePlayState>(
      listener: (BuildContext context, OnlinePlayState state) {},
      builder: (BuildContext context, OnlinePlayState state) {
        final double logoSize =
            min(400.0, MediaQuery.of(context).size.width / 3 * 2);

        return ICDrawer(
          key: bloc.drawerKey,
          scaffold: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text('Play Online'),
              border: const Border(),
              trailing: ICTrailingButton(
                icon: CupertinoIcons.line_horizontal_3,
                // must not shortcut to: bloc.drawerKey.currentState?.open
                onPressed: () => bloc.drawerKey.currentState?.open(),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  CupertinoListSection(
                    hasLeading: false,
                    header: const Text('GAME SETTINGS'),
                    backgroundColor:
                        CupertinoTheme.of(context).scaffoldBackgroundColor,
                    children: <Widget>[
                      CupertinoListTile(
                        title: const Text('Time control'),
                        additionalInfo: Text(
                          timeControlToDisplayString(state.timeControl),
                        ),
                        onTap: bloc.toggleEditingTimeControl,
                      ),
                      if (state.editingTimeControl)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Text('eDiting'),
                        ),
                      CupertinoListTile(
                        title: const Text('Preferred color'),
                        additionalInfo: Text(
                          preferredColorToDisplayString(state.preferColor),
                        ),
                        onTap: bloc.toggleEditingPreferColor,
                      ),
                      if (state.editingPreferColor)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Text('eDiting'),
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Center(
                      child: SizedBox(
                        width: min(500, MediaQuery.of(context).size.width - 60),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(height: logoSize / 10),
                            ICPrimaryButton(
                              text: 'Create a challenge',
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
