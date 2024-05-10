
import 'package:flutter/material.dart';
import 'package:social_media/domain/models/get_all_messages_model.dart';
import 'package:social_media/presentation/pages/home_page/home_screen.dart';
import 'package:social_media/presentation/pages/message_page/widgets/own_message_card.dart';
import 'package:social_media/presentation/pages/message_page/widgets/replay_card.dart';

Widget getMessageCard(AllMessagesModel message) {
  if (message.senderId == logginedUserId) {
    return OwnMessageCard(
      message: message.text.trim(),
      time: message.createdAt,
    );
  } else {
    return ReplayCard(
      message: message.text.trim(),
      time: message.updatedAt,
    );
  }
}