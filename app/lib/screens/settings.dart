import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/settings/settings_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsBloc>(
      create: (BuildContext context) => SettingsBloc(),
      child: const _SettingsScreen(),
    );
  }
}

class _SettingsScreen extends StatelessWidget {
  const _SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listener: (BuildContext context, SettingsState state) {},
      builder: (BuildContext context, SettingsState state) {
        return Container();
      },
    );
  }
}
