import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../../bloc/settings/settings_bloc.dart';
import '../../router/router.dart';
import '../../router/routes.dart';
import '../../widgets/ic_button.dart';
import '../../widgets/ic_drawer.dart';
import '../../widgets/ic_toast.dart';
import '../../widgets/util/cupertino_list_section.dart';
import '../../widgets/util/cupertino_list_tile.dart';

class OtbSettingsScreenArgs {
  final SettingsBloc settingsBloc;

  const OtbSettingsScreenArgs({required this.settingsBloc});
}

class OtbSettingsScreen extends StatelessWidget {
  final OtbSettingsScreenArgs args;

  const OtbSettingsScreen({
    Key? key,
    required this.args,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      bloc: args.settingsBloc,
      listener: (BuildContext context, SettingsState state) {},
      builder: (BuildContext context, SettingsState state) {
        Widget child = ICDrawer(
          key: args.settingsBloc.drawerKeyOtb,
          scaffold: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text('OTB Settings'),
              border: const Border(),
              leading: CupertinoNavigationBarBackButton(
                onPressed: () {
                  args.settingsBloc.hideFailure();
                  ICRouter.pop(context);
                },
              ),
              trailing: ICTrailingButton(
                icon: CupertinoIcons.line_horizontal_3,
                // must not shortcut to: bloc.drawerKey.currentState?.open
                onPressed: () =>
                    args.settingsBloc.drawerKeyOtb.currentState?.open(),
              ),
            ),
            child: Column(
              children: <Widget>[
                CupertinoListSection(
                  hasLeading: false,
                  backgroundColor:
                      CupertinoTheme.of(context).scaffoldBackgroundColor,
                  children: <Widget>[
                    CupertinoListTile(
                      title: const Text('Always promote to queen'),
                      trailing: CupertinoSwitch(
                        value: state.otbAlwaysPromoteToQueen,
                        onChanged: (_) =>
                            args.settingsBloc.toggleOtbAlwaysPromoteToQueen(),
                      ),
                    ),
                    CupertinoListTile(
                      title: const Text('Allow undo'),
                      trailing: CupertinoSwitch(
                        value: state.otbAllowUndo,
                        onChanged: (_) =>
                            args.settingsBloc.toggleOtbAllowUndo(),
                      ),
                    ),
                    CupertinoListTile(
                      title: const Text('Mirror top pieces'),
                      trailing: CupertinoSwitch(
                        value: state.otbMirrorTopPieces,
                        onChanged: (_) =>
                            args.settingsBloc.toggleOtbMirrorTopPieces(),
                      ),
                    ),
                    CupertinoListTile(
                      title: const Text('Rotate board on move'),
                      trailing: CupertinoSwitch(
                        value: state.otbRotateChessboard,
                        onChanged: (_) =>
                            args.settingsBloc.toggleOtbRotateChessboard(),
                      ),
                    ),
                    CupertinoListTile(
                      title: const Text('Zoom out on move'),
                      trailing: CupertinoSwitch(
                        value: state.otbAutoZoomOutOnMove ==
                            AutoZoomOutOnMoveBehaviour.always,
                        onChanged: (_) =>
                            args.settingsBloc.toggleOtbAutoZoomOutOnMove(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

        if (state.backendFailure != null &&
            ICRouter.isCurrentRoute(ICRoute.settingsOtb)) {
          child = Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              child,
              Positioned(
                bottom: MediaQuery.of(context).padding.bottom == 0 ? 16 : 0,
                child: SafeArea(
                  child: ICToast(
                    isSuccess: false,
                    message: 'Could not save settings',
                    onTap: args.settingsBloc.hideFailure,
                  ),
                ),
              ),
            ],
          );
        }

        return child;
      },
    );
  }
}
