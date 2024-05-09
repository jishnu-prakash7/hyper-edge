import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/core/constants.dart';

Shimmer commentsShimmerLoading() {
  return Shimmer.fromColors(
      direction: ShimmerDirection.ttb,
      highlightColor: Colors.grey.shade100,
      baseColor: Colors.grey.shade300,
      child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: kBlack,
                  ),
                  kWidth10,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: kWhite,
                          ),
                          height: 20,
                          width: MediaQuery.of(context).size.width,
                        ),
                        kheight10,
                        Container(
                          height: 10,
                          width: 100,
                          decoration:  BoxDecoration(
                            borderRadius:BorderRadius.circular(5),
                            color: kWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }));
}
