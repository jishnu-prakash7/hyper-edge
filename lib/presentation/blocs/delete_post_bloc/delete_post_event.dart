part of 'delete_post_bloc.dart';

@immutable
sealed class DeletePostEvent {}

class DeletePostButtonClickEvent extends DeletePostEvent {
  final String postId;

  DeletePostButtonClickEvent({required this.postId});
}
