part of 'fetch_followers_bloc.dart';

@immutable
sealed class FetchFollowersEvent {}

class FollowersInitialFetchEvent extends FetchFollowersEvent {}
