part of 'get_single_user_bloc.dart';

@immutable
sealed class GetSingleUserState {}

final class GetSingleUserInitial extends GetSingleUserState {}

final class GetSingleUserLoadingState extends GetSingleUserState {}

final class GetSingleUserSuccesfulState extends GetSingleUserState {
  final GetUserModel user;

  GetSingleUserSuccesfulState({required this.user});
}

final class GetSingleUserErrorState extends GetSingleUserState {}
