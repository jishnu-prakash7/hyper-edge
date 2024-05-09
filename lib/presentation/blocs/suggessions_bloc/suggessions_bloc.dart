import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:social_media/data/repositories/user_repository.dart';
import 'package:social_media/domain/models/suggessions_model.dart';

part 'suggessions_event.dart';
part 'suggessions_state.dart';

class SuggessionsBloc extends Bloc<SuggessionsEvent, SuggessionsState> {
  SuggessionsBloc() : super(SuggessionsInitial()) {
    on<SuggessionsEvent>((event, emit) {});
    on<SuggessionUserInitialFetchEvent>(suggessionUserInitialFetchEvent);
  }

  FutureOr<void> suggessionUserInitialFetchEvent(
      SuggessionUserInitialFetchEvent event,
      Emitter<SuggessionsState> emit) async {
    emit(SuggessionsLoadingState());
    final Response result = await UserRepo.fetchSuggessionUser();
    final responseBody = jsonDecode(result.body);
    if (result.statusCode == 200) {
      final SuggessionModel suggessionModel =
          SuggessionModel.fromJson(responseBody);
      emit(SuggessionsSuccesfulState(suggessionModel: suggessionModel));
    } else if (result.statusCode == 500) {
      emit(SuggessionsServerErrorState());
    }
  }
}
