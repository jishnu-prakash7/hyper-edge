import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_bloc_builder/builders/multi_bloc_builder.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/domain/models/saved_post_model.dart';
import 'package:social_media/presentation/blocs/delete_post_bloc/delete_post_bloc.dart';
import 'package:social_media/presentation/blocs/fetch_saved_posts/fetch_saved_posts_bloc.dart';
import 'package:social_media/presentation/blocs/loggined_user_post_bloc/loggined_user_post_bloc.dart';
import 'package:social_media/presentation/blocs/profile_posts_bloc/profile_bloc.dart';
import 'package:social_media/presentation/pages/home_page/home_screen.dart';
import 'package:social_media/presentation/pages/home_page/widgets/home_page_loading.dart';
import 'package:social_media/presentation/pages/profile_page/widgets/post_view.dart';
import 'package:social_media/presentation/widgets/common_widgets.dart';

class PostDetailedViewScreen extends StatefulWidget {
  final int initialIndex; 
  final String? userId;
  final String? otherUser;
  const PostDetailedViewScreen(
      {super.key, required this.initialIndex, this.userId, this.otherUser});

  @override
  State<PostDetailedViewScreen> createState() => _PostDetailedViewScreenState();
}

class _PostDetailedViewScreenState extends State<PostDetailedViewScreen> {
  @override
  void initState() {
    context
        .read<ProfileBloc>()
        .add(ProfileInitialPostFetchEvent(userId: widget.userId ?? ''));
    // context.read<FetchSavedPostsBloc>().add(SavedPostsInitialFetchEvent());
    super.initState();
  }

  List<SavedPostModel> savedPosts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: appbarTitle(title: 'Posts'),
      ),
      body: MultiBlocBuilder(
        blocs: [
          context.watch<ProfileBloc>(),
          context.watch<FetchSavedPostsBloc>()
        ],
        builder: (context, state) {
          var state1 = state[0];
          var state2 = state[1];
          if (state2 is FetchSavedPostsSuccesfulState) {
            savedPosts = state2.posts;
          }
          if (state1 is ProfileInitial) {
            context
                .read<ProfileBloc>()
                .add(ProfileInitialPostFetchEvent(userId: logginedUserId));
          }
          if (state1 is ProfilePostFetchSuccesfulState) {
            final posts = state1.posts;
            return Column(
              children: [
                BlocConsumer<DeletePostBloc, DeletePostState>(
                  listener: (context, state) {
                    if (state is DeletePostSuccesfulState) {
                      customSnackBar(
                          context, 'Post deleted succesfully', kTeal);
                      context
                          .read<LogginedUserPostBloc>()
                          .add(LogginedUserPostInitilDataFetchEvent());
                      context.read<ProfileBloc>().add(
                          ProfileInitialPostFetchEvent(userId: logginedUserId));
                    } else if (state is DeletePostDbErrorState) {
                      customSnackBar(context, 'Try after sometime', kRed);
                    } else if (state is DeletePostServerErrorState) {
                      customSnackBar(context,
                          'Something went wrong try after sometime', kRed);
                    }
                  },
                  builder: (context, state) {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: posts.length,
                          controller: ScrollController(
                            initialScrollOffset: widget.initialIndex == 0
                                ? 0
                                : widget.initialIndex * 450.0,
                          ),
                          itemBuilder: (context, index) {
                            final post = posts[index];
                            return PostView(
                              posts:
                                  widget.otherUser != null ? savedPosts : null,
                              post: post,
                              image: post.image,
                              likes: post.likes,
                              description: post.description,
                              id: post.id,
                              userId: post.userId.id,
                              saved: widget.otherUser != null ? true : false,
                              userName: post.userId.userName,
                              profilePic: post.userId.profilePic,
                              creartedAt: post.createdAt,
                              hidden:
                                  widget.otherUser != null ? post.hidden : null,
                              blocked: widget.otherUser != null
                                  ? post.blocked
                                  : null,
                              tags: widget.otherUser != null ? [] : null,
                              date: widget.otherUser != null
                                  ? DateTime.now()
                                  : null,
                              updatedAt: post.updatedAt,
                              taggedUsers: widget.otherUser != null ? [] : null,
                            );
                          }),
                    );
                  },
                )
                // profilepostview(
                //     posts: posts,
                //     menuItem1: 'Edit',
                //     menuItem2: 'Delete',
                //     menuItem1Icon: Icons.edit,
                //     menuItem2Icon: Icons.delete,
                //     initialIndex: widget.initialIndex),
              ],
            );
          } else if (state is ProfilePostFetchLoadingState) {
            return homepageloading();
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
