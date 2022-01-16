import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

import '../../widgets/ic_drawer.dart';

part 'rules_event.dart';
part 'rules_state.dart';

class RulesBloc extends Bloc<_RulesEvent, RulesState> {
  final GlobalKey<ICDrawerState> drawerKey = GlobalKey<ICDrawerState>();

  RulesBloc() : super(const RulesState.initial());
}
