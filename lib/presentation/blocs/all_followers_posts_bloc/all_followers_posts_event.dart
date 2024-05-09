// part of 'all_followers_posts_bloc.dart';

// @immutable
// sealed class AllFollowersPostsEvent {}

// class AllFollowersPostsInitialFetchEvent extends AllFollowersPostsEvent {
//   final int page;

//   AllFollowersPostsInitialFetchEvent({required this.page});
// }

part of 'all_followers_posts_bloc.dart';

@immutable
sealed class AllFollowersPostsEvent {}

class AllFollowersPostsInitialFetchEvent extends AllFollowersPostsEvent {}

class LoadMoreEvent extends AllFollowersPostsEvent {}
