import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_bloc_builder/builders/multi_bloc_builder.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/core/constants.dart';
import 'package:social_media/domain/models/suggessions_model.dart';
import 'package:social_media/presentation/blocs/all_followers_posts_bloc/all_followers_posts_bloc.dart';
import 'package:social_media/presentation/blocs/fetch_followings_bloc/fetch_followings_bloc.dart';
import 'package:social_media/presentation/blocs/follow_unfollow_user_bloc/follow_unfollow_user_bloc.dart';
import 'package:social_media/presentation/blocs/suggessions_bloc/suggessions_bloc.dart';
import 'package:social_media/presentation/pages/followers_page/widgets/followers_loading.dart';
import 'package:social_media/presentation/pages/user_profile_page/user_profile_screen.dart';
import 'package:social_media/presentation/widgets/common_widgets.dart';

class SuggessionScreen extends StatefulWidget {
  const SuggessionScreen({super.key});

  @override
  State<SuggessionScreen> createState() => _SuggessionScreenState();
}

class _SuggessionScreenState extends State<SuggessionScreen> {
  List<UserDetailsModel> suggessionList = [];
  @override
  void initState() {
    context.read<SuggessionsBloc>().add(SuggessionUserInitialFetchEvent());
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
        title: appbarTitle(title: 'Suggessions'),
      ),
      body: MultiBlocBuilder(
        blocs: [
          context.watch<SuggessionsBloc>(),
          context.watch<FollowUnfollowUserBloc>()
        ],
        builder: (context, state) {
          if (state[1] is FollowUserSuccesfulState) {
            context
                .read<AllFollowersPostsBloc>()
                .add(AllFollowersPostsInitialFetchEvent());
            context
                .read<FetchFollowingsBloc>()
                .add(FollowingsInitialFetchEvent());
          }
          if (state[0] is SuggessionsSuccesfulState) {
            final SuggessionModel suggessionModel = state[0].suggessionModel;
            return suggessionModel.data.isEmpty
                ? const Center(
                    child: Text('No Suggessions !',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        )),
                  )
                : ListView.builder(
                    itemCount: suggessionModel.total,
                    itemBuilder: (context, index) {
                      suggessionList = suggessionModel.data;
                      final UserDetailsModel user = suggessionList[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: kWhite,
                              radius: 28,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(user.profilePic),
                                radius: 26,
                              ),
                            ),
                            kWidth10,
                            GestureDetector(
                              onTap: () {
                                customRoutePush(
                                    context,
                                    UserProfielScreen(
                                      userId: user.id,
                                      user: user,
                                    ));
                              },
                              child: Text(
                                user.userName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                context.read<FollowUnfollowUserBloc>().add(
                                    FollowUserButtonClickEvent(
                                        followeesId: user.id));
                                suggessionModel.data.removeWhere(
                                    (element) => element.id == user.id);
                                suggessionModel.total--;
                              },
                              child: Container(
                                height: 28,
                                width: 70,
                                decoration: const BoxDecoration(
                                    color: kBlue,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: const Center(
                                    child: Text(
                                  'Follow',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: kWhite),
                                )),
                              ),
                            )
                          ],
                        ),
                      );
                    });
          } else if (state[0] is SuggessionsLoadingState) {
            return followersLoading();
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
