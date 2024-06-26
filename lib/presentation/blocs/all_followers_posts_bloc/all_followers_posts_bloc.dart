// import 'dart:async';
// import 'dart:convert';

// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:social_media/data/repositories/post_repository.dart';
// import 'package:social_media/domain/models/get_followers_post_model.dart';
// part 'all_followers_posts_event.dart';
// part 'all_followers_posts_state.dart';

// class AllFollowersPostsBloc
//     extends Bloc<AllFollowersPostsEvent, AllFollowersPostsState> {
//   AllFollowersPostsBloc() : super(AllFollowersPostsInitial()) {
//     on<AllFollowersPostsEvent>((event, emit) {});
//     on<AllFollowersPostsInitialFetchEvent>(allFollowersPostsInitialFetchEvent);
//   }

//   FutureOr<void> allFollowersPostsInitialFetchEvent(
//       AllFollowersPostsInitialFetchEvent event,
//       Emitter<AllFollowersPostsState> emit) async {
//     emit(AllFollowersPostsLoadingState());
//     final Response result = await PostRepo.getFollowersPost(page: event.page);
//     final responseBody = jsonDecode(result.body);
//     final List data = responseBody;
//     if (result.statusCode == 200) {
//       List<FollwersPostModel> posts =
//           data.map((e) => FollwersPostModel.fromJson(e)).toList();
//       emit(AllFollowersPostsSuccesfulState(posts: posts));
//     } else if (responseBody['status'] == 500) {
//       emit(AllFollowersPostsServerErrorState());
//     }
//   }
// }

import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:social_media/data/repositories/post_repository.dart';
import 'package:social_media/domain/models/get_followers_post_model.dart';
part 'all_followers_posts_event.dart';
part 'all_followers_posts_state.dart';

class AllFollowersPostsBloc
    extends Bloc<AllFollowersPostsEvent, AllFollowersPostsState> {
  int page = 1;
  ScrollController scrollController = ScrollController();
  bool isLoadingMore = false;
  AllFollowersPostsBloc() : super(const AllFollowersPostsInitial(null)) {
    scrollController.addListener(() {
      add(LoadMoreEvent());
    });
    on<AllFollowersPostsEvent>((event, emit) {});
    on<AllFollowersPostsInitialFetchEvent>(allFollowersPostsInitialFetchEvent);
    on<LoadMoreEvent>(loadMoreEvent);
  }

  FutureOr<void> allFollowersPostsInitialFetchEvent(
      AllFollowersPostsInitialFetchEvent event,
      Emitter<AllFollowersPostsState> emit) async {
    emit(const AllFollowersPostsLoadingState(null));
    page = 1;
    final Response result = await PostRepo.getFollowersPost(page: page);
    final responseBody = jsonDecode(result.body);
    final List data = responseBody;
    debugPrint(result.statusCode.toString());
    debugPrint('get follwers post-${result.body}');
    if (result.statusCode == 200) {
      List<FollwersPostModel> posts =
          data.map((e) => FollwersPostModel.fromJson(e)).toList();
      emit(AllFollowersPostsSuccesfulState(posts: posts));
    } else if (responseBody['status'] == 500) {
      emit(const AllFollowersPostsServerErrorState(null));
    }
  }

  FutureOr<void> loadMoreEvent(
      LoadMoreEvent event, Emitter<AllFollowersPostsState> emit) async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      isLoadingMore = true;
      page++;
      final Response result = await PostRepo.getFollowersPost(page: page);
      final responseBody = jsonDecode(result.body);
      final List data = responseBody;
      List<FollwersPostModel> posts =
          data.map((e) => FollwersPostModel.fromJson(e)).toList();
      emit(AllFollowersPostsSuccesfulState(posts: [...state.posts, ...posts]));
      isLoadingMore = false;
    }
  }
}
