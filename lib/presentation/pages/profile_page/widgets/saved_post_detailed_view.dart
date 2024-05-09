import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/domain/models/saved_post_model.dart';
import 'package:social_media/presentation/blocs/fetch_saved_posts/fetch_saved_posts_bloc.dart';
import 'package:social_media/presentation/pages/home_page/widgets/home_page_loading.dart';
import 'package:social_media/presentation/pages/profile_page/widgets/post_view.dart';
import 'package:social_media/presentation/widgets/common_widgets.dart';

class SavedPostDetailedView extends StatefulWidget {
  final int initialIndex;
  const SavedPostDetailedView({super.key, required this.initialIndex});

  @override
  State<SavedPostDetailedView> createState() => _SavedPostDetailedViewState();
}

class _SavedPostDetailedViewState extends State<SavedPostDetailedView> {
  @override
  void initState() {
    context.read<FetchSavedPostsBloc>().add(SavedPostsInitialFetchEvent());
    super.initState();
  }

  List<SavedPostModel> posts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            context
                .read<FetchSavedPostsBloc>()
                .add(SavedPostsInitialFetchEvent());
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: appbarTitle(title: 'Saved'),
      ),
      body: BlocBuilder<FetchSavedPostsBloc, FetchSavedPostsState>(
        builder: (context, state) {
          if (state is FetchSavedPostsSuccesfulState) {
            posts = state.posts;
            return posts.isEmpty
                ? const Center(
                    child: Text(
                      'No Saved !',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : ListView.builder(
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
                        image: post.postId.image,
                        likes: post.postId.likes,
                        description: post.postId.description,
                        id: post.postId.id,
                        userId: post.postId.userId.id,
                        posts: posts,
                        taggedUsers: post.postId.taggedUsers,
                        blocked: post.postId.blocked,
                        hidden: post.postId.hidden,
                        creartedAt: post.postId.createdAt,
                        updatedAt: post.postId.updatedAt,
                        date: post.postId.date,
                        tags: const [],
                        profilePic: post.postId.userId.profilePic,
                        userName: post.postId.userId.userName,
                      );
                    });
          } else if (state is FetchSavedPostsLoadingState) {
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
