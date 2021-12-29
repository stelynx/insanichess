import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/global/global_bloc.dart';
import '../../bloc/settings/settings_bloc.dart';
import '../../router/routes.dart';
import '../../services/local_storage_service.dart';
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
        localStorageService: LocalStorageService.instance,
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
        return CupertinoPageScaffold(
          navigationBar: const CupertinoNavigationBar(
            middle: Text('Settings'),
          ),
          child: Column(
            children: <Widget>[
              CupertinoListSection(
                header: const Text('GAME TYPE'),
                children: <Widget>[
                  CupertinoListTile(
                    title: const Text('Over-the-board'),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () => Navigator.of(context).pushNamed(
                      ICRoute.settingsOtb,
                      arguments: OtbSettingsScreenArgs(settingsBloc: bloc),
                    ),
                  ),
                ],
              ),
              CupertinoListSection(
                header: const Text('GENERAL'),
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
        );
      },
    );
  }
}
