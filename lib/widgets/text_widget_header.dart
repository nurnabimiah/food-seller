import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodfair_seller_app/widgets/container_decoration.dart';

class TextWidgetHeader extends SliverPersistentHeaderDelegate {
  String? title;
  TextWidgetHeader({this.title});
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return InkWell(
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.10,
        alignment: Alignment.center,
        decoration: ContainerDecoration().decoaration(),
        child: InkWell(
          child: Text(
            title!,
            maxLines: 2,
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 50;
  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
