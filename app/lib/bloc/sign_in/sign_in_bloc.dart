import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:insanichess_sdk/insanichess_sdk.dart';
import 'package:meta/meta.dart';

import '../../services/auth_service.dart';
import '../../services/local_storage_service.dart';
import '../../util/either.dart';
import '../../util/failures/backend_failure.dart';
import '../../util/failures/failure.dart';
import '../../util/failures/validation_failure.dart';
import '../global/global_bloc.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<_SignInEvent, SignInState> {
  final GlobalBloc _globalBloc;
  final AuthService _authService;
  final LocalStorageService _localStorageService;

  SignInBloc({
    required GlobalBloc globalBloc,
    required AuthService authService,
    required LocalStorageService localStorageService,
  })  : _globalBloc = globalBloc,
        _authService = authService,
        _localStorageService = localStorageService,
        super(const SignInState.initial()) {
    on<_EmailChanged>(_onEmailChanged);
    on<_PasswordChanged>(_onPasswordChanged);
    on<_SubmitSignIn>(_onSubmitSignIn);
    on<_SubmitRegister>(_onSubmitRegister);
  }

  // Public API

  void emailChanged(String value) => add(_EmailChanged(value));
  void passwordChanged(String value) => add(_PasswordChanged(value));
  void signIn() => add(const _SubmitSignIn());
  void register() => add(const _SubmitRegister());

  // Handlers

  FutureOr<void> _onEmailChanged(
    _EmailChanged event,
    Emitter<SignInState> emit,
  ) async {
    emit(state.copyWith(email: event.value));
  }

  FutureOr<void> _onPasswordChanged(
    _PasswordChanged event,
    Emitter<SignInState> emit,
  ) async {
    emit(state.copyWith(password: event.value));
  }

  FutureOr<void> _onSubmitSignIn(
    _SubmitSignIn event,
    Emitter<SignInState> emit,
  ) async {
    if (!InsanichessValidator.isValidEmail(state.email)) {
      emit(state.copyWith(failure: const EmailValidationFailure()));
      return;
    }
    if (!InsanichessValidator.isValidPassword(state.password)) {
      emit(state.copyWith(failure: const PasswordValidationFailure()));
      return;
    }

    emit(state.copyWith(isLoading: true));

    final Either<BackendFailure, InsanichessUser> userOrFailure =
        await _authService.loginWithEmailAndPassword(
            state.email, state.password);

    if (userOrFailure.isError()) {
      emit(state.copyWith(
        isLoading: false,
        signInSuccessful: false,
        failure: userOrFailure.error,
      ));
      return;
    }

    _globalBloc.updateJwtToken(userOrFailure.value.jwtToken!);
    _localStorageService.saveJwtToken(userOrFailure.value.jwtToken!);

    emit(state.copyWith(
      isLoading: false,
      signInSuccessful: true,
    ));
  }

  FutureOr<void> _onSubmitRegister(
    _SubmitRegister event,
    Emitter<SignInState> emit,
  ) async {
    if (!InsanichessValidator.isValidEmail(state.email)) {
      emit(state.copyWith(failure: const EmailValidationFailure()));
      return;
    }
    if (!InsanichessValidator.isValidPassword(state.password)) {
      emit(state.copyWith(failure: const PasswordValidationFailure()));
      return;
    }

    emit(state.copyWith(isLoading: true));

    final Either<BackendFailure, InsanichessUser> userOrFailure =
        await _authService.registerWithEmailAndPassword(
            state.email, state.password);

    if (userOrFailure.isError()) {
      emit(state.copyWith(
        isLoading: false,
        signInSuccessful: false,
        failure: userOrFailure.error,
      ));
      return;
    }

    _globalBloc.updateJwtToken(userOrFailure.value.jwtToken!);
    _localStorageService.saveJwtToken(userOrFailure.value.jwtToken!);

    emit(state.copyWith(
      isLoading: false,
      signInSuccessful: true,
    ));
  }
}
