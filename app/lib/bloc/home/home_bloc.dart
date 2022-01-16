import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

import '../../widgets/ic_drawer.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GlobalKey<ICDrawerState> drawerKey = GlobalKey<ICDrawerState>();

  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
