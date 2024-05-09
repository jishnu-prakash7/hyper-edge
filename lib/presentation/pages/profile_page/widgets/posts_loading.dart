import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/core/constants.dart';

Shimmer postsShimmerLoading() {
  return Shimmer.fromColors(
    highlightColor: Colors.grey.shade100,
    baseColor: Colors.grey.shade300,
    child: GridView.builder(
      padding: const EdgeInsets.all(5),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: kborderRadius10,
            color: kWhite,
          ),
          margin: const EdgeInsets.all(5),
        );
      },
    ),
  );
}
