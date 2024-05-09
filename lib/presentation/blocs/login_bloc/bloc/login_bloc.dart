import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:social_media/data/repositories/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) {});
    on<UserLoginEvent>(userLoginEvent);
  }

  FutureOr<void> userLoginEvent(
      UserLoginEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    final result = await AuthRepo.userLogin(event.email, event.password);
    if (result["message"] == "Login successful") {
      emit(LoginSuccessfulState());
    } else if (result['message'] == 'User not found with the provided email') {
      emit(LoginUserNotFoundState());
    } else if (result['message'] == 'Your Account is Blocked') {
      emit(LoginAccountBlockedState());
    } else if (result["message"] == "Invalid password") {
      emit(LoginInvalidPasswordState());
    } else if (result['message'] == 'Something went wrong on the server') {
      emit(LoginServerErrorState());
    } else {
      emit(LoginErrorState());
    }
  }
}
