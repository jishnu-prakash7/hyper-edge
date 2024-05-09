import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/presentation/blocs/add_message/add_message_bloc.dart';
import 'package:social_media/presentation/blocs/add_post_bloc/add_post_bloc.dart';
import 'package:social_media/presentation/blocs/all_followers_posts_bloc/all_followers_posts_bloc.dart';
import 'package:social_media/presentation/blocs/comment_post_bloc/comment_post_bloc.dart';
import 'package:social_media/presentation/blocs/conversation_bloc/conversation_bloc.dart';
import 'package:social_media/presentation/blocs/delete_comment_bloc/delete_comment_bloc.dart';
import 'package:social_media/presentation/blocs/delete_post_bloc/delete_post_bloc.dart';
import 'package:social_media/presentation/blocs/edit_post_bloc/edit_post_bloc.dart';
import 'package:social_media/presentation/blocs/fetch_all_conversations_bloc.dart/fetch_all_conversations_bloc.dart';
import 'package:social_media/presentation/blocs/fetch_explore_post_bloc/fetch_explore_post_bloc.dart';
import 'package:social_media/presentation/blocs/fetch_followers_bloc/fetch_followers_bloc.dart';
import 'package:social_media/presentation/blocs/fetch_followings_bloc/fetch_followings_bloc.dart';
import 'package:social_media/presentation/blocs/fetch_saved_posts/fetch_saved_posts_bloc.dart';
import 'package:social_media/presentation/blocs/follow_unfollow_user_bloc/follow_unfollow_user_bloc.dart';
import 'package:social_media/presentation/blocs/get_comments_bloc/get_comments_bloc.dart';
import 'package:social_media/presentation/blocs/get_connections_bloc/get_connections_bloc.dart';
import 'package:social_media/presentation/blocs/loggined_user_post_bloc/loggined_user_post_bloc.dart';
import 'package:social_media/presentation/blocs/image_picker_bloc/image_picker_bloc.dart';
import 'package:social_media/presentation/blocs/like_unlike_post_bloc/like_post_bloc.dart';
import 'package:social_media/presentation/blocs/login_bloc/bloc/login_bloc.dart';
import 'package:social_media/presentation/blocs/otp_bloc/bloc/otp_bloc.dart';
import 'package:social_media/presentation/blocs/profile_details_bloc/profile_details_bloc.dart';
import 'package:social_media/presentation/blocs/profile_edit_bloc/profile_edit_bloc.dart';
import 'package:social_media/presentation/blocs/profile_posts_bloc/profile_bloc.dart';
import 'package:social_media/presentation/blocs/saved_post_bloc/saved_post_bloc.dart';
import 'package:social_media/presentation/blocs/search_all_users_bloc/search_all_users_bloc.dart';
import 'package:social_media/presentation/blocs/signup_bloc/bloc/signup_bloc.dart';
import 'package:social_media/presentation/blocs/suggessions_bloc/suggessions_bloc.dart';
import 'package:social_media/presentation/pages/splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SignupBloc()),
        BlocProvider(create: (context) => OtpBloc()),
        BlocProvider(create: (context) => LoginBloc()),
        BlocProvider(create: (context) => AddPostBloc()),
        BlocProvider(create: (context) => LogginedUserPostBloc()),
        BlocProvider(create: (context) => ProfileBloc()),
        BlocProvider(create: (context) => EditPostBloc()),
        BlocProvider(create: (context) => DeletePostBloc()),
        BlocProvider(create: (context) => ImagePickerBloc()),
        BlocProvider(create: (context) => ProfileDetailsBloc()),
        BlocProvider(create: (context) => ProfileEditBloc()),
        BlocProvider(create: (context) => LikePostBloc()),
        BlocProvider(create: (context) => GetCommentsBloc()),
        BlocProvider(create: (context) => CommentPostBloc()),
        BlocProvider(create: (context) => DeleteCommentBloc()),
        BlocProvider(create: (context) => AllFollowersPostsBloc()),
        BlocProvider(create: (context) => FetchFollowersBloc()),
        BlocProvider(create: (context) => FetchFollowingsBloc()),
        BlocProvider(create: (context) => FollowUnfollowUserBloc()),
        BlocProvider(create: (context) => SuggessionsBloc()),
        BlocProvider(create: (context) => SavedPostBloc()),
        BlocProvider(create: (context) => FetchSavedPostsBloc()),
        BlocProvider(create: (context) => FetchExplorePostBloc()),
        BlocProvider(create: (context) => FetchAllConversationsBloc()),
        BlocProvider(create: (context) => ConversationBloc()),
        BlocProvider(create: (context) => AddMessageBloc()),
        BlocProvider(create: (context) => GetConnectionsBloc()),
        BlocProvider(create: (context) => SearchAllUsersBloc())
      ],
      child: MaterialApp(
          navigatorKey: NavigationService.navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: kbackgroundColor,
            fontFamily: 'Quicksand',
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromRGBO(103, 58, 183, 1)),
            useMaterial3: true,
          ),
          home: const SplashScreen()),
    );
  }
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
