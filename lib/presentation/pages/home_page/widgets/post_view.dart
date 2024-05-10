import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:multi_bloc_builder/builders/multi_bloc_builder.dart';
import 'package:readmore/readmore.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/core/constants.dart';
import 'package:social_media/domain/models/comment_model.dart';
import 'package:social_media/domain/models/get_followers_post_model.dart';
import 'package:social_media/domain/models/get_followers_userid_model.dart';
import 'package:social_media/domain/models/save_post_model.dart';
import 'package:social_media/domain/models/saved_post_model.dart';
import 'package:social_media/presentation/blocs/all_followers_posts_bloc/all_followers_posts_bloc.dart';
import 'package:social_media/presentation/blocs/fetch_saved_posts/fetch_saved_posts_bloc.dart';
import 'package:social_media/presentation/blocs/get_comments_bloc/get_comments_bloc.dart';
import 'package:social_media/presentation/blocs/like_unlike_post_bloc/like_post_bloc.dart';
import 'package:social_media/presentation/blocs/saved_post_bloc/saved_post_bloc.dart';
import 'package:social_media/presentation/pages/home_page/home_screen.dart';
import 'package:social_media/presentation/pages/home_page/widgets/comment_bottom_sheet.dart';
import 'package:social_media/presentation/pages/profile_page/profile_screen.dart';
import 'package:social_media/presentation/pages/profile_page/widgets/details_loading.dart';
import 'package:social_media/presentation/pages/user_profile_page/user_profile_screen.dart';
import 'package:social_media/presentation/widgets/common_widgets.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostView extends StatefulWidget {
  final List posts;
  final String menuItem1;
  final String menuItem2;
  final IconData menuItem1Icon;
  final IconData menuItem2Icon;
  final VoidCallback item1onTap;
  final VoidCallback item2onTap;
  final TextEditingController commentController;
  const PostView({
    super.key,
    required this.posts,
    required this.menuItem1,
    required this.menuItem2,
    required this.menuItem1Icon,
    required this.menuItem2Icon,
    required this.item1onTap,
    required this.commentController,
    required this.item2onTap,
  });

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  final _formkey = GlobalKey<FormState>();
  final List<Comment> _comments = [];
  List<SavedPostModel> posts = [];
  SavePostModel? savedPostDetails;

  @override
  void initState() {
    context.read<FetchSavedPostsBloc>().add(SavedPostsInitialFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: false,
        itemCount: context.read<AllFollowersPostsBloc>().isLoadingMore
            ? widget.posts.length + 1
            : widget.posts.length,
        controller: context.read<AllFollowersPostsBloc>().scrollController,
        itemBuilder: (context, index) {
          if (index == widget.posts.length) {
            return context.read<AllFollowersPostsBloc>().isLoadingMore
                ? Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.black,
                      size: 200,
                    ),
                  )
                : Container();
          } else {
            final FollwersPostModel post = widget.posts[index];
            return Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                NetworkImage(post.userId.profilePic),
                          ),
                          kWidth10,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  customRoutePush(
                                      context,
                                      UserProfielScreen(
                                        userId: post.userId.id,
                                        user: post.userId,
                                      ));
                                },
                                child: Text(
                                  post.userId.userName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              Text(
                                timeago.format(post.createdAt, locale: 'en'),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      constraints: const BoxConstraints(
                          minHeight: 250, maxHeight: 400, maxWidth: 600),
                      color: kWhite,
                      child: Image(
                        image: Image.network(
                          post.image,
                          loadingBuilder: (context, child, loadingProgress) {
                            return detailsShimmerLoading(context);
                          },
                        ).image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    MultiBlocBuilder(
                      blocs: [
                        context.watch<LikePostBloc>(),
                        context.watch<FetchSavedPostsBloc>(),
                        context.watch<SavedPostBloc>(),
                      ],
                      builder: (context, state) {
                        var state2 = state[1];
                        if (state2 is FetchSavedPostsSuccesfulState) {
                          posts = state2.posts;
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      final currentUserId = logginedUserId;
                                      final isLiked = post.likes.any(
                                          (user) => user.id == currentUserId);
                                      if (!isLiked) {
                                        post.likes.add(
                                            FollowersUserIdModel.fromJson(
                                                logginedUser!.toJson()));

                                        context.read<LikePostBloc>().add(
                                            LikePostButtonClickEvent(
                                                postId: post.id));
                                      } else {
                                        post.likes.removeWhere(
                                            (user) => user.id == currentUserId);
                                        context.read<LikePostBloc>().add(
                                            UnlikePostButtonClickEvent(
                                                postId: post.id));
                                      }
                                    },
                                    child: Icon(
                                      post.likes.any((user) =>
                                              user.id == logginedUserId)
                                          ? Iconsax.heart5
                                          : Iconsax.heart4,
                                      color: post.likes.any((user) =>
                                              user.id == logginedUserId)
                                          ? kRed
                                          : null,
                                    ),
                                  ),
                                  kWidth10,
                                  GestureDetector(
                                    onTap: () {
                                      context.read<GetCommentsBloc>().add(
                                          CommentsFetchEvent(postId: post.id));
                                      commentBottomSheet(context, post,
                                          widget.commentController,
                                          formkey: _formkey,
                                          userName: post.userId.userName,
                                          profiePic: post.userId.profilePic,
                                          comments: _comments,
                                          id: post.id);
                                    },
                                    child: const Icon(
                                      Iconsax.message,
                                    ),
                                  ),
                                  kWidth10,
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      if (posts.any((element) =>
                                          element.postId.id == post.id)) {
                                        context.read<SavedPostBloc>().add(
                                            RemoveSavedPostButtonClickEvent(
                                                postId: post.id));
                                        posts.removeWhere((element) =>
                                            element.postId.id == post.id);
                                      } else {
                                        posts.add(SavedPostModel(
                                            userId: post.userId.id,
                                            postId: PostId(
                                                id: post.id,
                                                userId: UserId.fromJson(
                                                    post.userId.toJson()),
                                                image: post.image,
                                                description: post.description,
                                                likes: post.likes,
                                                hidden: post.hidden,
                                                blocked: post.blocked,
                                                tags: post.tags,
                                                date: post.date,
                                                createdAt: post.createdAt,
                                                updatedAt: post.updatedAt,
                                                v: post.v,
                                                taggedUsers: post.taggedUsers),
                                            createdAt: DateTime.now(),
                                            updatedAt: DateTime.now(),
                                            v: post.v));
                                        context.read<SavedPostBloc>().add(
                                            SavePostButtonClickEvent(
                                                postId: post.id));
                                      }
                                    },
                                    child: Icon(
                                      size: 26,
                                      posts.any((element) =>
                                              element.postId.id == post.id)
                                          ? Icons.bookmark
                                          : Icons.bookmark_border,
                                    ),
                                  ),
                                ],
                              ),
                              kheight10,
                              post.likes.isNotEmpty
                                  ? Text(
                                      '${post.likes.length} likes',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  : const SizedBox(),
                              ReadMoreText(
                                post.description,
                                trimMode: TrimMode.Line,
                                trimLines: 2,
                                colorClickableText: Colors.pink,
                                trimCollapsedText: 'more',
                                trimExpandedText: 'less',
                                moreStyle: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
      // ),
    );
  }
}
