// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_bloc_builder/builders/multi_bloc_builder.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/core/constants.dart';
import 'package:social_media/domain/models/followings_model.dart';
import 'package:social_media/presentation/blocs/conversation_bloc/conversation_bloc.dart';
import 'package:social_media/presentation/blocs/fetch_all_conversations_bloc.dart/fetch_all_conversations_bloc.dart';
import 'package:social_media/presentation/blocs/fetch_followings_bloc/fetch_followings_bloc.dart';
import 'package:social_media/presentation/blocs/follow_unfollow_user_bloc/follow_unfollow_user_bloc.dart';
import 'package:social_media/presentation/blocs/get_connections_bloc/get_connections_bloc.dart';
import 'package:social_media/presentation/blocs/profile_details_bloc/profile_details_bloc.dart';
import 'package:social_media/presentation/blocs/profile_posts_bloc/profile_bloc.dart';
import 'package:social_media/presentation/blocs/suggessions_bloc/suggessions_bloc.dart';
import 'package:social_media/presentation/pages/home_page/home_screen.dart';
import 'package:social_media/presentation/pages/message_page/chat_screen.dart';
import 'package:social_media/presentation/pages/profile_page/widgets/details_loading.dart';
import 'package:social_media/presentation/pages/profile_page/widgets/post_detailed_view_screen.dart';
import 'package:social_media/presentation/pages/user_profile_page/widgets/background_image_section.dart';
import 'package:social_media/presentation/pages/user_profile_page/widgets/user_profile_grid_view.dart';
import 'package:social_media/presentation/widgets/common_widgets.dart';

class UserProfielScreen extends StatefulWidget {
  final String userId;
  final user;
  const UserProfielScreen({
    super.key,
    required this.userId,
    required this.user,
  });

  @override
  State<UserProfielScreen> createState() => _UserProfielScreenState();
}

class _UserProfielScreenState extends State<UserProfielScreen> {
  List<Following> followings = [];

  @override
  void initState() {
    context.read<FetchFollowingsBloc>().add(FollowingsInitialFetchEvent());
    context
        .read<GetConnectionsBloc>()
        .add(ConnectionsInitilFetchEvent(userId: widget.userId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              context
                  .read<SuggessionsBloc>()
                  .add(SuggessionUserInitialFetchEvent());
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: appbarTitle(title: widget.user.userName),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MultiBlocBuilder(
                blocs: [
                  context.watch<ProfileDetailsBloc>(),
                  context.watch<ProfileBloc>(),
                  context.watch<FetchFollowingsBloc>(),
                  context.watch<GetConnectionsBloc>(),
                  // context.watch<ConversationBloc>(),
                  context.watch<FollowUnfollowUserBloc>(),
                ],
                builder: (context, state) {
                  var state2 = state[1];
                  var state4 = state[3];
                  // var state5 = state[4];
                  if (state[2] is FetchFollowingsSuccesfulState) {
                    final FollowingsModel followingsModel =
                        state[2].followingsModel;
                    followings = followingsModel.following;
                  }
                  if (state[4] is GetAllMessagesSuccesfulState) {
                    context
                        .read<FetchAllConversationsBloc>()
                        .add(AllConversationsInitialFetchEvent());
                  }
                  if (state4 is GetConnectionsSuccesfulState &&
                      state2 is ProfilePostFetchSuccesfulState) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        backgroundImageSection(context,
                            backGroundImage: widget.user.backGroundImage),
                        Positioned(
                          left: 20,
                          top: 130,
                          width: MediaQuery.of(context).size.width - 40,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 460),
                              decoration: BoxDecoration(
                                  borderRadius: kborderRadius5, color: kWhite),
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    right: 10,
                                    top: 40,
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            bool isFollowing = followings.any(
                                                (following) =>
                                                    following.id ==
                                                    widget.userId);
                                            if (isFollowing) {
                                              followings.removeWhere((element) =>
                                                  element.id == widget.userId);
                                              context
                                                  .read<FollowUnfollowUserBloc>()
                                                  .add(
                                                      UnFollowUserButtonClickEvent(
                                                          followeesId:
                                                              widget.userId));
                                            } else {
                                              followings.add(Following(
                                                  id: widget.userId,
                                                  userName: widget.user.userName,
                                                  email: widget.user.email,
                                                  password:
                                                      widget.user.password ?? '',
                                                  phone: widget.user.phone,
                                                  online: widget.user.online,
                                                  blocked: widget.user.blocked,
                                                  verified: widget.user.verified,
                                                  role: widget.user.role,
                                                  isPrivate:
                                                      widget.user.isPrivate,
                                                  createdAt:
                                                      widget.user.createdAt,
                                                  updatedAt:
                                                      widget.user.updatedAt,
                                                  v: widget.user.v,
                                                  profilePic:
                                                      widget.user.profilePic,
                                                  backGroundImage: widget
                                                      .user.backGroundImage));
                                              context
                                                  .read<FollowUnfollowUserBloc>()
                                                  .add(FollowUserButtonClickEvent(
                                                      followeesId:
                                                          widget.userId));
                                            }
                                          },
                                          child: Container(
                                            height: 35,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              color: followings.any((following) =>
                                                      following.id ==
                                                      widget.userId)
                                                  ? kWhite
                                                  : kBlue,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                            ),
                                            child: Center(
                                              child: Text(
                                                followings.any((following) =>
                                                        following.id ==
                                                        widget.userId)
                                                    ? 'Unfollow'
                                                    : 'Follow',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: followings.any(
                                                            (following) =>
                                                                following.id ==
                                                                widget.userId)
                                                        ? kBlack
                                                        : kWhite),
                                              ),
                                            ),
                                          ),
                                        ),
                                        kWidth10,
                                        BlocConsumer<ConversationBloc,
                                            ConversationState>(
                                          listener: (context, state) {
                                            if (state
                                                is ConversationSuccesfulState) {
                                              context
                                                  .read<
                                                      FetchAllConversationsBloc>()
                                                  .add(
                                                      AllConversationsInitialFetchEvent());
                                              customRoutePush(
                                                  context,
                                                  ChatScreen(
                                                    recieverid: widget.userId,
                                                    name: widget.user.userName,
                                                    profilepic:
                                                        widget.user.profilePic,
                                                    conversationId:
                                                        state.conversationId,
                                                  ));
                                            }
                                          },
                                          builder: (context, state) {
                                            return GestureDetector(
                                              onTap: () {
                                                context
                                                    .read<ConversationBloc>()
                                                    .add(
                                                        CreateConversationButtonClickEvent(
                                                            members: [
                                                          logginedUserId,
                                                          widget.user.id
                                                        ]));
                                              },
                                              child: Container(
                                                height: 35,
                                                width: 80,
                                                decoration: const BoxDecoration(
                                                    color: kbackgroundColor,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5))),
                                                child: const Center(
                                                  child: Text(
                                                    'Message',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: kBlack),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    left: 40,
                                    top: 65,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.user.userName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                          overflow: TextOverflow.fade,
                                        ),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width -
                                                  100,
                                          child: Text(
                                            widget.user.bio ?? '',
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                            ),
                                            overflow: TextOverflow.fade,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            customRoutePush(
                                                context,
                                                PostDetailedViewScreen(
                                                  initialIndex: 0,
                                                  userId: widget.userId,
                                                ));
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              followerSectionText(
                                                  text: '${state2.posts.length}'),
                                              followerSectionText(text: 'Posts'),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              followerSectionText(
                                                  text: '${followings.length}'),
                                              followerSectionText(
                                                  text: 'Followers'),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              followerSectionText(
                                                  text:
                                                      '${state4.followingsCount}'),
                                              followerSectionText(
                                                  text: 'Following'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 40,
                          top: 60,
                          child: CircleAvatar(
                            radius: 68,
                            backgroundColor: kWhite,
                            child: CircleAvatar(
                              radius: 65,
                              backgroundImage:
                                  NetworkImage(widget.user.profilePic),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (state4 is GetConnectionsLoadingState) {
                    return detailsShimmerLoading(context);
                  } else {
                    return detailsShimmerLoading(context);
                  }
                },
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Posts',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16, color: kBlack),
                ),
              ),
              Expanded(
                  child: UserPostGridView(
                userId: widget.userId,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
