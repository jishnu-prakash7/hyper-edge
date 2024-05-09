import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:social_media/data/repositories/user_repository.dart';
import 'package:social_media/domain/models/followings_model.dart';

part 'fetch_followings_event.dart';
part 'fetch_followings_state.dart';

class FetchFollowingsBloc
    extends Bloc<FetchFollowingsEvent, FetchFollowingsState> {
  FetchFollowingsBloc() : super(FetchFollowingsInitial()) {
    on<FetchFollowingsEvent>((event, emit) {});
    on<FollowingsInitialFetchEvent>(followingsInitialFetchEvent);
  }

  FutureOr<void> followingsInitialFetchEvent(FollowingsInitialFetchEvent event,
      Emitter<FetchFollowingsState> emit) async {
    emit(FetchFollowingsLoadingState());
    final Response result = await UserRepo.fetchFollowing();
    final responseBody = jsonDecode(result.body);
    debugPrint('followers fetch status code-${result.statusCode}');
    if (result.statusCode == 200) {
      final FollowingsModel followingsModel =
          FollowingsModel.fromJson(responseBody);
      emit(FetchFollowingsSuccesfulState(followingsModel: followingsModel));
    } else {
      emit(FetchFollowingsErrorState());
    }
  }
}
