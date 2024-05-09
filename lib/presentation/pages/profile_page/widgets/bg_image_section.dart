import 'package:flutter/material.dart';
import 'package:social_media/core/colors.dart';

Container backgroundImageSection(BuildContext context,
    {required String image}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 330,
    color: kbackgroundColor,
    child: Stack(
      children: [
        Image.network(
          image,
          height: 220,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        const Positioned(
          top: (330 - 220) / 2,
          left: 0,
          right: 0,
          child: SizedBox(height: 220),
        ),
      ],
    ),
  );
}
