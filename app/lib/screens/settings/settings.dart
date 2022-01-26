import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/global/global_bloc.dart';
import '../../bloc/settings/settings_bloc.dart';
import '../../router/router.dart';
import '../../router/routes.dart';
import '../../services/backend_service.dart';
import '../../widgets/ic_button.dart';
import '../../widgets/ic_drawer.dart';
import '../../widgets/ic_toast.dart';
import '../../widgets/util/cupertino_list_section.dart';
import '../../widgets/util/cupertino_list_tile.dart';
import 'otb_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsBloc>(
      create: (BuildContext context) => SettingsBloc(
        globalBloc: GlobalBloc.instance,
        backendService: BackendService.instance,
      ),
      child: const _SettingsScreen(),
    );
  }
}

class _SettingsScreen extends StatelessWidget {
  const _SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SettingsBloc bloc = BlocProvider.of<SettingsBloc>(context);

    return BlocConsumer<SettingsBloc, SettingsState>(
      listener: (BuildContext context, SettingsState state) {},
      builder: (BuildContext context, SettingsState state) {
        Widget child = ICDrawer(
          key: bloc.drawerKey,
          scaffold: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              leading: CupertinoNavigationBarBackButton(
                onPressed: () => ICRouter.pop(context),
              ),
              middle: const Text('Settings'),
              border: const Border(),
              trailing: ICTrailingButton(
                icon: CupertinoIcons.line_horizontal_3,
                // must not shortcut to: bloc.drawerKey.currentState?.open
                onPressed: () => bloc.drawerKey.currentState?.open(),
              ),
            ),
            child: Column(
              children: <Widget>[
                CupertinoListSection(
                  hasLeading: false,
                  header: const Text('GAME TYPE'),
                  backgroundColor:
                      CupertinoTheme.of(context).scaffoldBackgroundColor,
                  children: <Widget>[
                    CupertinoListTile(
                      title: const Text('Over-the-board'),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () {
                        bloc.hideFailure();
                        ICRouter.pushNamed(
                          context,
                          ICRoute.settingsOtb,
                          arguments: OtbSettingsScreenArgs(settingsBloc: bloc),
                        );
                      },
                    ),
                  ],
                ),
                CupertinoListSection(
                  header: const Text('GENERAL'),
                  hasLeading: false,
                  backgroundColor:
                      CupertinoTheme.of(context).scaffoldBackgroundColor,
                  children: <Widget>[
                    CupertinoListTile(
                      title: const Text('Zoom-out button on left'),
                      trailing: CupertinoSwitch(
                        value: state.showZoomOutButtonOnLeft,
                        onChanged: (_) => bloc.toggleShowZoomButtonOnLeft(),
                      ),
                    ),
                    CupertinoListTile(
                      title: const Text('Show legal moves'),
                      trailing: CupertinoSwitch(
                        value: state.showLegalMoves,
                        onChanged: (_) => bloc.toggleShowLegalMoves(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

        if (state.backendFailure != null &&
            ICRouter.isCurrentRoute(ICRoute.settings)) {
          child = Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              child,
              ICToast.builder(
                context,
                message: 'Could not save settings',
                isSuccess: false,
                dismissWith: bloc.hideFailure,
              ),
            ],
          );
        }

        return child;
      },
    );
  }
}
