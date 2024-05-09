part of 'suggessions_bloc.dart';

@immutable
sealed class SuggessionsEvent {}

class SuggessionUserInitialFetchEvent extends SuggessionsEvent {}
