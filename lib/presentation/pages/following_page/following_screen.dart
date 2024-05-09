import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_bloc_builder/builders/multi_bloc_builder.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/core/constants.dart';
import 'package:social_media/domain/models/followings_model.dart';
import 'package:social_media/presentation/blocs/all_followers_posts_bloc/all_followers_posts_bloc.dart';
import 'package:social_media/presentation/blocs/fetch_followings_bloc/fetch_followings_bloc.dart';
import 'package:social_media/presentation/blocs/follow_unfollow_user_bloc/follow_unfollow_user_bloc.dart';
import 'package:social_media/presentation/pages/followers_page/widgets/followers_loading.dart';
import 'package:social_media/presentation/pages/suggession_page/suggession_screen.dart';
import 'package:social_media/presentation/pages/user_profile_page/user_profile_screen.dart';
import 'package:social_media/presentation/widgets/common_widgets.dart';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({super.key});

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  List<Following> followings = [];
  @override
  void initState() {
    context.read<FetchFollowingsBloc>().add(FollowingsInitialFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const UnderlineInputBorder(
          borderSide: BorderSide(
            width: .5,
            color: Color.fromARGB(255, 196, 196, 196),
          ),
        ),
        backgroundColor: kbackgroundColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: appbarTitle(title: 'Following'),
      ),
      body: MultiBlocBuilder(
        blocs: [
          context.watch<FetchFollowingsBloc>(),
          context.watch<FollowUnfollowUserBloc>()
        ],
        builder: (context, state) {
          if (state[1] is UnFollowUserSuccesfulState) {
            context
                .read<AllFollowersPostsBloc>()
                .add(AllFollowersPostsInitialFetchEvent());
          }
          if (state[0] is FetchFollowingsSuccesfulState) {
            final FollowingsModel followingsModel = state[0].followingsModel;
            followings = followingsModel.following;
            return followings.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('No followings !',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                        kheight10,
                        GestureDetector(
                          onTap: () {
                            customRoutePush(context, const SuggessionScreen());
                          },
                          child: const Text(
                            'Suggested Users?',
                            style: TextStyle(
                                color: kBlue,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: followingsModel.totalCount,
                    itemBuilder: (context, index) {
                      final Following following = followings[index];
                      return GestureDetector(
                        onTap: () {
                          customRoutePush(
                              context,
                              UserProfielScreen(
                                  userId: following.id, user: following));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: kWhite,
                                radius: 28,
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(following.profilePic),
                                  radius: 26,
                                ),
                              ),
                              kWidth10,
                              Text(
                                following.userName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  context.read<FollowUnfollowUserBloc>().add(
                                      UnFollowUserButtonClickEvent(
                                          followeesId: following.id));
                                  followings.removeWhere(
                                      (element) => element.id == following.id);
                                  followingsModel.totalCount--;
                                },
                                child: Container(
                                  height: 28,
                                  width: 70,
                                  decoration: const BoxDecoration(
                                      color: kWhite,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: const Center(
                                      child: Text(
                                    'Unfollow',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: kBlack),
                                  )),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });
          } else if (state[0] is FetchFollowingsLoadingState) {
            return followersLoading();
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
