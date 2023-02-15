import 'package:flutter/material.dart';
import 'package:memo_med/features/home/widgets/select_user.dart';

class SelectedFamilyMember extends StatelessWidget {
  const SelectedFamilyMember({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: PersistentHeaderDelegate(
        height: 85.0,
        child: Container(
          color: Colors.white,
          child: const Material(
            elevation: 0.0,
            clipBehavior: Clip.antiAlias,
            child: SelectFamilyMember(),
          ),
        ),
      ),
    );
  }
}

class PersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;

  PersistentHeaderDelegate({required this.child, this.height = 50});

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  // + 0.0000001 altrimenti lo scroll non va.
  // https://github.com/flutter/flutter/issues/32563#issuecomment-817307390
  @override
  double get maxExtent => height + 0.0000001;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

