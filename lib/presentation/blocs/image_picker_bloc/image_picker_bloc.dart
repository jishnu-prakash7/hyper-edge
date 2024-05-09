import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

part 'image_picker_event.dart';
part 'image_picker_state.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  ImagePickerBloc() : super(ImagePickerInitial()) {
    on<ImagePickerEvent>((event, emit) {});
    on<LoadAssetsEvent>(loadAssetsEvent);
    on<LoadAlbumsEvent>(loadAlbumsEvent);
    on<SelectedAssetEvent>(selectedAssetEvent);
    on<DeselectedAssetEvent>(deselectedAssetEvent);
  }

  FutureOr<void> loadAssetsEvent(
      LoadAssetsEvent event, Emitter<ImagePickerState> emit) async {
    emit(AssetsLoadingState());
    try {
      emit(AssetsLoadedState(assetList: event.assets));
    } catch (e) {
      emit(AssetsLoadingFailureState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> loadAlbumsEvent(
      LoadAlbumsEvent event, Emitter<ImagePickerState> emit) async {
    emit(AlbumsLoadingState());
    try {
      emit(AlbumsLoadedState(albumList: event.albums));
    } catch (e) {
      emit(AlbumsLoadingFailureState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> selectedAssetEvent(
      SelectedAssetEvent event, Emitter<ImagePickerState> emit) {
    emit(SelectAssetState(assetimage: event.asset));
  }

  FutureOr<void> deselectedAssetEvent(
      DeselectedAssetEvent event, Emitter<ImagePickerState> emit) {
    emit(DeselectAssetState(assetimage: event.asset));
  }
}
