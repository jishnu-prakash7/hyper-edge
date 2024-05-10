import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/core/constants.dart';
import 'package:social_media/domain/models/fetch_explore_post_model.dart';
import 'package:social_media/presentation/blocs/fetch_explore_post_bloc/fetch_explore_post_bloc.dart';
import 'package:social_media/presentation/blocs/search_all_users_bloc/search_all_users_bloc.dart';
import 'package:social_media/presentation/pages/explore_page/widgets/explore_page_list_view_shimmer.dart';
import 'package:social_media/presentation/pages/explore_page/widgets/explore_post_detailed_view.dart';
import 'package:social_media/presentation/pages/explore_page/widgets/search_bar.dart';
import 'package:social_media/presentation/pages/user_profile_page/user_profile_screen.dart';
import 'package:social_media/presentation/widgets/common_widgets.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  TextEditingController searchController = TextEditingController(text: '');
  final _debouncer = Debouncer(milliseconds: 700);
  String onchangevalue = '';

  @override
  void initState() {
    context.read<FetchExplorePostBloc>().add(ExplorePostInitialFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kbackgroundColor,
        elevation: 0,
        title: appbarTitle(title: 'Explore'),
        iconTheme:
            const IconThemeData(color: Color.fromARGB(255, 233, 230, 230)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 480),
              width: MediaQuery.of(context).size.width - 30,
              child: Searchbar(
                searchController: searchController,
                onTextChanged: (String value) {
                  // context
                  //     .read<FetchExplorePostBloc>()
                  //     .add((ExplorePostInitialFetchEvent()));
                  setState(() {
                    onchangevalue = value;
                  });
                  if (value.isNotEmpty) {
                    _debouncer.run(() {
                      context
                          .read<SearchAllUsersBloc>()
                          .add(SearchUserInitilEvent(query: value));
                    });
                  }
                },
              ),
            ),
          ),
        ),
      ),
      body: BlocConsumer<FetchExplorePostBloc, FetchExplorePostState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is FetchExplorePostSuccesfulState) {
            if (onchangevalue.isEmpty) {
              return Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MasonryGridView.builder(
                        gridDelegate:
                            const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemCount: state.posts.length,
                        itemBuilder: (context, index) {
                          final ExplorePostModel post = state.posts[index];
                          return Center(
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 500),
                              child: GestureDetector(
                                onTap: () {
                                  customRoutePush(
                                      context,
                                      ExplorePostDetailedViewScreen(
                                          initialIndex: index));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(post.image),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              );
            } else {
              return BlocBuilder<SearchAllUsersBloc, SearchAllUsersState>(
                builder: (context, state) {
                  if (state is SearchAllUsersSuccesfulState) {
                    return state.users.isEmpty
                        ? const Center(
                            child: Text(
                              'No User Found !',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          )
                        : ListView.builder(
                            itemCount: state.users.length,
                            itemBuilder: (context, index) {
                              final user = state.users[index];
                              return Center(
                                child: Container(
                                  constraints:
                                      const BoxConstraints(maxWidth: 500),
                                  child: GestureDetector(
                                    onTap: () {
                                      customRoutePush(
                                          context,
                                          UserProfielScreen(
                                              userId: user.id, user: user));
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
                                                  NetworkImage(user.profilePic),
                                              radius: 26,
                                            ),
                                          ),
                                          kWidth10,
                                          Text(
                                            user.userName,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                  } else if (state is SearchAllUsersLoadingState) {
                    return explorePageLoading();
                  } else {
                    return Center(
                        child: LoadingAnimationWidget.discreteCircle(
                      color: kBlack,
                      size: 40,
                    ));
                  }
                },
              );
            }
          } else if (state is FetchExplorePostLoadingState) {
            return explorePageLoading();
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;
  Debouncer({required this.milliseconds});
  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
