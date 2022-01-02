import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../bloc/sign_in/sign_in_bloc.dart';
import '../router/routes.dart';
import '../style/images.dart';
import '../widgets/ic_button.dart';
import 'game.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignInBloc>(
      create: (BuildContext context) => SignInBloc(),
      child: const _SignInScreen(),
    );
  }
}

class _SignInScreen extends StatelessWidget {
  const _SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInBloc, SignInState>(
      listener: (BuildContext context, SignInState state) {},
      builder: (BuildContext context, SignInState state) {
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
