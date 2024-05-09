import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

Shimmer explorePostShimmerLoading() {
  return Shimmer.fromColors(
      direction: ShimmerDirection.ttb,
      highlightColor: Colors.grey.shade100,
      baseColor: Colors.grey.shade300,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MasonryGridView.builder(
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemCount: 6,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                  'https://i.pinimg.com/564x/d2/4f/2b/d24f2b8bc53d9dd7086c80888ee86734.jpg'),
            ),
          ),
        ),
      ));
}
