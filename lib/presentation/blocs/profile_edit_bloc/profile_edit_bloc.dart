import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:social_media/data/repositories/user_repository.dart';

part 'profile_edit_event.dart';
part 'profile_edit_state.dart';

class ProfileEditBloc extends Bloc<ProfileEditEvent, ProfileEditState> {
  ProfileEditBloc() : super(ProfileEditInitial()) {
    on<ProfileEditEvent>((event, emit) {});
    on<EditProfileButtonClickEvent>(editProfileButtonClickEvent);
    on<ProfileEditImagePickerEvent>(profileEditImagePickerEvent);
    on<ProfileEditBgImagePickerEvent>(profileEditBgImagePickerEvent);
  }

  FutureOr<void> editProfileButtonClickEvent(
      EditProfileButtonClickEvent event, Emitter<ProfileEditState> emit) async {
    emit(ProfileEditLoadingState());
    final Response result = await UserRepo.editProfile(
        image: event.image,
        name: event.name,
        bio: event.bio,
        imageUrl: event.imageUrl,
        bgImage: event.bgImage,
        bgImageUrl: event.bgImageUrl);
    final responseBody = jsonDecode(result.body);
    if (result.statusCode == 200) {
      emit(ProfileEditSuccesfulState());
    } else if (responseBody['status'] == 401) {
      emit(ProfileEditDbFetchErrorState());
    } else if (responseBody['message'] ==
        'Something went wrong while updating the post') {
      emit(ProfileEditDbUpdateErrorState());
    } else if (responseBody['message'] ==
        'Something went wrong on the server') {
      emit(ProfileEditServerErrorState());
    }
  }

  FutureOr<void> profileEditImagePickerEvent(
      ProfileEditImagePickerEvent event, Emitter<ProfileEditState> emit) async {
    emit(ProfileEditImagePickedState(image: event.image));
  }

  FutureOr<void> profileEditBgImagePickerEvent(
      ProfileEditBgImagePickerEvent event,
      Emitter<ProfileEditState> emit) async {
    emit(ProfileEditBgImagePickedState(bgImage: event.bgImage));
  }
}
