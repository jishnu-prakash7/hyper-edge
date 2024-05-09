import 'package:flutter/material.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/core/constants.dart';
import 'package:social_media/presentation/pages/about_us_page/widgets.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kbackgroundColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              privacyPolicyMainHeading(title: 'About Us'),
              kheight10,
              contentText(text: '''Welcome to hyper edge – Your Creative Hub!

At hyper edge, we believe in the power of creativity and self-expression. We strive to provide a platform where individuals from all walks of life can connect, share, and inspire through visual storytelling. Our mission is to empower users to explore their passions, discover new interests, and foster meaningful connections with others around the globe.'''),
              kheight10,
              privacyPolicySecondHeading(title: 'Our Story'),
              kheight10,
              contentText(
                  text:
                      """hyper edge was born from a simple idea – to create a space where users can unleash their creativity and share their unique perspectives with the world. Founded by a team of passionate creators, hyper edge has evolved into a vibrant community of artists, photographers, influencers, and everyday enthusiasts who come together to celebrate the beauty of life through captivating visuals.

"""),
              kheight10,
              privacyPolicySecondHeading(title: 'Our Vision'),
              kheight10,
              contentText(
                  text:
                      """At hyper edge, we envision a world where every moment is an opportunity for expression. Whether you're an aspiring photographer, a seasoned influencer, or someone who simply loves to share moments with friends and family, hyper edge is your canvas to paint the world with your creativity. We aspire to be more than just a social media platform – we aim to be a catalyst for inspiration, connection, and positive change."""),
              kheight10,
              privacyPolicySecondHeading(title: 'Join hyper edge Today!'),
              kheight10,
              contentText(
                  text:
                      """Join our community of creators and storytellers today! Download hyper edge from the App Store or Google Play Store and embark on a journey of creativity, inspiration, and connection. We can't wait to see what you'll create!""")
            ],
          ),
        ),
      ),
    );
  }
}
