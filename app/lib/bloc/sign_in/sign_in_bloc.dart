import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<_SignInEvent, SignInState> {
  SignInBloc() : super(const SignInState.initial());
}
