part of 'profile_edit_bloc.dart';

@immutable
sealed class ProfileEditState {}

final class ProfileEditInitial extends ProfileEditState {}

final class ProfileEditLoadingState extends ProfileEditState {}

final class ProfileEditSuccesfulState extends ProfileEditState {}

final class ProfileEditDbFetchErrorState extends ProfileEditState {}

final class ProfileEditDbUpdateErrorState extends ProfileEditState {}

final class ProfileEditServerErrorState extends ProfileEditState {}

final class ProfileEditImagePickedState extends ProfileEditState {
  final File image;

  ProfileEditImagePickedState({required this.image});
}

final class ProfileEditBgImagePickedState extends ProfileEditState {
  final File bgImage;

  ProfileEditBgImagePickedState({required this.bgImage});
}
