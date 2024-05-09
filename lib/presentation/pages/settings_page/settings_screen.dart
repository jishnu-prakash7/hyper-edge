import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/core/constants.dart';
import 'package:social_media/data/socket/socket.dart';
import 'package:social_media/presentation/pages/about_us_page/about_us_screen.dart';
import 'package:social_media/presentation/pages/login_page/login_screen.dart';
import 'package:social_media/presentation/pages/main_page/main_page.dart';
import 'package:social_media/presentation/pages/privacy_policy_page/privacy_policy_screen.dart';
import 'package:social_media/presentation/pages/terms_and_conditions_page/terms_and_conditions_screen.dart';
import 'package:social_media/presentation/widgets/common_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
              customRoutePushAndRemovieUntil(context, const MainPage());
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: appbarTitle(title: 'Settings'),
      ),
      body: Column(
        children: [
          kheight10,
          settingsListTile(context,
              title: 'About Us', icon: Iconsax.info_circle, onpressed: () {
            customRoutePush(context, const AboutUsScreen());
          }),
          settingsListTile(context,
              title: 'Privacy & Policy',
              icon: Iconsax.document_1, onpressed: () {
            customRoutePush(context, const PrivacyPolicyScreen());
          }),
          settingsListTile(context,
              title: 'Terms & Conditions',
              icon: Iconsax.message_question, onpressed: () {
            customRoutePush(context, const TermsAndConditionsScreen());
          }),
          settingsListTile(context,
              title: 'Logout',
              icon: Iconsax.logout_1,
              textColor: kRed, onpressed: () {
            confirmationDialog(context,
                agreeColor: kRed,
                title: 'Logout',
                content: 'Are you sure want to logout ?', onpressed: () {
              indexChangeNotifier.value = 0;
              SocketService().disconnectSocket();
              // logoutUser();
              customRoutePushAndRemovieUntil(context, const LoginScreen());
            });
          }),
          const Spacer(),
          Text(
            'Version 1.1.0',
            style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600),
          ),
          kheight40
        ],
      ),
    );
  }
}
