import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

import 'package:social_media/data/repositories/user_repository.dart';
import 'package:social_media/domain/models/postuser_model.dart';

part 'profile_details_event.dart';
part 'profile_details_state.dart';

class ProfileDetailsBloc
    extends Bloc<ProfileDetailsEvent, ProfileDetailsState> {
  ProfileDetailsBloc() : super(ProfileDetailsInitial()) {
    on<ProfileDetailsEvent>((event, emit) {});
    on<ProfileInitialDetailsFetchEvent>(profileInitialDetailsFetchEvent);
  }

  FutureOr<void> profileInitialDetailsFetchEvent(
      ProfileInitialDetailsFetchEvent event,
      Emitter<ProfileDetailsState> emit) async {
    emit(ProfileDetailsFetchLoadingState());
    final Response result = await UserRepo.fetchLoggedInUserDetails();
    final responseBody = jsonDecode(result.body);
    if (result.statusCode == 200) {
      final User user = User.fromJson(responseBody);
      emit(ProfileDetailsFetchSuccesfulState(user: user));
    } else if (responseBody['status'] == 404) {
      emit(ProfileDetailsFetchUserNotFoundState());
    } else if (responseBody['status'] == 500) {
      emit(ProfileDetailsFetchServerErrorState());
    }
  }
}
