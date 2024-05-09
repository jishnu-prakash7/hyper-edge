import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/core/constants.dart';

Shimmer explorePageLoading() {
  return Shimmer.fromColors(
    highlightColor: Colors.grey.shade100,
    baseColor: Colors.grey.shade300,
    child: ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: kWhite,
                radius: 28,
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: kTeal,
                ),
              ),
              kWidth10,
              Container(
                height: 20,
                width: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), color: kWhite),
              ),
              const Spacer(),
              Container(
                height: 28,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), color: kWhite),
              )
            ],
          ),
        );
      },
    ),
  );
}
