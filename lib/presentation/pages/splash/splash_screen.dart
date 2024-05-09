import 'package:flutter/material.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/presentation/widgets/common_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkUserLoggedIn(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kWhite,
      body: Center(
        child: Text(
          'h.',
          style: TextStyle(
              fontSize: 40, fontWeight: FontWeight.bold, color: kBlack),
        ),
      ),
    );
  }
}
