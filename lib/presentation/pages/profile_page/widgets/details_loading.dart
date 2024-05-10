import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/core/constants.dart';

Shimmer detailsShimmerLoading(BuildContext context) {
  return Shimmer.fromColors(
      highlightColor: Colors.grey.shade100,
      baseColor: Colors.grey.shade300,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          margin: const EdgeInsets.only(bottom: 110),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 220,
              ),
              Positioned(
                left: 20,
                top: 130,
                width: MediaQuery.of(context).size.width - 40,
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: kborderRadius5, color: kWhite),
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                ),
              ),
              const Positioned(
                left: 40,
                top: 60,
                child: CircleAvatar(
                  radius: 68,
                  backgroundColor: kWhite,
                  child: CircleAvatar(
                    radius: 65,
                    backgroundColor: kWhite,
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
}
