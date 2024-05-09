import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:social_media/data/repositories/post_repository.dart';

part 'delete_post_event.dart';
part 'delete_post_state.dart';

class DeletePostBloc extends Bloc<DeletePostEvent, DeletePostState> {
  DeletePostBloc() : super(DeletePostInitial()) {
    on<DeletePostEvent>((event, emit) {});
    on<DeletePostButtonClickEvent>(deletePostButtonClickEvent);
  }

  FutureOr<void> deletePostButtonClickEvent(
      DeletePostButtonClickEvent event, Emitter<DeletePostState> emit) async {
    emit(DeletePostLoadingState());
    final Response result = await PostRepo.deletePost(event.postId);
    final responseBody = jsonDecode(result.body);
    if (result.statusCode == 200) {
      emit(DeletePostSuccesfulState());
    } else if (responseBody['message'] == "DB_FETCH_ERROR") {
      emit(DeletePostDbErrorState());
    } else if (responseBody['message'] == "INTERNAL_SERVER_ERROR") {
      emit(DeletePostServerErrorState());
    }
  }
}
