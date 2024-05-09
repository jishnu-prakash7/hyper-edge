part of 'suggessions_bloc.dart';

@immutable
sealed class SuggessionsState {}

final class SuggessionsInitial extends SuggessionsState {}

final class SuggessionsSuccesfulState extends SuggessionsState {
  final SuggessionModel suggessionModel;

  SuggessionsSuccesfulState({required this.suggessionModel});
}

final class SuggessionsLoadingState extends SuggessionsState {}

final class SuggessionsErrorState extends SuggessionsState {}

final class SuggessionsServerErrorState extends SuggessionsState {}
