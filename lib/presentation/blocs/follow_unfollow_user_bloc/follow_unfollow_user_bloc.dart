import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:social_media/data/repositories/user_repository.dart';

part 'follow_unfollow_user_event.dart';
part 'follow_unfollow_user_state.dart';

class FollowUnfollowUserBloc
    extends Bloc<FollowUnfollowUserEvent, FollowUnfollowUserState> {
  FollowUnfollowUserBloc() : super(FollowUnfollowUserInitial()) {
    on<FollowUnfollowUserEvent>((event, emit) {});
    on<FollowUserButtonClickEvent>(followUserButtonClickEvent);
    on<UnFollowUserButtonClickEvent>(unfollowUserButtonClickEvent);
  }

  FutureOr<void> followUserButtonClickEvent(FollowUserButtonClickEvent event,
      Emitter<FollowUnfollowUserState> emit) async {
    emit(FollowUserLoadingState());
    final Response result =
        await UserRepo.followUser(followeesId: event.followeesId);
        debugPrint('follow statuscode-${result.statusCode}');
    if (result.statusCode == 200) {
      emit(FollowUserSuccesfulState());
    } else {
      emit(FollowUserErrorState());
    }
  }

  FutureOr<void> unfollowUserButtonClickEvent(
      UnFollowUserButtonClickEvent event,
      Emitter<FollowUnfollowUserState> emit) async {
    emit(UnFollowUserLoadingState());
    final Response result =
        await UserRepo.unfollowUser(followeesId: event.followeesId);
        debugPrint('unfollow statuscode-${result.statusCode}');
    if (result.statusCode == 200) {
      emit(UnFollowUserSuccesfulState());
    } else {
      emit(FollowUserErrorState());
    }
  }
}
