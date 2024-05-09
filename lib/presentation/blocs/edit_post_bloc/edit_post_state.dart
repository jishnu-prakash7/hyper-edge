part of 'edit_post_bloc.dart';

@immutable
sealed class EditPostState {}

final class EditPostInitial extends EditPostState {}

final class EditPostLoadingState extends EditPostState {}

final class EditPostSuccesfulState extends EditPostState {}

final class EditPostPostNotFoundState extends EditPostState {}

final class EditPostDbUpdateErrorState extends EditPostState {}

final class EditPostServerErrorState extends EditPostState {}

final class EditPostErrorState extends EditPostState {}

class EditPostSelectedAssetsChangedState extends EditPostState {
  final List<AssetEntity> selectedAssetList;

  EditPostSelectedAssetsChangedState({
    required this.selectedAssetList,
  });
}
