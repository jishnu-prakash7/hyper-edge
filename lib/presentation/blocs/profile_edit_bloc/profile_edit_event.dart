part of 'profile_edit_bloc.dart';

@immutable
sealed class ProfileEditEvent {}

class ProfileEditImagePickerEvent extends ProfileEditEvent {
  final File image;

  ProfileEditImagePickerEvent({required this.image});
}

class ProfileEditBgImagePickerEvent extends ProfileEditEvent {
  final File bgImage;

  ProfileEditBgImagePickerEvent({required this.bgImage});
}

class EditProfileButtonClickEvent extends ProfileEditEvent {
  final String name;
  final String bio;
  final dynamic image;
  final String? imageUrl;
  final dynamic bgImage;
  final String? bgImageUrl;

  EditProfileButtonClickEvent({
    required this.name,
    required this.bio,
    required this.image,
    this.imageUrl,
    required this.bgImage,
    this.bgImageUrl,
  });
}
