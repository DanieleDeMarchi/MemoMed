import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyListView<T> extends StatelessWidget {
  final List<T> elements;
  final Function(BuildContext context, int index, T element) tileBuilder;
  final Key animatedListKey;

  MyListView({
    super.key,
    required this.animatedListKey,
    required this.elements,
    required this.tileBuilder,
  });



  Widget buildTile(BuildContext context, int index, animation) {
    return Column(
      children: [
        SizeTransition(
          sizeFactor: animation,
          axis: Axis.vertical,
          child: tileBuilder(context, index, elements[index]),
        ),
        if (index < elements.length - 1)
          const Divider(
            height: 0,
            color: Colors.black38,
            indent: 70,
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SlidableAutoCloseBehavior(
      child: AnimatedList(
        key: animatedListKey,
        initialItemCount: elements.length,
        itemBuilder: (context, index, animation) {
          return buildTile(context, index, animation);
        },
      ),
    );
  }
}


