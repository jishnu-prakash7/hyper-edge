// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multi_bloc_builder/multi_bloc_builder.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:readmore/readmore.dart';
import 'package:social_media/domain/models/comment_model.dart';
import 'package:social_media/domain/models/saved_post_model.dart';
import 'package:social_media/presentation/blocs/delete_post_bloc/delete_post_bloc.dart';
import 'package:social_media/presentation/blocs/get_comments_bloc/get_comments_bloc.dart';
import 'package:social_media/presentation/blocs/like_unlike_post_bloc/like_post_bloc.dart';
import 'package:social_media/presentation/blocs/saved_post_bloc/saved_post_bloc.dart';
import 'package:social_media/presentation/pages/home_page/home_screen.dart';
import 'package:social_media/presentation/pages/home_page/widgets/comment_bottom_sheet.dart';
import 'package:social_media/presentation/pages/post_edit_page/post_edit_screen.dart';
import 'package:social_media/presentation/pages/profile_page/profile_screen.dart';
import 'package:social_media/presentation/widgets/common_widgets.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/core/constants.dart';

final _formkey = GlobalKey<FormState>();
List<Comment> _comments = [];

class PostView extends StatelessWidget {
  const PostView({
    super.key,
    required this.post,
    required this.image,
    required this.likes,
    required this.description,
    required this.id,
    required this.userId,
    required this.saved,
    this.posts,
    this.hidden,
    this.creartedAt,
    this.updatedAt,
    this.taggedUsers,
    this.blocked,
    this.date,
    this.tags,
    required this.profilePic,
    required this.userName,
  });
  final String description;
  final String profilePic;
  final String userName;
  final String image;
  final List likes;
  final post;
  final String id;
  final String userId;
  final bool saved;
  final List<SavedPostModel>? posts;
  final bool? hidden;
  final DateTime? creartedAt;
  final DateTime? updatedAt;
  final List? taggedUsers;
  final bool? blocked;
  final DateTime? date;
  final List<String>? tags;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: const BoxDecoration(
          color: kWhite,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(profilePic),
                  ),
                  kWidth10,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                            ),
                          ),
                          kWidth5,
                          post.createdAt != post.updatedAt
                              ? const Text(
                                  '(Edited)',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 84, 83, 83),
                                      fontSize: 13),
                                )
                              : const SizedBox()
                        ],
                      ),
                      Text(
                        timeago.format(creartedAt!, locale: 'en'),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                  const Spacer(),
                  saved == false
                      ? PopupMenuButton(
                          color: kbackgroundColor,
                          onSelected: (value) {},
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                  onTap: () {
                                    customRoutePush(
                                        context, PostEditScreen(post: post));
                                  },
                                  value: 'Edit',
                                  child: const Row(
                                    children: [
                                      Icon(Icons.edit),
                                      kWidth5,
                                      Text('Edit')
                                    ],
                                  )),
                              PopupMenuItem(
                                onTap: () {
                                  QuickAlert.show(
                                    onConfirmBtnTap: () {
                                      context.read<DeletePostBloc>().add(
                                          DeletePostButtonClickEvent(
                                              postId: post.id));
                                      Navigator.pop(context);
                                    },
                                    headerBackgroundColor: kGrey,
                                    width: 250,
                                    context: context,
                                    type: QuickAlertType.confirm,
                                    text: 'Do you want to Delete post',
                                    confirmBtnText: 'Yes',
                                    cancelBtnText: 'No',
                                    confirmBtnColor: Colors.grey,
                                  );
                                },
                                value: 'Delete',
                                child: const Row(
                                  children: [
                                    Icon(Icons.delete),
                                    kWidth5,
                                    Text('Delete')
                                  ],
                                ),
                              ),
                            ];
                          },
                        )
                      : const SizedBox()
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              constraints: const BoxConstraints(
                  minHeight: 250, maxHeight: 500, maxWidth: 600),
              color: kWhite,
              child: Image(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MultiBlocConsumer(
                buildWhen: null,
                blocs: [
                  context.watch<LikePostBloc>(),
                  context.watch<SavedPostBloc>()
                ],
                listener: (context, state) {},
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // isLiked = !isLiked;
                              if (!likes.contains(logginedUserId)) {
                                likes.add(logginedUserId);
                                context.read<LikePostBloc>().add(
                                      LikePostButtonClickEvent(postId: id),
                                    );
                              } else {
                                likes.remove(logginedUserId);
                                context.read<LikePostBloc>().add(
                                      UnlikePostButtonClickEvent(postId: id),
                                    );
                              }
                            },
                            child: Icon(
                              likes.contains(logginedUserId)
                                  ? Iconsax.heart5
                                  : Iconsax.heart4,
                              color:
                                  likes.contains(logginedUserId) ? kRed : null,
                            ),
                          ),
                          kWidth10,
                          GestureDetector(
                            onTap: () {
                              context
                                  .read<GetCommentsBloc>()
                                  .add(CommentsFetchEvent(postId: id));
                              commentBottomSheet(
                                  context, post, commentController,
                                  formkey: _formkey,
                                  comments: _comments,
                                  profiePic: profilePic,
                                  userName: userName,
                                  id: id);
                            },
                            child: const Icon(
                              Iconsax.message,
                            ),
                          ),
                          const Spacer(),
                          posts != null
                              ? GestureDetector(
                                  onTap: () {
                                    if (posts!.any(
                                        (element) => element.postId.id == id)) {
                                      context.read<SavedPostBloc>().add(
                                          RemoveSavedPostButtonClickEvent(
                                              postId: id));
                                      posts!.removeWhere(
                                          (element) => element.postId.id == id);
                                    } else {
                                      posts!.add(SavedPostModel(
                                          userId: userId,
                                          postId: PostId(
                                              id: id,
                                              userId: UserId.fromJson(
                                                  logginedUser!.toJson()),
                                              image: image,
                                              description: description,
                                              likes: [],
                                              hidden: hidden!,
                                              blocked: blocked!,
                                              tags: tags!,
                                              date: date!,
                                              createdAt: creartedAt!,
                                              updatedAt: updatedAt!,
                                              v: 0,
                                              taggedUsers: taggedUsers!),
                                          createdAt: DateTime.now(),
                                          updatedAt: DateTime.now(),
                                          v: 0));
                                      context.read<SavedPostBloc>().add(
                                          SavePostButtonClickEvent(postId: id));
                                    }
                                  },
                                  child: Icon(
                                    size: 26,
                                    posts!.any((element) =>
                                            element.postId.id == id)
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                  ),
                                )
                              : const SizedBox()
                        ],
                      ),
                      kheight10,
                      likes.isNotEmpty
                          ? Text(
                              '${likes.length} likes',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : const SizedBox(),
                      ReadMoreText(
                        description,
                        trimMode: TrimMode.Line,
                        trimLines: 2,
                        colorClickableText: Colors.pink,
                        trimCollapsedText: 'more',
                        trimExpandedText: 'less',
                        moreStyle: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      )
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
