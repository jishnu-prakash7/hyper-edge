// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/core/constants.dart';
import 'package:social_media/domain/models/postuser_model.dart';
import 'package:social_media/presentation/blocs/all_followers_posts_bloc/all_followers_posts_bloc.dart';
import 'package:social_media/presentation/blocs/profile_details_bloc/profile_details_bloc.dart';
import 'package:social_media/presentation/blocs/profile_edit_bloc/profile_edit_bloc.dart';
import 'package:social_media/presentation/pages/profile_edit_page/widgets/text_form_field.dart';
import 'package:social_media/presentation/widgets/common_widgets.dart';

class ProfielEditScreen extends StatefulWidget {
  final User user;
  const ProfielEditScreen({super.key, required this.user});

  @override
  State<ProfielEditScreen> createState() => _ProfielEditScreenState();
}

class _ProfielEditScreenState extends State<ProfielEditScreen> {
  late TextEditingController nameController;
  late TextEditingController bioController;
  File? _imageFile;
  File? _bgImage;

  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    nameController = TextEditingController(text: widget.user.name);
    bioController = TextEditingController(text: widget.user.bio);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profileEditBloc = context.read<ProfileEditBloc>();
    return Scaffold(
      appBar: AppBar(
        title: appbarTitle(title: 'Profile Edit'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: BlocConsumer<ProfileEditBloc, ProfileEditState>(
        listener: (context, state) {
          if (state is ProfileEditSuccesfulState) {
            _imageFile = null;
            customSnackBar(context, 'Profile Updated Succesfully', kTeal);
            context
                .read<ProfileDetailsBloc>()
                .add(ProfileInitialDetailsFetchEvent());
            context
                .read<AllFollowersPostsBloc>()
                .add(AllFollowersPostsInitialFetchEvent());
            Navigator.pop(context);
          } else if (state is ProfileEditDbUpdateErrorState) {
            customSnackBar(context, 'something went wrong', kRed);
          } else if (state is ProfileEditServerErrorState) {
            customSnackBar(
                context, 'something went wrong try after sometime', kRed);
          }
        },
        builder: (context, state) {
          if (state is ProfileEditImagePickedState) {
            _imageFile = state.image;
          }
          if (state is ProfileEditBgImagePickedState) {
            _bgImage = state.bgImage;
          }
          return Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final image = await pickImage();
                          context.read<ProfileEditBloc>().add(
                              ProfileEditBgImagePickerEvent(bgImage: image));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 90),
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                          ),
                          height: 230,
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              _bgImage == null
                                  ? Image.network(
                                      width: MediaQuery.of(context).size.width,
                                      widget.user.backGroundImage,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      width: MediaQuery.of(context).size.width,
                                      _bgImage!,
                                      fit: BoxFit.cover,
                                    ),
                              Positioned(
                                left: MediaQuery.of(context).size.width - 50,
                                top: 190,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  child: GestureDetector(
                                    onTap: () async {
                                      // final image = await pickImage();
                                      // context.read<ProfileEditBloc>().add(
                                      //     ProfileEditBgImagePickerEvent(
                                      //         bgImage: image));
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
                      Positioned(
                          left: 10,
                          top: 140,
                          child: CircleAvatar(
                            backgroundColor: kWhite,
                            radius: 84,
                            child: GestureDetector(
                              onTap: () async {
                                final image = await pickImage();
                                context.read<ProfileEditBloc>().add(
                                    ProfileEditImagePickerEvent(image: image));
                              },
                              child: CircleAvatar(
                                backgroundImage: _imageFile == null
                                    ? NetworkImage(widget.user.profilePic)
                                    : Image.file(_imageFile!).image,
                                backgroundColor:
                                    const Color.fromARGB(255, 195, 194, 194),
                                radius: 80,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: 4,
                                      right: 5,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            pickImage();
                                          },
                                          child: const Icon(
                                            Iconsax.edit5,
                                            size: 30,
                                            color: kBlack,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        profileEditTextFormField(
                          context: context,
                          labeltext: 'Name',
                          controller: nameController,
                        ),
                        kheight10,
                        profileEditTextFormField(
                            context: context,
                            labeltext: 'Bio',
                            controller: bioController,
                            maxlines: 3),
                        kheight20,
                        state is ProfileEditLoadingState
                            ? loadingElevatedButton(context)
                            : customElevatedButton(context,
                                backgroundColor: kBlack,
                                textColor: kWhite,
                                title: 'Update', onpressed: () async {
                                // if (_formkey.currentState!.validate()) {
                                // var imageUrl = '';
                                // if (_imageFile != null) {
                                //   // imageUrl =
                                //   //     await PostRepo.uploadImage(_imageFile);
                                // }
                                profileEditBloc.add(
                                  EditProfileButtonClickEvent(
                                      name: nameController.text,
                                      bio: bioController.text,
                                      image:
                                          _imageFile ?? widget.user.profilePic,
                                      imageUrl: _imageFile == null
                                          ? widget.user.profilePic
                                          : '',
                                      bgImage: _bgImage ??
                                          widget.user.backGroundImage,
                                      bgImageUrl: _bgImage == null
                                          ? widget.user.backGroundImage
                                          : ''),
                                );
                                // }
                              })
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
