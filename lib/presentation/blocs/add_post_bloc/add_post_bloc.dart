import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:social_media/data/repositories/post_repository.dart';

part 'add_post_event.dart';
part 'add_post_state.dart';

class AddPostBloc extends Bloc<AddPostEvent, AddPostState> {
  AddPostBloc() : super(AddPostInitial()) {
    on<AddPostEvent>((event, emit) {});
    on<AddpostButtonClickEvent>(addpostbuttonclickevent);
    on<AddPostPickImageEvent>(addPostPickImageEvent);
  }

  FutureOr<void> addpostbuttonclickevent(
      AddpostButtonClickEvent event, Emitter<AddPostState> emit) async {
    emit(AddPostLoadingState());
    final result = await PostRepo.addPost(event.description, event.image);
    if (result == 'Post created successfully') {
      emit(AddPostSuccesfulState());
    } else if (result == 'Something went wrong while saving to the database') {
      emit(AddPostDbErrorState());
    } else if (result == 'Something went wrong on the server') {
      emit(AddPostServerErrorState());
    } else {
      emit(AddPostErrorState());
    }
  }

  FutureOr<void> addPostPickImageEvent(
      AddPostPickImageEvent event, Emitter<AddPostState> emit) {
    emit(AddPostSelectedAssetsChangedState(selectedAssetList: event.imageList));
  }
}
