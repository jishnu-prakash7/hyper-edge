
  import 'package:flutter/material.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/core/constants.dart';
import 'package:social_media/domain/models/postuser_model.dart';
import 'package:social_media/presentation/pages/followers_page/followers_screen.dart';
import 'package:social_media/presentation/pages/following_page/following_screen.dart';
import 'package:social_media/presentation/pages/profile_edit_page/profile_edit_screen.dart';
import 'package:social_media/presentation/pages/profile_page/widgets/post_detailed_view_screen.dart';
import 'package:social_media/presentation/widgets/common_widgets.dart';

Positioned profileDetailsSection(BuildContext context,
      {String? bio,
      required String userName,
      required String followersCount,
      required String followingsCount,
      required String postCount,
      required User user}) {
    return Positioned(
      left: 20,
      top: 130,
      width: MediaQuery.of(context).size.width - 40,
      child: Container(
        decoration: BoxDecoration(borderRadius: kborderRadius5, color: kWhite),
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 180,
              top: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: kbackgroundColor,
                    shape:
                        RoundedRectangleBorder(borderRadius: kborderRadius5)),
                onPressed: () {
                  customRoutePush(
                      context,
                      ProfielEditScreen(
                        user: user,
                      ));
                },
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(color: kBlack, fontSize: 15),
                ),
              ),
            ),
            Positioned(
              left: 40,
              top: 65,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                    overflow: TextOverflow.fade,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 100,
                    child: Text(
                      maxLines: 1,
                      bio ?? '',
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
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      customRoutePush(
                          context,
                          const PostDetailedViewScreen(
                            initialIndex: 0,
                          ));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        followerSectionText(text: postCount),
                        followerSectionText(text: 'Posts'),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      customRoutePush(context, const FollowersScreen());
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        followerSectionText(text: followersCount),
                        followerSectionText(text: 'Followers'),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      customRoutePush(context, const FollowingScreen());
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        followerSectionText(text: followingsCount),
                        followerSectionText(text: 'Following'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

