import '../../bloc/global/global_bloc.dart';

String authHeaderValue() {
  return 'Bearer ${GlobalBloc.instance.state.jwtToken}';
}
