import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_bloc_builder/builders/multi_bloc_builder.dart';
import 'package:multi_bloc_builder/multi_bloc_builder.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/domain/models/postuser_model.dart';
import 'package:social_media/presentation/blocs/fetch_followers_bloc/fetch_followers_bloc.dart';
import 'package:social_media/presentation/blocs/fetch_followings_bloc/fetch_followings_bloc.dart';
import 'package:social_media/presentation/blocs/fetch_saved_posts/fetch_saved_posts_bloc.dart';
import 'package:social_media/presentation/blocs/follow_unfollow_user_bloc/follow_unfollow_user_bloc.dart';
import 'package:social_media/presentation/blocs/loggined_user_post_bloc/loggined_user_post_bloc.dart';
import 'package:social_media/presentation/blocs/profile_details_bloc/profile_details_bloc.dart';
import 'package:social_media/presentation/blocs/profile_posts_bloc/profile_bloc.dart';
import 'package:social_media/presentation/blocs/saved_post_bloc/saved_post_bloc.dart';
import 'package:social_media/presentation/pages/profile_page/widgets/bg_image_section.dart';
import 'package:social_media/presentation/pages/profile_page/widgets/details_loading.dart';
import 'package:social_media/presentation/pages/profile_page/widgets/post_tab_screen.dart';
import 'package:social_media/presentation/pages/profile_page/widgets/saved_posts_tab_screen.dart';
import 'package:social_media/presentation/pages/profile_page/widgets/user_details_section.dart';
import 'package:social_media/presentation/pages/settings_page/settings_screen.dart';
import 'package:social_media/presentation/widgets/common_widgets.dart';

User? logginedUser;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  User? user;
  int? followersCount;
  int? followingsCount;
  int? postCount;

  @override
  void initState() {
    super.initState();
    context.read<ProfileDetailsBloc>().add(ProfileInitialDetailsFetchEvent());
    context.read<FetchFollowersBloc>().add(FollowersInitialFetchEvent());
    context.read<FetchFollowingsBloc>().add(FollowingsInitialFetchEvent());
    context
        .read<LogginedUserPostBloc>()
        .add(LogginedUserPostInitilDataFetchEvent());

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kbackgroundColor,
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                customRoutePush(context, const SettingsScreen());
              },
              icon: const Icon(
                Icons.settings_outlined,
                size: 28,
              ),
            )
          ],
          title: const Text(
            'Profile',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: kbackgroundColor,
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                MultiBlocBuilder(
                  blocs: [
                    context.watch<ProfileDetailsBloc>(),
                    context.watch<ProfileBloc>(),
                    context.watch<FetchFollowersBloc>(),
                    context.watch<FetchFollowingsBloc>(),
                    context.watch<SavedPostBloc>(),
                    context.watch<LogginedUserPostBloc>(),
                    context.watch<FollowUnfollowUserBloc>(),
                  ],
                  builder: (context, state) {
                    var state3 = state[2];
                    var state4 = state[3];
                    var state6 = state[5];
                    if (state[4] is RemoveSavedPostSuccesfulState) {
                      context
                          .read<FetchSavedPostsBloc>()
                          .add(SavedPostsInitialFetchEvent());
                    }
                    if (state[4] is SavePostSuccesfulState) {
                      context
                          .read<FetchSavedPostsBloc>()
                          .add(SavedPostsInitialFetchEvent());
                    }

                    if (state3 is FetchFollowersSuccesfulState) {
                      followersCount = state3.followersModel.totalCount;
                    }
                    if (state4 is FetchFollowingsSuccesfulState) {
                      followingsCount = state4.followingsModel.totalCount;
                    }
                    if (state6 is LogginedUserPostFetchSuccesfulState) {
                      debugPrint('posts count is-$postCount');
                      postCount = state6.posts.length;
                    }
                    if (state[0] is ProfileDetailsFetchSuccesfulState) {
                      user = state[0].user;
                      logginedUser = state[0].user;
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          backgroundImageSection(context,
                              image: user!.backGroundImage),
                          profileDetailsSection(context,
                              userName: user!.userName,
                              followersCount: followersCount.toString(),
                              followingsCount: followingsCount.toString(),
                              postCount: postCount.toString(),
                              user: user!,
                              bio: user?.bio ?? ''),
                          Positioned(
                            left: 40,
                            top: 60,
                            child: CircleAvatar(
                              radius: 68,
                              backgroundColor: kWhite,
                              child: CircleAvatar(
                                radius: 65,
                                backgroundImage: NetworkImage(user!.profilePic),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (state[0] is ProfileDetailsFetchLoadingState) {
                      return detailsShimmerLoading(context);
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                TabBar(
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: kGrey,
                  controller: _tabController,
                  tabs: const [
                    Tab(
                      child: Text(
                        'Posts',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: kBlack),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Saved',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: kBlack),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      PostTabScreen(),
                      SavedPostTabScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
