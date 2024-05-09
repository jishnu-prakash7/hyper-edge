part of 'loggined_user_post_bloc.dart';

@immutable
sealed class LogginedUserPostState {}

final class HomeInitial extends LogginedUserPostState {}

final class LogginedUserPostFetchSuccesfulState extends LogginedUserPostState {
  final List<Post> posts;

  LogginedUserPostFetchSuccesfulState({required this.posts});
}

final class LogginedUserPostFetchLoadingState extends LogginedUserPostState {}

final class LogginedUserPostFetchServerErrorState
    extends LogginedUserPostState {}

final class LogginedUserPostFetchErrorState extends LogginedUserPostState {}
