part of 'fetch_followers_bloc.dart';

@immutable
sealed class FetchFollowersState {}

final class FetchFollowersInitial extends FetchFollowersState {}

final class FetchFollowersLoadingState extends FetchFollowersState {}

final class FetchFollowersSuccesfulState extends FetchFollowersState {
  final FollowersModel followersModel;

  FetchFollowersSuccesfulState({required this.followersModel});
}

final class FetchFollowersErrorState extends FetchFollowersState {}
