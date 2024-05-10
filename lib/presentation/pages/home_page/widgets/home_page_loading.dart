import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/core/constants.dart';

Shimmer homepageloading() {
  return Shimmer.fromColors(
    highlightColor: Colors.grey.shade100,
    baseColor: Colors.grey.shade300,
    child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              height: 450,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  kheight20,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                        ),
                        kWidth10,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: kWhite,
                              ),
                              height: 15,
                              width: 300,
                            ),
                            kheight10,
                            Container(
                              height: 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: kWhite,
                              ),
                              width: 200,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  kheight10,
                  Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    color: kWhite,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 20,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: kWhite,
                          ),
                        ),
                        kheight10,
                        Container(
                          width: 300,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: kWhite,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }),
  );
}
