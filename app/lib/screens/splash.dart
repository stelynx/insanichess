import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../bloc/global/global_bloc.dart';
import '../bloc/splash_screen/splash_screen_bloc.dart';
import '../router/routes.dart';
import '../services/local_storage_service.dart';
import '../style/images.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashScreenBloc>(
      create: (BuildContext context) => SplashScreenBloc(
        globalBloc: GlobalBloc.instance,
        localStorageService: LocalStorageService.instance,
      ),
      child: const _SplashScreen(),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashScreenBloc, SplashScreenState>(
      listener: (BuildContext context, SplashScreenState state) {
        if (state.initialized) {
          if (state.authenticated ?? false) {
            Navigator.of(context).pushNamed(ICRoute.home);
            return;
          }
          Navigator.of(context).pushNamed(ICRoute.signIn);
          return;
        }
      },
      builder: (BuildContext context, SplashScreenState state) {
        final double logoSize =
            min(400.0, MediaQuery.of(context).size.width / 3 * 2) +
                state.deltaLogoSize;
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
