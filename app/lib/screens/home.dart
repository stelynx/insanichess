import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../bloc/home/home_bloc.dart';
import '../router/router.dart';
import '../router/routes.dart';
import '../style/constants.dart';
import '../style/images.dart';
import '../widgets/ic_button.dart';
import '../widgets/ic_drawer.dart';
import 'game/otb_game.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (BuildContext context) => HomeBloc(),
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
                          onPressed: () => ICRouter.pushNamed(
                            context,
                            ICRoute.gameOtb,
                            arguments:
                                const OtbGameScreenArgs(gameBeingShown: null),
                          ),
                        ),
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
