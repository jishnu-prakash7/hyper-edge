import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/core/constants.dart';
import 'package:social_media/presentation/blocs/loggined_user_post_bloc/loggined_user_post_bloc.dart';
import 'package:social_media/presentation/pages/profile_page/widgets/post_detailed_view_screen.dart';
import 'package:social_media/presentation/pages/profile_page/widgets/posts_loading.dart';
import 'package:social_media/presentation/widgets/common_widgets.dart';

class PostTabScreen extends StatefulWidget {
  final String? userId;
  const PostTabScreen({super.key, this.userId});

  @override
  State<PostTabScreen> createState() => _PostTabScreenState();
}

class _PostTabScreenState extends State<PostTabScreen> {
  @override
  void initState() {
    context
        .read<LogginedUserPostBloc>()
        .add(LogginedUserPostInitilDataFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogginedUserPostBloc, LogginedUserPostState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is LogginedUserPostFetchSuccesfulState) {
          final posts = state.posts;
          return posts.isEmpty
              ? const Center(
                  heightFactor: 15,
                  child: Text('No Posts yet!',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      )),
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
                        customRoutePush(
                            context,
                            PostDetailedViewScreen(
                              initialIndex: index,
                              userId: widget.userId ?? '',
                            ));
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
                            post.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                );
        } else if (state is LogginedUserPostFetchLoadingState) {
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
