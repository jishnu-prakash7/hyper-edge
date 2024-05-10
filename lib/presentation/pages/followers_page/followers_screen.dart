import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_bloc_builder/builders/multi_bloc_consumer.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/core/constants.dart';
import 'package:social_media/domain/models/followers_model.dart';
import 'package:social_media/presentation/blocs/conversation_bloc/conversation_bloc.dart';
import 'package:social_media/presentation/blocs/fetch_followers_bloc/fetch_followers_bloc.dart';
import 'package:social_media/presentation/pages/followers_page/widgets/followers_loading.dart';
import 'package:social_media/presentation/pages/user_profile_page/user_profile_screen.dart';
import 'package:social_media/presentation/widgets/common_widgets.dart';

class FollowersScreen extends StatefulWidget {
  const FollowersScreen({super.key});

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  @override
  void initState() {
    context.read<FetchFollowersBloc>().add(FollowersInitialFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const UnderlineInputBorder(
          borderSide: BorderSide(
            width: .5,
            color: Color.fromARGB(255, 196, 196, 196),
          ),
        ),
        backgroundColor: kbackgroundColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: appbarTitle(title: 'Followers'),
      ),
      body: MultiBlocConsumer(
        blocs: [
          context.watch<FetchFollowersBloc>(),
          context.watch<ConversationBloc>(),
        ],
        buildWhen: null,
        listener: (context, state) {},
        builder: (context, state) {
          if (state[0] is FetchFollowersSuccesfulState) {
            final FollowersModel followers = state[0].followersModel;
            return followers.followers.isEmpty
                ? const Center(
                    child: Text('No Followers !',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  )
                : ListView.builder(
                    itemCount: followers.totalCount,
                    itemBuilder: (context, index) {
                      final Follower follower = followers.followers[index];
                      return Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: GestureDetector(
                            onTap: () {
                              customRoutePush(
                                  context,
                                  UserProfielScreen(
                                      userId: follower.id, user: follower));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: kWhite,
                                    radius: 28,
                                    child: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(follower.profilePic),
                                      radius: 26,
                                    ),
                                  ),
                                  kWidth10,
                                  Text(
                                    follower.userName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
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
