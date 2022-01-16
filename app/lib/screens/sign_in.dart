import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../bloc/global/global_bloc.dart';
import '../bloc/sign_in/sign_in_bloc.dart';
import '../router/router.dart';
import '../router/routes.dart';
import '../services/auth_service.dart';
import '../services/backend_service.dart';
import '../services/local_storage_service.dart';
import '../style/images.dart';
import '../util/failures/backend_failure.dart';
import '../util/failures/validation_failure.dart';
import '../widgets/ic_button.dart';
import '../widgets/ic_text_field.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignInBloc>(
      create: (BuildContext context) => SignInBloc(
        globalBloc: GlobalBloc.instance,
        authService: AuthService.instance,
        backendService: BackendService.instance,
        localStorageService: LocalStorageService.instance,
      ),
      child: const _SignInScreen(),
    );
  }
}

class _SignInScreen extends StatelessWidget {
  const _SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SignInBloc bloc = BlocProvider.of<SignInBloc>(context);

    return BlocConsumer<SignInBloc, SignInState>(
      listener: (BuildContext context, SignInState state) {
        if (state.signInSuccessful ?? false) {
          if (state.hasPlayerProfile!) {
            ICRouter.pushNamed(context, ICRoute.home);
          } else {
            ICRouter.pushNamed(context, ICRoute.playerRegistration);
          }
          return;
        }
      },
      builder: (BuildContext context, SignInState state) {
        final double logoSize =
            min(400.0, MediaQuery.of(context).size.width / 3 * 2);

        final String? errorMessage;
        if (state.failure == null) {
          errorMessage = null;
        } else if (state.failure is EmailValidationFailure) {
          errorMessage = 'Please, enter a valid email';
        } else if (state.failure is PasswordValidationFailure) {
          errorMessage = 'Please, enter a valid password';
        } else if (state.failure is NotFoundBackendFailure) {
          errorMessage = 'Wrong email / password combination';
        } else if (state.failure is ForbiddenBackendFailure) {
          errorMessage = 'Email already in use';
        } else if (state.failure is BadRequestBackendFailure) {
          errorMessage = 'Please, enter a valid email and password';
        } else if (state.failure is InternalServerErrorBackendFailure) {
          errorMessage =
              'Something went wrong on our side. Please try again later.';
        } else {
          errorMessage =
              'Something went wrong on our side. Please try again later.';
        }

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
                    ICTextField(
                      placeholder: 'Email',
                      onChanged: bloc.emailChanged,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: logoSize / 40),
                    ICTextField(
                      placeholder: 'Password',
                      onChanged: bloc.passwordChanged,
                      obscureText: true,
                    ),
                    SizedBox(height: logoSize / 40),
                    if (errorMessage != null) ...[
                      Text(
                        errorMessage,
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: CupertinoColors.systemRed),
                      ),
                      SizedBox(height: logoSize / 40),
                    ],
                    ICPrimaryButton(
                      text: 'Sign in',
                      onPressed: state.isLoading ? null : bloc.signIn,
                    ),
                    SizedBox(height: logoSize / 20),
                    ICSecondaryButton(
                      text: 'Register',
                      onPressed: state.isLoading ? null : bloc.register,
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
