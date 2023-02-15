import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../model/terapia.dart';
import '../provider/assunzione_farmaco_provider.dart';
import '../provider/therapy_provider.dart';
import '../view/detail_page.dart';
import 'empty_page.dart';
import 'list_tile.dart';

class TherapyListView extends ConsumerWidget {
  final String emptyMessage;
  final Provider<List<Terapia>> terapieProvider;

  const TherapyListView(this.terapieProvider, {super.key, required this.emptyMessage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Terapia> elements = ref.watch(terapieProvider);

    if(elements.isEmpty){
      return SliverFillRemaining(child: EmptyPage(message: emptyMessage,));
    }

    return SlidableAutoCloseBehavior(
      child: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return TherapyTile(elements[index]);
          },
          childCount: elements.length,
        ),
      ),
    );
  }
}
