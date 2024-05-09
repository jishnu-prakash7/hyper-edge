part of 'add_post_bloc.dart';

@immutable
sealed class AddPostState {}

final class AddPostInitial extends AddPostState {}

final class AddPostLoadingState extends AddPostState {}

final class AddPostSuccesfulState extends AddPostState {}

final class AddPostDbErrorState extends AddPostState {}

final class AddPostServerErrorState extends AddPostState {}

final class AddPostErrorState extends AddPostState {}

class AddPostSelectedAssetsChangedState extends AddPostState {
  final List<AssetEntity> selectedAssetList;

  AddPostSelectedAssetsChangedState({required this.selectedAssetList});
}
