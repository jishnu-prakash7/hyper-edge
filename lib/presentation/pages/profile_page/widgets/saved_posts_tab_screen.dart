import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/core/constants.dart';
import 'package:social_media/presentation/blocs/fetch_saved_posts/fetch_saved_posts_bloc.dart';
import 'package:social_media/presentation/pages/profile_page/widgets/posts_loading.dart';
import 'package:social_media/presentation/pages/profile_page/widgets/saved_post_detailed_view.dart';
import 'package:social_media/presentation/widgets/common_widgets.dart';

class SavedPostTabScreen extends StatefulWidget {
  const SavedPostTabScreen({super.key});

  @override
  State<SavedPostTabScreen> createState() => _SavedPostTabScreenState();
}

class _SavedPostTabScreenState extends State<SavedPostTabScreen> {
  @override
  void initState() {
    context.read<FetchSavedPostsBloc>().add(SavedPostsInitialFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FetchSavedPostsBloc, FetchSavedPostsState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is FetchSavedPostsSuccesfulState) {
          final posts = state.posts;
          return posts.isEmpty
              ? const Center(
                  heightFactor: 15,
                  child: Text('No saved posts!',style:
                          TextStyle(fontWeight: FontWeight.w600,)),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(5),
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: posts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return GestureDetector(
                      onTap: () {
                        customRoutePush(context,
                            SavedPostDetailedView(initialIndex: index));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: kborderRadius10,
                          color: Colors.grey,
                        ),
                        margin: const EdgeInsets.all(5),
                        child: ClipRRect(
                          borderRadius: kborderRadius10,
                          child: Image.network(
                            post.postId.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                );
        } else if (state is FetchSavedPostsLoadingState) {
          return postsShimmerLoading();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
