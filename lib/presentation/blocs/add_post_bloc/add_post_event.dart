part of 'add_post_bloc.dart';

@immutable
sealed class AddPostEvent {}

class AddpostButtonClickEvent extends AddPostEvent {
  final AssetEntity image;
  final String description;

  AddpostButtonClickEvent({required this.image, required this.description});
}

class AddPostPickImageEvent extends AddPostEvent {
  final List<AssetEntity> imageList;

  AddPostPickImageEvent({required this.imageList});
}
