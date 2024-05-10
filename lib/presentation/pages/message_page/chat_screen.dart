import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/data/socket/socket.dart';
import 'package:social_media/domain/models/get_all_messages_model.dart';
import 'package:social_media/presentation/blocs/add_message/add_message_bloc.dart';
import 'package:social_media/presentation/blocs/conversation_bloc/conversation_bloc.dart';
import 'package:social_media/presentation/pages/home_page/home_screen.dart';
import 'package:social_media/presentation/pages/message_page/widgets/chat_cards.dart';
import 'package:social_media/presentation/pages/message_page/widgets/date_in_chat.dart';

class ChatScreen extends StatefulWidget {
  final String conversationId;
  final String recieverid;
  final String name;
  final String profilepic;
  const ChatScreen(
      {super.key,
      required this.recieverid,
      required this.name,
      required this.profilepic,
      required this.conversationId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void initState() {
    context.read<ConversationBloc>().add(
          GetAllMessagesInitialFetchEvent(
            conversationId: widget.conversationId,
          ),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_ios_new_rounded)),
            CircleAvatar(
              radius: 21,
              backgroundImage: NetworkImage(widget.profilepic),
            )
          ],
        ),
        title: Text(widget.name,
            style:
                const TextStyle(fontSize: 18.5, fontWeight: FontWeight.bold)),
      ),
      body: Form(
        key: _formkey,
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                  child: BlocConsumer<ConversationBloc, ConversationState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state is GetAllMessagesLoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is GetAllMessagesSuccesfulState) {
                        List<DateTime> dates = [];
                        List<List<AllMessagesModel>> messagesByDate = [];
                        for (var message in state.messagesList) {
                          DateTime date = DateTime(message.createdAt.year,
                              message.createdAt.month, message.createdAt.day);
                          if (!dates.contains(date)) {
                            dates.add(date);
                            messagesByDate.add([message]);
                          } else {
                            messagesByDate.last.add(message);
                          }
                        }
                        dates = dates.reversed.toList();
                        messagesByDate = messagesByDate.reversed.toList();
                        return ListView.builder(
                          controller: scrollController,
                          itemCount: dates.length,
                          reverse: true,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                DateDivider(date: dates[index]),
                                ...messagesByDate[index]
                                    .map((message) => getMessageCard(message)),
                              ],
                            );
                          },
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
                Row(
                  children: [
                    Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 440),
                        width: MediaQuery.of(context).size.width - 55,
                        child: Card(
                          margin: const EdgeInsets.only(
                              left: 2, right: 2, bottom: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          child: TextFormField(
                            controller: _messageController,
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            minLines: 1,
                            decoration: const InputDecoration(
                                prefix: SizedBox(
                                  width: 10,
                                ),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                hintText: 'Type a message...',
                                contentPadding: EdgeInsets.all(5)),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_messageController.text.isNotEmpty) {
                          SocketService().sendMessgage(_messageController.text,
                              widget.recieverid, logginedUserId);
                          final message = AllMessagesModel(
                              id: '',
                              senderId: logginedUserId,
                              recieverId: widget.recieverid,
                              conversationId: widget.conversationId,
                              text: _messageController.text,
                              isRead: false,
                              deleteType: '',
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now(),
                              v: 0);
                          BlocProvider.of<ConversationBloc>(context)
                              .add(AddNewMessageEvent(message: message));
                          context.read<AddMessageBloc>().add(
                              AddMessageButtonClickEvent(
                                  message: _messageController.text,
                                  senderId: logginedUserId,
                                  recieverId: widget.recieverid,
                                  conversationId: widget.conversationId));
                          _messageController.clear();
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(bottom: 8, right: 2),
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 25,
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
