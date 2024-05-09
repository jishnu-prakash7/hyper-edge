import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_bloc_builder/builders/multi_bloc_builder.dart';
import 'package:social_media/domain/models/fetch_explore_post_model.dart';
import 'package:social_media/domain/models/saved_post_model.dart';
import 'package:social_media/presentation/blocs/fetch_explore_post_bloc/fetch_explore_post_bloc.dart';
import 'package:social_media/presentation/blocs/fetch_saved_posts/fetch_saved_posts_bloc.dart';
import 'package:social_media/presentation/pages/home_page/widgets/home_page_loading.dart';
import 'package:social_media/presentation/pages/profile_page/widgets/post_view.dart';
import 'package:social_media/presentation/widgets/common_widgets.dart';

class ExplorePostDetailedViewScreen extends StatefulWidget {
  final int initialIndex;
  const ExplorePostDetailedViewScreen({super.key, required this.initialIndex});

  @override
  State<ExplorePostDetailedViewScreen> createState() =>
      _ExplorePostDetailedViewScreenState();
}

class _ExplorePostDetailedViewScreenState
    extends State<ExplorePostDetailedViewScreen> {
  @override
  void initState() {
    context.read<FetchExplorePostBloc>().add(ExplorePostInitialFetchEvent());
    super.initState();
  }

  List<ExplorePostModel> posts = [];
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
        title: appbarTitle(title: 'Explore'),
      ),
      body: MultiBlocBuilder(
        blocs: [
          context.watch<FetchExplorePostBloc>(),
          context.watch<FetchSavedPostsBloc>(),
        ],
        builder: (context, state) {
          var state1 = state[0];
          var state2 = state[1];
          if (state2 is FetchSavedPostsSuccesfulState) {
            savedPosts = state2.posts;
          }
          if (state1 is FetchExplorePostSuccesfulState) {
            posts = state1.posts;
            return Column(
              children: [
                Expanded(
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
                          saved: true,
                          post: post,
                          image: post.image,
                          likes: post.likes,
                          description: post.description,
                          id: post.id,
                          userId: post.userId.id,
                          posts: savedPosts,
                          taggedUsers: post.taggedUsers,
                          blocked: post.blocked,
                          hidden: post.hidden,
                          creartedAt: post.createdAt,
                          updatedAt: post.updatedAt,
                          date: post.date,
                          tags: const [],
                          profilePic: post.userId.profilePic,
                          userName: post.userId.userName,
                        );
                      }),
                )
              ],
            );
          } else if (state1 is FetchExplorePostLoadingState) {
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
