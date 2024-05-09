import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:social_media/data/repositories/post_repository.dart';

part 'edit_post_event.dart';
part 'edit_post_state.dart';

class EditPostBloc extends Bloc<EditPostEvent, EditPostState> {
  EditPostBloc() : super(EditPostInitial()) {
    on<EditPostEvent>((event, emit) {});
    on<EditPostButtonClickEvent>(editPostButtonClickEvent);
    on<EditPostPickImageEvent>(editPostPickImageEvent);
  }

  FutureOr<void> editPostButtonClickEvent(
      EditPostButtonClickEvent event, Emitter<EditPostState> emit) async {
    emit(EditPostLoadingState());
    final Response result = await PostRepo.editPost(
        description: event.description,
        image: event.image,
        postId: event.postId,
        imageUrl: event.imageUrl);
    final responseBody = jsonDecode(result.body);
    if (result.statusCode == 200) {
      emit(EditPostSuccesfulState());
    } else if (responseBody['status'] == 404) {
      emit(EditPostPostNotFoundState());
    } else if (responseBody['message'] ==
        'Something went wrong while updating the post') {
      emit(EditPostDbUpdateErrorState());
    } else if (responseBody['message'] ==
        'Something went wrong on the server') {
      emit(EditPostServerErrorState());
    }
  }

  FutureOr<void> editPostPickImageEvent(
      EditPostPickImageEvent event, Emitter<EditPostState> emit) {
        emit(EditPostSelectedAssetsChangedState(selectedAssetList: event.assetList));
      }
}
