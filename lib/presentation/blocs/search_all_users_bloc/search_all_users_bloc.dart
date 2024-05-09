import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:social_media/data/repositories/user_repository.dart';

import 'package:social_media/domain/models/saved_post_model.dart';

part 'search_all_users_event.dart';
part 'search_all_users_state.dart';

class SearchAllUsersBloc
    extends Bloc<SearchAllUsersEvent, SearchAllUsersState> {
  SearchAllUsersBloc() : super(SearchAllUsersInitial()) {
    on<SearchAllUsersEvent>((event, emit) {});
    on<SearchUserInitilEvent>(searchUserInitilEvent);
  }

  FutureOr<void> searchUserInitilEvent(
      SearchUserInitilEvent event, Emitter<SearchAllUsersState> emit) async {
    emit(SearchAllUsersLoadingState());
    final Response response = await UserRepo.searchAllUsers(query: event.query);
    if (response.statusCode == 200) {
      debugPrint('searchallusers statuscode-${response.statusCode}');
      List<dynamic> jsonResponse = jsonDecode(response.body);
      final List<UserId> users =
          jsonResponse.map((user) => UserId.fromJson(user)).toList();
      emit(SearchAllUsersSuccesfulState(users: users));
    } else {
      emit(SearchAllUsersErrorState());
    }
  }
}
