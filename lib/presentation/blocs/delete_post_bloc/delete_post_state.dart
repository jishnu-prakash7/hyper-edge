part of 'delete_post_bloc.dart';

@immutable
sealed class DeletePostState {}

final class DeletePostInitial extends DeletePostState {}

final class DeletePostLoadingState extends DeletePostState {}

final class DeletePostSuccesfulState extends DeletePostState {}

final class DeletePostDbErrorState extends DeletePostState {}

final class DeletePostServerErrorState extends DeletePostState {}
