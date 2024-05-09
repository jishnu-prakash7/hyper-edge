import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:social_media/data/repositories/auth_repository.dart';
import 'package:social_media/domain/models/user_model.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitialState()) {
    on<SignupEvent>((event, emit) {});
    on<UserSignupEvent>(userSignupEvent);
  }

  FutureOr<void> userSignupEvent(
      UserSignupEvent event, Emitter<SignupState> emit) async {
    emit(SignupLoadingState());
    String result = await AuthRepo.signup(event.user);
    if (result == 'Successful') {
      emit(SignupSuccessfulState());
    } else if (result == 'You Already have an account') {
      emit(SignupAlreadyAccountState());
    } else if (result == 'Something wrong please try after sometime') {
      emit(SignupServerErrorState());
    } else if (result == "OTP already sent within the last one minute") {
      emit(SignupOtpAlreadySendState());
    } else {
      emit(SignupErrorState());
    }
  }
}
