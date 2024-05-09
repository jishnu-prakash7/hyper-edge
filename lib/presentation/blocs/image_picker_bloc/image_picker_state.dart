part of 'image_picker_bloc.dart';

@immutable
sealed class ImagePickerState {}

final class ImagePickerInitial extends ImagePickerState {}

class AlbumsLoadingState extends ImagePickerState {}

class AlbumsLoadedState extends ImagePickerState {
  final List<AssetPathEntity> albumList;

  AlbumsLoadedState({required this.albumList});
}

class AssetsLoadingState extends ImagePickerState {}

class AssetsLoadedState extends ImagePickerState {
  final List<AssetEntity> assetList;

  AssetsLoadedState({required this.assetList});
}

class AssetsLoadingFailureState extends ImagePickerState {
  final String errorMessage;

  AssetsLoadingFailureState({required this.errorMessage});
}

class AlbumsLoadingFailureState extends ImagePickerState {
  final String errorMessage;

  AlbumsLoadingFailureState({required this.errorMessage});
}

class SelectAlbumState extends ImagePickerState {
  final AssetPathEntity asset;

  SelectAlbumState({
    required this.asset,
  });
}

class SelectAssetState extends ImagePickerState {
  final AssetEntity assetimage;

  SelectAssetState({
    required this.assetimage,
  });
}

class DeselectAssetState extends ImagePickerState {
  final AssetEntity assetimage;

  DeselectAssetState({
    required this.assetimage,
  });
}


