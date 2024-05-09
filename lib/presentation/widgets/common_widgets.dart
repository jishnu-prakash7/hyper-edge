// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/core/constants.dart';
import 'package:social_media/domain/models/post_model.dart';
import 'package:social_media/presentation/pages/login_page/login_screen.dart';
import 'package:social_media/presentation/pages/main_page/main_page.dart';
import 'package:toggle_switch/toggle_switch.dart';

//custom Route PushReplacement
customRoutePushReplacement(context, pagetoNavigate) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) {
      return pagetoNavigate;
    }),
  );
}

//custom Route Push
customRoutePush(context, pagetoNavigate) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) {
      return pagetoNavigate;
    }),
  );
}

//custom Route PushAndRemovieUntil
customRoutePushAndRemovieUntil(context, pagetoNavigate) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => pagetoNavigate),
      (route) => false);
}

//custom IconButton
IconButton customIconButton(
    {required IconData icon,
    required Color color,
    required VoidCallback onpressed}) {
  return IconButton(
    onPressed: onpressed,
    icon: Icon(
      icon,
      color: color,
      size: 28,
    ),
  );
}

//custom SnackBar
void customSnackBar(BuildContext context, String text, Color color) {
  SnackBar snackBar = SnackBar(
    content: Text(
      text,
      style: const TextStyle(color: kWhite),
    ),
    backgroundColor: color,
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

//Password RegEx
RegExp get passwordValidator => RegExp(
      r'^[a-zA-Z0-9!@#$%^&*(),.?":{}|<>_-]+$',
    );

//Email RegEx
RegExp get emailValidator => RegExp(r'^\S+@gmail\.com$');

//Phone no RegEx
RegExp get phoneNumberValidator => RegExp(r'^[0-9]{10}$');

//Name RegEx
RegExp get nameValidator => RegExp(r'^.{4,}$');

//edit profile Regx
RegExp get profileValidator => RegExp(r'^(?=.*[a-zA-Z0-9]).*$');

//Post Description regx
RegExp get descriptionValidator => RegExp(r'.*[a-zA-Z].*');

//custom ElevatedButton
ElevatedButton customElevatedButton(BuildContext context,
    {required Color backgroundColor,
    required Color textColor,
    required String title,
    required VoidCallback onpressed}) {
  return ElevatedButton(
    onPressed: onpressed,
    style: ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(backgroundColor),
      shape: MaterialStateProperty.all(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      minimumSize: MaterialStateProperty.all(
          Size(MediaQuery.of(context).size.width - 20, 50)),
    ),
    child: Text(
      title,
      style: TextStyle(color: textColor, fontSize: 17),
    ),
  );
}

//custom TextFormField
SizedBox customTextFormField(
    {required BuildContext context,
    required String labeltext,
    required TextEditingController controller,
    required String fieldEmptyMessage,
    required String validationMessage,
    required RegExp regEx,
    int? maxlines}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width - 20,
    child: TextFormField(
      textCapitalization: TextCapitalization.sentences,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return fieldEmptyMessage;
        }
        if (!regEx.hasMatch(value)) {
          return validationMessage;
        } else {
          return null;
        }
      },
      controller: controller,
      maxLines: maxlines ?? 1,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
            borderSide: BorderSide(width: .5),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        labelText: labeltext,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 102, 102, 102)),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: .6),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: .6),
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
    ),
  );
}

//ath bottom text already have account
Padding authBottomText(BuildContext context,
    {required String text1,
    required String text2,
    required VoidCallback onTap}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: RichText(
      text: TextSpan(children: [
        TextSpan(
          text: text1,
          style: const TextStyle(
              color: kBlack,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w500,
              fontSize: 15),
        ),
        TextSpan(
          text: text2,
          style: const TextStyle(
              color: Colors.blue,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w500,
              fontSize: 15),
          recognizer: TapGestureRecognizer()..onTap = onTap,
        ),
      ]),
    ),
  );
}

//Appbar title
Text appbarTitle(
    {required String title, double? fontSize, FontWeight? fontWeight}) {
  return Text(
    title,
    style: TextStyle(
        fontSize: fontSize ?? 20, fontWeight: fontWeight ?? FontWeight.w500),
  );
}

// App main title
Text mainTitle() {
  return const Text(
    'Lumie',
    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
  );
}

//Toggle Switch

ToggleSwitch toggleSwith() {
  return ToggleSwitch(
    minHeight: 20,
    minWidth: 20,
    cornerRadius: 20.0,
    activeBgColors: const [
      [Color.fromARGB(255, 224, 224, 224)],
      [kBlack]
    ],
    activeFgColor: Colors.white,
    inactiveBgColor: Colors.grey,
    inactiveFgColor: Colors.white,
    initialLabelIndex: 1,
    totalSwitches: 2,
    radiusStyle: true,
    onToggle: (index) {},
  );
}

//settings list tile
Padding settingsListTile(BuildContext context,
    {required String title,
    Color? textColor,
    required IconData icon,
    required VoidCallback onpressed}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kWhite,
      ),
      child: GestureDetector(
        onTap: () => onpressed,
        child: ListTile(
          leading: Icon(icon),
          title: Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w500, color: textColor ?? kBlack),
          ),
          trailing: IconButton(
              onPressed: onpressed,
              icon: const Icon(Icons.arrow_forward_ios_rounded)),
        ),
      ),
    ),
  );
}

//checking user already logged in
Future<void> checkUserLoggedIn(BuildContext context) async {
  final sharedpreference = await SharedPreferences.getInstance();
  final user = sharedpreference.getBool(authKey);
  if (user == null || user == false) {
    await Future.delayed(const Duration(seconds: 2));
    customRoutePushAndRemovieUntil(context, const LoginScreen());
  } else {
    // SocketService().connectSocket(context: context);
    await Future.delayed(const Duration(seconds: 2));
    customRoutePushAndRemovieUntil(context, const MainPage());
  }
}

//user logout
void logoutUser() async {
  final sharedpreference = await SharedPreferences.getInstance();
  sharedpreference.clear();
}

//alert dialog
void confirmationDialog(BuildContext context,
    {required String title,
    required String content,
    Color? agreeColor,
    required VoidCallback onpressed}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: kWhite,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        content: Text(content,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
        actions: <Widget>[
          TextButton(
            child: const Text('No',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16, color: kBlack)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            onPressed: onpressed,
            child: Text('Yes',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: agreeColor ?? kBlack)),
          )
        ],
      );
    },
  );
}

//Store user to sharedpreference
Future<void> setUserLoggedin(
    {required String token,
    required String userid,
    required String userrole,
    required String userEmail,
    required String userName,
    required String userprofile}) async {
  final sharedprefs = await SharedPreferences.getInstance();
  await sharedprefs.setBool(authKey, true);
  await sharedprefs.setString(tokenKey, token);
  await sharedprefs.setString(userIdKey, userid);
  await sharedprefs.setString(userRolekey, userrole);
  await sharedprefs.setString(userEmailkey, userEmail);
  await sharedprefs.setString(userNamekey, userName);
  await sharedprefs.setString(userProfilePickey, userprofile);
}

//Profile and add post textformfield
SizedBox profileAndAddPostTextfield(
    {double height = 60,
    required String labelText,
    required TextEditingController controller,
    required String fieldEmptyMessage,
    required String validationMessage,
    RegExp? regEx}) {
  return SizedBox(
    height: height,
    child: TextFormField(
      textCapitalization: TextCapitalization.sentences,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return fieldEmptyMessage;
        }
        if (!regEx!.hasMatch(value)) {
          return validationMessage;
        } else {
          return null;
        }
      },
      controller: controller,
      maxLines: 15,
      decoration: InputDecoration(
        fillColor: kbackgroundColor,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        labelText: labelText,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 102, 102, 102)),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: .5),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: .5, color: kRed),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: .7),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    ),
  );
}

//get Usertoken
Future<String?> getUsertoken() async {
  final sharedpreference = await SharedPreferences.getInstance();
  final token = sharedpreference.getString(tokenKey);
  return token;
}

//get Userid
Future<String?> getUserId() async {
  final sharedpreference = await SharedPreferences.getInstance();
  final userId = sharedpreference.getString(userIdKey);
  return userId;
}

//parse posts from fetchposts
List<Post> parsePosts(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Post>((json) => Post.fromJson(json)).toList();
}

// Future<User?> getLoggedInUser() async {
//   final sharedPrefs = await SharedPreferences.getInstance();
//   if (sharedPrefs.containsKey(authKey) && sharedPrefs.getBool(authKey)!) {
//     return User(
//       role: sharedPrefs.getString(userRolekey) ?? '',
//       id: sharedPrefs.getString(userIdKey) ?? '',
//       userName: sharedPrefs.getString(userNamekey) ?? '',
//       email: sharedPrefs.getString(userEmailkey) ?? '',
//       profilePic: sharedPrefs.getString(userProfilePickey) ?? '',
//     );
//   } else {
//     return null;
//   }
// }

//Loading eleveted button

Container loadingElevatedButton(BuildContext context) {
  return Container(
    decoration: const BoxDecoration(
      color: kBlack,
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    height: 50,
    width: MediaQuery.of(context).size.width - 20,
    child: Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
      color: kWhite,
      size: 40,
    )),
  );
}

//Image picker
Future<File> pickImage() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  return File(pickedFile!.path);
}

//followers section text

Text followerSectionText({required String text}) {
  return Text(
    text,
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  );
}
