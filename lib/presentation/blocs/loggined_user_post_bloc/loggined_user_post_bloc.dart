import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:social_media/data/repositories/post_repository.dart';
import 'package:social_media/domain/models/post_model.dart';
import 'package:social_media/presentation/widgets/common_widgets.dart';

part 'loggined_user_post_event.dart';
part 'loggined_user_post_state.dart';

class LogginedUserPostBloc extends Bloc<HomeEvent, LogginedUserPostState> {
  LogginedUserPostBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {});
    on<LogginedUserPostInitilDataFetchEvent>(homeInitialDatafetchEvent);
  }

  FutureOr<void> homeInitialDatafetchEvent(
      LogginedUserPostInitilDataFetchEvent event,
      Emitter<LogginedUserPostState> emit) async {
    emit(LogginedUserPostFetchLoadingState());
    final Response result = await PostRepo.fetchPosts();
    final responseBody = jsonDecode(result.body);
    if (result.statusCode == 200) {
      final List<Post> posts = parsePosts(result.body);
      emit(LogginedUserPostFetchSuccesfulState(posts: posts));
    } else if (responseBody['status'] == 500) {
      emit(LogginedUserPostFetchServerErrorState());
    } else {
      emit(LogginedUserPostFetchErrorState());
    }
  }
}
