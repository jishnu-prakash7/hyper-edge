// ignore_for_file: use_build_context_synchronously

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/core/constants.dart';
import 'package:social_media/data/socket/socket.dart';
import 'package:social_media/presentation/blocs/all_followers_posts_bloc/all_followers_posts_bloc.dart';
import 'package:social_media/presentation/blocs/fetch_all_conversations_bloc.dart/fetch_all_conversations_bloc.dart';
import 'package:social_media/presentation/blocs/profile_details_bloc/profile_details_bloc.dart';
import 'package:social_media/presentation/pages/home_page/widgets/home_page_loading.dart';
import 'package:social_media/presentation/pages/home_page/widgets/post_view.dart';
import 'package:social_media/presentation/pages/home_page/widgets/rich_text.dart';
import 'package:social_media/presentation/pages/suggession_page/suggession_screen.dart';
import 'package:social_media/presentation/widgets/common_widgets.dart';

String logginedUserToken = '';
String logginedUserId = '';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

TextEditingController commentController = TextEditingController();

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    SocketService().connectSocket(context: context);

    context
        .read<AllFollowersPostsBloc>()
        .add(AllFollowersPostsInitialFetchEvent());
    context.read<ProfileDetailsBloc>().add(ProfileInitialDetailsFetchEvent());
    context
        .read<FetchAllConversationsBloc>()
        .add(AllConversationsInitialFetchEvent());
    getToken();
    super.initState();
  }

  getToken() async {
    logginedUserToken = (await getUsertoken())!;
    logginedUserId = (await getUserId())!;
  }

  Future<void> refresh() async {
    await Future.delayed(const Duration(seconds: 2));
    context
        .read<AllFollowersPostsBloc>()
        .add(AllFollowersPostsInitialFetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kbackgroundColor,
        title: const Text(
          'hyper edge',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
              onPressed: () {
                customRoutePush(context, const SuggessionScreen());
              },
              icon: const Icon(
                Iconsax.user_cirlce_add,
                size: 28,
              )),
        ],
      ),
      body: CustomMaterialIndicator(
        indicatorBuilder: (context, controller) {
          return LoadingAnimationWidget.inkDrop(
            color: kBlack,
            size: 30,
          );
        },
        onRefresh: refresh,
        child: BlocConsumer<AllFollowersPostsBloc, AllFollowersPostsState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is AllFollowersPostsSuccesfulState) {
              var posts = state.posts;
              return posts.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No posts',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          kheight10,
                          Richtext()
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        PostView(
                          posts: posts,
                          menuItem1: 'Save',
                          menuItem2: 'Report',
                          menuItem1Icon: Icons.bookmark_border_rounded,
                          menuItem2Icon: Icons.info_outline,
                          item1onTap: () {},
                          item2onTap: () {},
                          commentController: commentController,
                        ),
                      ],
                    );
            } else if (state is AllFollowersPostsLoadingState) {
              return homepageloading();
            } else {
              return const Text('');
            }
          },
        ),
      ),
    );
  }
}
