part of 'get_single_user_bloc.dart';

@immutable
sealed class GetSingleUserEvent {}

class GetSingleUserInitialFetchEvent extends GetSingleUserEvent {
  final String userid;

  GetSingleUserInitialFetchEvent({required this.userid});
}
