import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../bloc/home/home_bloc.dart';
import '../bloc/online_play/online_play_bloc.dart';
import '../router/router.dart';
import '../router/routes.dart';
import '../services/backend_service.dart';
import '../style/constants.dart';
import '../style/images.dart';
import '../util/functions/to_display_string.dart';
import '../widgets/ic_button.dart';
import '../widgets/ic_drawer.dart';
import '../widgets/ic_segmented_control.dart';
import 'game/otb_game.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (BuildContext context) => HomeBloc(
        backendService: BackendService.instance,
      ),
      child: const _HomeScreen(),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeBloc bloc = BlocProvider.of<HomeBloc>(context);

    return BlocConsumer<HomeBloc, HomeState>(
      listener: (BuildContext context, HomeState state) {},
      builder: (BuildContext context, HomeState state) {
        final double logoSize = getLogoSize(context);

        return ICDrawer(
          key: bloc.drawerKey,
          scaffold: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              automaticallyImplyLeading: false,
              border: const Border(),
              trailing: ICTrailingButton(
                icon: CupertinoIcons.line_horizontal_3,
                // must not shortcut to: bloc.drawerKey.currentState?.open
                onPressed: () => bloc.drawerKey.currentState?.open(),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Center(
                  child: SizedBox(
                    width: min(500, MediaQuery.of(context).size.width - 60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const Spacer(),
                        Hero(
                          tag: 'hero',
                          child: SvgPicture.asset(
                            MediaQuery.of(context).platformBrightness ==
                                    Brightness.light
                                ? ICImage.logoLight
                                : ICImage.logoDark,
                            width: logoSize,
                            height: logoSize,
                          ),
                        ),
                        SizedBox(height: logoSize / 10),
                        ICPrimaryButton(
                          text: 'Play Online',
                          onPressed: () =>
                              ICRouter.pushNamed(context, ICRoute.onlinePlay),
                        ),
                        SizedBox(height: logoSize / 40),
                        ICSecondaryButton(
                          text: 'Play OTB',
                          onPressed: () => showCupertinoDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: CupertinoTheme.of(context)
                                        .scaffoldBackgroundColor,
                                    borderRadius: kBorderRadius,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12.0,
                                        ),
                                        child: Text('Choose time control'),
                                      ),
                                      ICSegmentedControl<
                                          InsanichessTimeControl>(
                                        value: null,
                                        items: OnlinePlayBloc
                                            .availableTimeControls,
                                        labels: OnlinePlayBloc
                                            .availableTimeControls
                                            .map<String>((InsanichessTimeControl
                                                    tc) =>
                                                timeControlToDisplayStringShort(
                                                    tc))
                                            .toList(),
                                        onChanged: (InsanichessTimeControl tc) {
                                          // Ok to use navigator here.
                                          Navigator.of(context).pop();
                                          ICRouter.pushNamed(
                                            context,
                                            ICRoute.gameOtb,
                                            arguments: OtbGameScreenArgs(
                                              gameBeingShown: null,
                                              timeControl: tc,
                                            ),
                                          );
                                        },
                                        width: min(
                                          400,
                                          MediaQuery.of(context).size.width -
                                              32,
                                        ),
                                        maxItemsInRow: 3,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Players online: ${state.onlinePlayers ?? 'N/A'}',
                              style: CupertinoTheme.of(context)
                                  .textTheme
                                  .textStyle
                                  .copyWith(fontSize: 12),
                            ),
                            Text(
                              'Live games: ${state.gamesInProgress ?? 'N/A'}',
                              style: CupertinoTheme.of(context)
                                  .textTheme
                                  .textStyle
                                  .copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                        if (MediaQuery.of(context).padding.bottom == 0)
                          const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
