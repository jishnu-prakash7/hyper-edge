import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:social_media/data/repositories/post_repository.dart';
import 'package:social_media/domain/models/comment_model.dart';

part 'get_comments_event.dart';
part 'get_comments_state.dart';

class GetCommentsBloc extends Bloc<GetCommentsEvent, GetCommentsState> {
  GetCommentsBloc() : super(GetCommentsInitial()) {
    on<GetCommentsEvent>((event, emit) {});
    on<CommentsFetchEvent>(commentsFetchEvent);
  }

  FutureOr<void> commentsFetchEvent(
      CommentsFetchEvent event, Emitter<GetCommentsState> emit) async {
    emit(GetCommentsLoadingState());
    final Response result = await PostRepo.getAllComments(postId: event.postId);
    if (result.statusCode == 200) {
      final responseBody = jsonDecode(result.body);
      List<Comment> comments = List<Comment>.from(responseBody['comments']
          .map((commentJson) => Comment.fromJson(commentJson)));
      emit(GetCommentsSuccsfulState(comments: comments));
    } else if (result.statusCode == 500) {
      emit(GetCommentsServerErrorState());
    }
  }
}
