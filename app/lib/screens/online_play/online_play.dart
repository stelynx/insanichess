import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insanichess/insanichess.dart' as insanichess;
import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../../bloc/global/global_bloc.dart';
import '../../bloc/online_play/online_play_bloc.dart';
import '../../router/router.dart';
import '../../router/routes.dart';
import '../../services/backend_service.dart';
import '../../services/local_storage_service.dart';
import '../../style/colors.dart';
import '../../style/constants.dart';
import '../../util/functions/to_display_string.dart';
import '../../widgets/ic_button.dart';
import '../../widgets/ic_drawer.dart';
import '../../widgets/ic_segmented_control.dart';
import '../../widgets/ic_toast.dart';
import '../../widgets/util/cupertino_list_section.dart';
import '../../widgets/util/cupertino_list_tile.dart';
import 'waiting_challenge_accept.dart';

class OnlinePlayScreen extends StatelessWidget {
  const OnlinePlayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnlinePlayBloc>(
      create: (BuildContext context) => OnlinePlayBloc(
        backendService: BackendService.instance,
        localStorageService: LocalStorageService.instance,
        globalBloc: GlobalBloc.instance,
      ),
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
      listener: (BuildContext context, OnlinePlayState state) async {
        if (state.createdChallengeId != null) {
          final challengeDeclined = await ICRouter.pushNamed<bool>(
            context,
            ICRoute.waitingChallengeAccept,
            arguments: WaitingChallengeAcceptScreenArgs(
              challengeId: state.createdChallengeId!,
              challengeData: InsanichessChallenge(
                createdBy: null,
                timeControl: state.timeControl,
                preferColor: state.preferColor,
                isPrivate: state.isPrivate,
                status: ChallengeStatus.initiated,
              ),
            ),
          );

          if (challengeDeclined ?? false) {
            bloc.showChallengeDeclinedToast();
          }
        }
      },
      builder: (BuildContext context, OnlinePlayState state) {
        final double logoSize = getLogoSize(context);

        Widget child = ICDrawer(
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: ICSegmentedControl<InsanichessTimeControl>(
                            value: state.timeControl,
                            items: bloc.availableTimeControls,
                            labels: bloc.availableTimeControls
                                .map<String>((InsanichessTimeControl tc) =>
                                    timeControlToDisplayStringShort(tc))
                                .toList(),
                            onChanged: bloc.changeTimeControl,
                            width: min(
                              400,
                              MediaQuery.of(context).size.width - 32,
                            ),
                            maxItemsInRow: 3,
                          ),
                        ),
                      CupertinoListTile(
                        title: const Text('Preferred color'),
                        additionalInfo: Text(
                          preferredColorToDisplayString(state.preferColor),
                        ),
                        onTap: bloc.toggleEditingPreferColor,
                      ),
                      if (state.editingPreferColor)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: ICSegmentedControl<insanichess.PieceColor?>(
                            value: state.preferColor,
                            items: const <insanichess.PieceColor?>[
                              insanichess.PieceColor.white,
                              insanichess.PieceColor.black,
                              null,
                            ],
                            labels: const <String>['White', 'Black', 'Any'],
                            onChanged: bloc.changePreferredColor,
                            width: min(
                              400,
                              MediaQuery.of(context).size.width - 32,
                            ),
                          ),
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
                            if (state.isLoading)
                              const CupertinoActivityIndicator()
                            else ...[
                              ICPrimaryButton(
                                text: 'Create a challenge',
                                onPressed: bloc.createChallenge,
                              ),
                              SizedBox(height: logoSize / 40),
                              ICSecondaryButton(
                                text: 'Join game by ID',
                                onPressed: () => ICRouter.pushNamed(
                                  context,
                                  ICRoute.onlinePlayWithId,
                                ),
                              ),
                            ],
                            if (state.backendFailure != null) ...[
                              SizedBox(height: logoSize / 10),
                              Text(
                                'We could not create a challenge at the moment. Please try again later.',
                                textAlign: TextAlign.center,
                                style: CupertinoTheme.of(context)
                                    .textTheme
                                    .textStyle
                                    .copyWith(color: ICColor.danger),
                              ),
                            ],
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

        if (state.challengeDeclined) {
          child = Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              child,
              ICToast.builder(
                context,
                message: 'Challenge declined',
                isSuccess: false,
                dismissWith: bloc.hideChallengeDeclinedToast,
              ),
            ],
          );
        }

        return child;
      },
    );
  }
}
