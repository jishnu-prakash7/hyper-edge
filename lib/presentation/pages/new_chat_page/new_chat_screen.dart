import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_bloc_builder/builders/multi_bloc_consumer.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/core/constants.dart';
import 'package:social_media/domain/models/followings_model.dart';
import 'package:social_media/presentation/blocs/conversation_bloc/conversation_bloc.dart';
import 'package:social_media/presentation/blocs/fetch_all_conversations_bloc.dart/fetch_all_conversations_bloc.dart';
import 'package:social_media/presentation/blocs/fetch_followers_bloc/fetch_followers_bloc.dart';
import 'package:social_media/presentation/blocs/fetch_followings_bloc/fetch_followings_bloc.dart';
import 'package:social_media/presentation/pages/followers_page/widgets/followers_loading.dart';
import 'package:social_media/presentation/pages/home_page/home_screen.dart';
import 'package:social_media/presentation/pages/home_page/widgets/rich_text.dart';
import 'package:social_media/presentation/pages/message_page/chat_screen.dart';
import 'package:social_media/presentation/widgets/common_widgets.dart';

class NewChatScreen extends StatefulWidget {
  const NewChatScreen({super.key});

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  @override
  void initState() {
    context.read<FetchFollowingsBloc>().add(FollowingsInitialFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kbackgroundColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: appbarTitle(title: 'New Chat'),
      ),
      body: MultiBlocConsumer(
        blocs: [
          context.watch<FetchFollowingsBloc>(),
          context.watch<ConversationBloc>(),
        ],
        buildWhen: null,
        listener: (context, state) {},
        builder: (context, state) {
          if (state[0] is FetchFollowingsSuccesfulState) {
            final FollowingsModel followings = state[0].followingsModel;
            return followings.following.isEmpty
                ? const Center(child: Richtext())
                : ListView.builder(
                    itemCount: followings.totalCount,
                    itemBuilder: (context, index) {
                      final Following following = followings.following[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            context.read<ConversationBloc>().add(
                                CreateConversationButtonClickEvent(
                                    members: [logginedUserId, following.id]));
                            if (state[1] is ConversationSuccesfulState) {
                              context
                                  .read<FetchAllConversationsBloc>()
                                  .add(AllConversationsInitialFetchEvent());
                              customRoutePush(
                                  context,
                                  ChatScreen(
                                    recieverid: following.id,
                                    name: following.userName,
                                    profilepic: following.profilePic,
                                    conversationId: state[1].conversationId,
                                  ));
                            }
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: kWhite,
                                radius: 28,
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(following.profilePic),
                                  radius: 26,
                                ),
                              ),
                              kWidth10,
                              Text(
                                following.userName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
          }
          if (state[0] is FetchFollowersLoadingState) {
            return followersLoading();
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
