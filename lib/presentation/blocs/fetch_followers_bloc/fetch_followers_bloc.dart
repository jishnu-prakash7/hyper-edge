import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:social_media/data/repositories/user_repository.dart';
import 'package:social_media/domain/models/followers_model.dart';

part 'fetch_followers_event.dart';
part 'fetch_followers_state.dart';

class FetchFollowersBloc
    extends Bloc<FetchFollowersEvent, FetchFollowersState> {
  FetchFollowersBloc() : super(FetchFollowersInitial()) {
    on<FetchFollowersEvent>((event, emit) {});
    on<FollowersInitialFetchEvent>(followersInitialFetchEvent);
  }

  FutureOr<void> followersInitialFetchEvent(FollowersInitialFetchEvent event,
      Emitter<FetchFollowersState> emit) async {
    emit(FetchFollowersLoadingState());
    final Response result = await UserRepo.fetchFollowers();
    final responseBody = jsonDecode(result.body);
    if (result.statusCode == 200) {
      final FollowersModel followersModel =
          FollowersModel.fromJson(responseBody);
      emit(FetchFollowersSuccesfulState(followersModel: followersModel));
    } else {
      emit(FetchFollowersErrorState());
    }
  }
}
