part of 'image_picker_bloc.dart';

@immutable
sealed class ImagePickerEvent {}

class LoadAlbumsEvent extends ImagePickerEvent {
  final List<AssetPathEntity> albums;

   LoadAlbumsEvent({required this.albums});
}

class LoadAssetsEvent extends ImagePickerEvent {
  final List<AssetEntity> assets;

   LoadAssetsEvent({required this.assets});
}

class SelectedAlbumEvent extends ImagePickerEvent {
  final AssetPathEntity assetvalue;

   SelectedAlbumEvent({required this.assetvalue});
}

class SelectedAssetEvent extends ImagePickerEvent {
  final AssetEntity asset;

  SelectedAssetEvent({required this.asset});
}

class DeselectedAssetEvent extends ImagePickerEvent {
  final AssetEntity asset;

  DeselectedAssetEvent({required this.asset});
}


