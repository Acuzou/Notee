// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:clickable_list_wheel_view/clickable_list_wheel_widget.dart';

class ListWheelScrollViewX extends StatelessWidget {
  final Axis scrollDirection;
  final List<Widget> children;
  final ScrollController controller;
  final ScrollPhysics physics;
  final double diameterRatio;
  final double perspective;
  final double offAxisFraction;
  final bool useMagnifier;
  final double magnification;
  final double overAndUnderCenterOpacity;
  final double itemExtent;
  final double squeeze;
  final ValueChanged<int> onSelectedItemChanged;
  final bool renderChildrenOutsideViewport;
  final ListWheelChildDelegate childDelegate;
  final Clip clipBehavior;
  final int childCount;

  final void Function(int index) onTap;

  const ListWheelScrollViewX({
    Key key,
    this.scrollDirection = Axis.vertical,
    this.controller,
    this.physics,
    this.diameterRatio = RenderListWheelViewport.defaultDiameterRatio,
    this.perspective = RenderListWheelViewport.defaultPerspective,
    this.offAxisFraction = 0.0,
    this.useMagnifier = false,
    this.magnification = 1.0,
    this.overAndUnderCenterOpacity = 1.0,
    @required this.itemExtent,
    this.squeeze = 1.0,
    this.onSelectedItemChanged,
    this.renderChildrenOutsideViewport = false,
    this.clipBehavior = Clip.hardEdge,
    this.onTap,
    this.childCount = 0, //Ne compte pas ici
    @required this.children,
  })  : childDelegate = null,
        super(key: key);

  const ListWheelScrollViewX.useDelegate({
    Key key,
    this.scrollDirection = Axis.vertical,
    this.controller,
    this.physics,
    this.diameterRatio = RenderListWheelViewport.defaultDiameterRatio,
    this.perspective = RenderListWheelViewport.defaultPerspective,
    this.offAxisFraction = 0.0,
    this.useMagnifier = false,
    this.magnification = 1.0,
    this.overAndUnderCenterOpacity = 1.0,
    @required this.itemExtent,
    this.squeeze = 1.0,
    this.onSelectedItemChanged,
    this.renderChildrenOutsideViewport = false,
    this.clipBehavior = Clip.hardEdge,
    this.onTap,
    @required this.childCount,
    @required this.childDelegate,
  })  : children = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final childDelegateBuilder = children != null
        ? ListWheelChildListDelegate(
            children: children.map((child) {
            return RotatedBox(
              quarterTurns: scrollDirection == Axis.horizontal ? 1 : 0,
              child: child,
            );
          }).toList())
        : ListWheelChildBuilderDelegate(
            childCount: childCount,
            builder: (context, index) {
              return RotatedBox(
                quarterTurns: scrollDirection == Axis.horizontal ? 1 : 0,
                child: childDelegate.build(context, index),
              );
            },
          );

    return RotatedBox(
      quarterTurns: scrollDirection == Axis.horizontal ? 3 : 0,
      child: ClickableListWheelScrollView(
        scrollController: controller,
        itemHeight: itemExtent,
        itemCount: 6,
        scrollOnTap: true,
        onItemTapCallback: (index) {
          onTap(index);
        },
        child: ListWheelScrollView.useDelegate(
          controller: controller,
          physics: const FixedExtentScrollPhysics(),
          diameterRatio: diameterRatio,
          perspective: perspective,
          offAxisFraction: offAxisFraction,
          useMagnifier: useMagnifier,
          magnification: magnification,
          overAndUnderCenterOpacity: overAndUnderCenterOpacity,
          itemExtent: itemExtent,
          squeeze: squeeze,
          onSelectedItemChanged: onSelectedItemChanged,
          renderChildrenOutsideViewport: renderChildrenOutsideViewport,
          clipBehavior: clipBehavior,
          childDelegate: childDelegateBuilder,
        ),
      ),
    );
  }
}
