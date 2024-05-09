class ApiEndpoints {
  //BaseUrl
  static const String baseUrl = 'https://hyperedge.online/api';

  //user Urls
  static const String signUp = '/users/send-otp';
  static const String login = '/users/login';
  static const String verifyOtp = '/users/verify-otp';
  static const String logginedUser = '/users/getuser';
  static const String editProfile = '/users/edit-profile';
  static const String getFollowing = '/users/fetch-following';
  static const String getFollowers = '/users/fetch-followers';
  static const String followUser = '/users/follow';
  static const String unfollowUser = '/users/unfollow';
  static const String suggessions = '/users/fetch-users';
  static const String getSingleUser = '/users/get-single-user';
  static const String getConnections = '/users/get-count';
  static const String searchAllUsers = '/users/searchallusers?searchQuery=';

//post Urls
  static const String addpostUrl = '/posts/addPost';
  static const String getallPost = '/posts/getpost';
  static const String deletePost = '/posts/delete-post';
  static const String updatePost = '/posts/update-post';
  static const String getPostByUserId = '/posts/getuserpost';
  static const String likePost = '/posts/like-post';
  static const String unlikePost = '/posts/unlike-post';
  static const String commentPost = '/posts/add-comment';
  static const String getAllComments = '/posts/fetch-comments';
  static const String deleteComments = '/posts/delete-comment';
  static const String replayComments = '/posts/comments/reply-to';
  static const String allFollowingsPost = '/posts/allfollowingsPost';
  static const String savePost = '/posts/savePost';
  static const String fetchSavedPost = '/posts/savePosts';
  static const String removeSavedPost = '/posts/savePosts';
  static const String explorePosts = '/posts/exploreposts';

//chat urls
  static const String createConversation = '/chats/conversation';
  static const String getAllConversations = '/chats/conversation';
  static const String addMessage = '/chats/message';
  static const String getAllMessages = '/chats/message';
}
