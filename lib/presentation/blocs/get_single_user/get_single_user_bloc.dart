import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:social_media/data/repositories/user_repository.dart';
import 'package:social_media/domain/models/get_user_model.dart';

part 'get_single_user_event.dart';
part 'get_single_user_state.dart';

class GetSingleUserBloc extends Bloc<GetSingleUserEvent, GetSingleUserState> {
  GetSingleUserBloc() : super(GetSingleUserInitial()) {
    on<GetSingleUserEvent>((event, emit) {});
    on<GetSingleUserInitialFetchEvent>(getSingleUserInitialFetchEvent);
  }

  FutureOr<void> getSingleUserInitialFetchEvent(
      GetSingleUserInitialFetchEvent event,
      Emitter<GetSingleUserState> emit) async {
    emit(GetSingleUserLoadingState());
    final Response response =
        await UserRepo.getSingleUser(userid: event.userid);
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final GetUserModel user = GetUserModel.fromJson(responseBody);
      emit(GetSingleUserSuccesfulState(user: user));
    } else {
      emit(GetSingleUserErrorState());
    }
  }
}
