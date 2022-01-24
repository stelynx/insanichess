import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../bloc/global/global_bloc.dart';
import '../bloc/player_registration/player_registration_bloc.dart';
import '../router/router.dart';
import '../router/routes.dart';
import '../services/backend_service.dart';
import '../style/constants.dart';
import '../style/images.dart';
import '../util/failures/backend_failure.dart';
import '../util/failures/validation_failure.dart';
import '../widgets/ic_button.dart';
import '../widgets/ic_text_field.dart';

class PlayerRegistrationScreen extends StatelessWidget {
  const PlayerRegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlayerRegistrationBloc>(
      create: (BuildContext context) => PlayerRegistrationBloc(
        backendService: BackendService.instance,
        globalBloc: GlobalBloc.instance,
      ),
      child: const _PlayerRegistrationScreen(),
    );
  }
}

class _PlayerRegistrationScreen extends StatelessWidget {
  const _PlayerRegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlayerRegistrationBloc bloc =
        BlocProvider.of<PlayerRegistrationBloc>(context);

    final double logoSize = getLogoSize(context);

    return BlocConsumer<PlayerRegistrationBloc, PlayerRegistrationState>(
      listener: (BuildContext context, PlayerRegistrationState state) {
        if (state.isRegistrationSuccessful ?? false) {
          ICRouter.pushNamed(context, ICRoute.home);
          return;
        }
      },
      builder: (BuildContext context, PlayerRegistrationState state) {
        final String? errorMessage;
        if (state.failure == null) {
          errorMessage = null;
        } else if (state.failure is UsernameValidationFailure) {
          errorMessage =
              'Username must contain only alphanumeric characters and be at least 4 characters long';
        } else if (state.failure is ForbiddenBackendFailure) {
          errorMessage = 'Username is already taken';
        } else if (state.failure is BadRequestBackendFailure ||
            state.failure is UnauthorizedBackendFailure) {
          errorMessage =
              'Either a developer made a mistake or you should update the app';
        } else {
          errorMessage = 'Something went wrong on our side';
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
                      placeholder: 'Username',
                      onChanged: bloc.changeUsername,
                      keyboardType: TextInputType.name,
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
                      text: 'Submit',
                      onPressed: state.isLoading ? null : bloc.submit,
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
