part of 'edit_post_bloc.dart';

@immutable
sealed class EditPostEvent {}

class EditPostButtonClickEvent extends EditPostEvent {
  final dynamic image;
  final String? imageUrl;
  final String description;
  final String postId;

  EditPostButtonClickEvent({
    required this.image,
    required this.description,
    required this.postId,
    this.imageUrl,
  });
}

class EditPostPickImageEvent extends EditPostEvent {
  final List<AssetEntity> assetList;

  EditPostPickImageEvent({required this.assetList});
}
