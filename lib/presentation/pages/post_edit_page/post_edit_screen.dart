// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/core/constants.dart';
import 'package:social_media/data/image_picker/media_picker.dart';
import 'package:social_media/domain/models/post_model.dart';
import 'package:social_media/presentation/blocs/all_followers_posts_bloc/all_followers_posts_bloc.dart';
import 'package:social_media/presentation/blocs/edit_post_bloc/edit_post_bloc.dart';
import 'package:social_media/presentation/blocs/loggined_user_post_bloc/loggined_user_post_bloc.dart';
import 'package:social_media/presentation/blocs/profile_posts_bloc/profile_bloc.dart';
import 'package:social_media/presentation/pages/home_page/home_screen.dart';
import 'package:social_media/presentation/widgets/common_widgets.dart';

class PostEditScreen extends StatefulWidget {
  final Post post;
  const PostEditScreen({super.key, required this.post});

  @override
  State<PostEditScreen> createState() => _PostEditScreenState();
}

class _PostEditScreenState extends State<PostEditScreen> {
  String image = '';
  List<AssetEntity> selectedAssetList = [];
  late TextEditingController descriptionController;
  final _formkey = GlobalKey<FormState>();

  Future<void> pickAssets(
      {required int maxcount, required RequestType requestType}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MediaPicker(maxcount, requestType),
      ),
    );
    if (result != null) {
      context
          .read<EditPostBloc>()
          .add(EditPostPickImageEvent(assetList: result));
    }
  }

  @override
  void initState() {
    descriptionController =
        TextEditingController(text: widget.post.description);
    image = widget.post.image;
    super.initState();
  }

  @override
  void dispose() {
    selectedAssetList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editPostBloc = context.read<EditPostBloc>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: appbarTitle(title: 'Edit Profile'),
      ),
      body: BlocConsumer<EditPostBloc, EditPostState>(
        listener: (context, state) {
          if (state is EditPostSuccesfulState) {
            customSnackBar(context, 'Post Updated Succesfully', kTeal);
            context
                .read<LogginedUserPostBloc>()
                .add(LogginedUserPostInitilDataFetchEvent());
            context
                .read<ProfileBloc>()
                .add(ProfileInitialPostFetchEvent(userId: logginedUserId));
            context
                .read<AllFollowersPostsBloc>()
                .add(AllFollowersPostsInitialFetchEvent());
            Navigator.pop(context);
          } else if (state is EditPostPostNotFoundState) {
            customSnackBar(context, 'post not found', kRed);
          } else if (state is EditPostDbUpdateErrorState) {
            customSnackBar(context, 'db update error', kRed);
          }
        },
        builder: (context, state) {
          if (state is EditPostSelectedAssetsChangedState) {
            selectedAssetList = state.selectedAssetList;
          }
          return Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          selectedAssetList.isEmpty
                              ? Image.network(
                                  width: MediaQuery.of(context).size.width,
                                  widget.post.image,
                                  height: 250,
                                  fit: BoxFit.fill,
                                )
                              : PageView.builder(
                                  itemCount: selectedAssetList.length,
                                  itemBuilder: (context, index) {
                                    AssetEntity assetEntity =
                                        selectedAssetList[index];
                                    return AssetEntityImage(
                                      fit: BoxFit.fill,
                                      assetEntity,
                                      isOriginal: false,
                                    );
                                  },
                                ),
                          Positioned(
                            left: MediaQuery.of(context).size.width - 50,
                            top: 210,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  pickAssets(
                                    maxcount: 10,
                                    requestType: RequestType.common,
                                  );
                                },
                                child: const Icon(
                                  Iconsax.edit5,
                                  size: 25,
                                  color: kBlack,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        profileAndAddPostTextfield(
                            labelText: 'Description',
                            height: 120,
                            controller: descriptionController,
                            fieldEmptyMessage: 'Description cannot be empty!',
                            validationMessage:
                                ' field must contains atleast one letter!',
                            regEx: descriptionValidator),
                        kheight20,
                        state is EditPostLoadingState
                            ? loadingElevatedButton(context)
                            : customElevatedButton(
                                context,
                                backgroundColor: kBlack,
                                textColor: kWhite,
                                title: 'Update',
                                onpressed: () {
                                  if (_formkey.currentState!.validate()) {
                                    editPostBloc.add(
                                      EditPostButtonClickEvent(
                                        image: selectedAssetList.isEmpty
                                            ? image
                                            : selectedAssetList[0],
                                        description: descriptionController.text,
                                        postId: widget.post.id,
                                        imageUrl: selectedAssetList.isEmpty
                                            ? image
                                            : '',
                                      ),
                                    );
                                  } else {
                                    customSnackBar(context,
                                        'Please select an image', kRed);
                                  }
                                },
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
