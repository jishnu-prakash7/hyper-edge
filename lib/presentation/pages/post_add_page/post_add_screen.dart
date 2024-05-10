// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/core/constants.dart';
import 'package:social_media/data/image_picker/media_picker.dart';
import 'package:social_media/presentation/blocs/add_post_bloc/add_post_bloc.dart';
import 'package:social_media/presentation/blocs/all_followers_posts_bloc/all_followers_posts_bloc.dart';
import 'package:social_media/presentation/blocs/loggined_user_post_bloc/loggined_user_post_bloc.dart';
import 'package:social_media/presentation/blocs/profile_posts_bloc/profile_bloc.dart';
import 'package:social_media/presentation/pages/home_page/home_screen.dart';
import 'package:social_media/presentation/pages/main_page/main_page.dart';
import 'package:social_media/presentation/widgets/common_widgets.dart';

class AddPostdScreen extends StatefulWidget {
  const AddPostdScreen({super.key});

  @override
  AddPostdScreenState createState() => AddPostdScreenState();
}

class AddPostdScreenState extends State<AddPostdScreen> {
  List<AssetEntity> selectedAssetList = [];
  TextEditingController descriptionController = TextEditingController();
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
      context.read<AddPostBloc>().add(AddPostPickImageEvent(imageList: result));
    }
  }

  @override
  void dispose() {
    selectedAssetList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addpostBloc = context.read<AddPostBloc>();
    return Scaffold(
      appBar: AppBar(
        title: appbarTitle(title: 'Add Post'),
        backgroundColor: kbackgroundColor,
      ),
      body: BlocConsumer<AddPostBloc, AddPostState>(
        listener: (context, state) {
          if (state is AddPostSuccesfulState) {
            customSnackBar(context, 'Post added succesfully', kTeal);
            selectedAssetList = [];
            descriptionController.clear();
            context
                .read<AllFollowersPostsBloc>()
                .add(AllFollowersPostsInitialFetchEvent());
            context
                .read<LogginedUserPostBloc>()
                .add(LogginedUserPostInitilDataFetchEvent());
            context
                .read<ProfileBloc>()
                .add(ProfileInitialPostFetchEvent(userId: logginedUserId));
            indexChangeNotifier.value = 0;
          } else if (state is AddPostServerErrorState) {
            customSnackBar(context, 'Something went wrong', kRed);
          } else if (state is AddPostDbErrorState) {
            customSnackBar(context, 'Please try after sometime', kRed);
          }
        },
        builder: (context, state) {
          if (state is AddPostSelectedAssetsChangedState) {
            selectedAssetList = state.selectedAssetList;
          }
          return Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  constraints:const BoxConstraints(maxWidth: 500),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            // border: Border.all(width: .5),
                            color: kWhite,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 250,
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            children: [
                              selectedAssetList.isEmpty
                                  ? Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          pickAssets(
                                            maxcount: 10,
                                            requestType: RequestType.common,
                                          );
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              const MaterialStatePropertyAll(
                                                  kWhite),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              side: const BorderSide(color: kBlack),
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Choose Image',
                                          style: TextStyle(color: kBlack),
                                        ),
                                      ),
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
                              selectedAssetList.isNotEmpty
                                  ? Positioned(
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
                                  : const SizedBox()
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
                            state is AddPostLoadingState
                                ? loadingElevatedButton(context)
                                : customElevatedButton(
                                    context,
                                    backgroundColor: kBlack,
                                    textColor: kWhite,
                                    title: 'Post',
                                    onpressed: () async {
                                      if (_formkey.currentState!.validate() &&
                                          selectedAssetList.isNotEmpty) {
                                        addpostBloc.add(AddpostButtonClickEvent(
                                            image: selectedAssetList[0],
                                            description:
                                                descriptionController.text));
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
              ),
            ),
          );
        },
      ),
    );
  }
}
