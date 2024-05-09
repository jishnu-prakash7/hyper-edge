// ignore_for_file: use_build_context_synchronously

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:multi_bloc_builder/builders/multi_bloc_builder.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/domain/models/fetch_conversation_model.dart';
import 'package:social_media/domain/models/get_user_model.dart';
import 'package:social_media/presentation/blocs/add_message/add_message_bloc.dart';
import 'package:social_media/presentation/blocs/fetch_all_conversations_bloc.dart/fetch_all_conversations_bloc.dart';
import 'package:social_media/presentation/pages/message_page/chat_screen.dart';
import 'package:social_media/presentation/pages/message_page/widgets/custom_card.dart';
import 'package:social_media/presentation/pages/message_page/widgets/message_screen_loading.dart';
import 'package:social_media/presentation/pages/new_chat_page/new_chat_screen.dart';
import 'package:social_media/presentation/widgets/common_widgets.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  List<ConversationModel> conversations = [];
  List<GetUserModel> users = [];
  List<GetUserModel> filteredUsers = [];
  String? onchanged;

  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context
        .read<FetchAllConversationsBloc>()
        .add(AllConversationsInitialFetchEvent());
  }

  Future<void> refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    context
        .read<FetchAllConversationsBloc>()
        .add(AllConversationsInitialFetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kbackgroundColor,
        title: appbarTitle(title: 'Messages', fontWeight: FontWeight.w600),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 20,
            child: SearchBar(
              backgroundColor: const MaterialStatePropertyAll(kWhite),
              leading: const Icon(Icons.search),
              onChanged: (value) {
                onchanged = value;
                setState(() {});
              },
              controller: searchController,
              hintText: 'Search...',
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kWhite,
        onPressed: () {
          customRoutePush(context, const NewChatScreen());
        },
        child: const Icon(
          Iconsax.message_add_15,
          size: 30,
        ),
      ),
      body: CustomMaterialIndicator(
        indicatorBuilder: (context, controller) {
          return LoadingAnimationWidget.inkDrop(
            color: kBlack,
            size: 30,
          );
        },
        onRefresh: refresh,
        child: MultiBlocBuilder(
          blocs: [
            context.watch<FetchAllConversationsBloc>(),
            context.watch<AddMessageBloc>(),
          ],
          builder: (context, state) {
            var state1 = state[0];
            if (state1 is FetchAllConversationsLoadingState) {
              return Center(
                child: messageScreenShimmerLoading(),
              );
            } else if (state1 is FetchAllConversationsSuccesfulState) {
              conversations = state1.conversations;
              users = state1.otherUsers;
              filteredUsers = state1.otherUsers
                  .where(
                      (element) => element.userName.contains(onchanged ?? ''))
                  .toList();
              return filteredUsers.isEmpty
                  ? const Center(
                      child: Text('No chat found !'),
                    )
                  : ListView.builder(
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        final ConversationModel conversation =
                            conversations[index];
                        final user = filteredUsers[index];
                        return GestureDetector(
                          onTap: () {
                            customRoutePush(
                                context,
                                ChatScreen(
                                  recieverid: user.id,
                                  name: user.userName,
                                  profilepic: user.profilePic,
                                  conversationId: conversation.id,
                                ));
                          },
                          child: CustomCard(
                            user: user,
                            conversation: conversation,
                          ),
                        );
                      });
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
