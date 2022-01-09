import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../bloc/home/home_bloc.dart';
import '../router/routes.dart';
import '../style/images.dart';
import '../widgets/ic_button.dart';
import 'game.dart';

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
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (BuildContext context, HomeState state) {},
      builder: (BuildContext context, HomeState state) {
        final double logoSize =
            min(400.0, MediaQuery.of(context).size.width / 3 * 2);
        return CupertinoPageScaffold(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Center(
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
                      text: 'Play',
                      onPressed: () => Navigator.of(context).pushNamed(
                        ICRoute.game,
                        arguments: const GameScreenArgs(gameBeingShown: null),
                      ),
                    ),
                    SizedBox(height: logoSize / 40),
                    ICSecondaryButton(
                      text: 'Game History',
                      onPressed: () =>
                          Navigator.of(context).pushNamed(ICRoute.gameHistory),
                    ),
                    SizedBox(height: logoSize / 40),
                    ICSecondaryButton(
                      text: 'Rules',
                      onPressed: () =>
                          Navigator.of(context).pushNamed(ICRoute.rules),
                    ),
                    SizedBox(height: logoSize / 40),
                    ICSecondaryButton(
                      text: 'Settings',
                      onPressed: () =>
                          Navigator.of(context).pushNamed(ICRoute.settings),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
