import 'package:flutter/material.dart';

class DetailElement extends StatelessWidget {
  final String text;
  final String label;
  final double? textFontSize;
  final double? labelFontSize;
  final int? maxLines;

  const DetailElement(
      {Key? key, required this.text, required this.label, this.textFontSize, this.labelFontSize, this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: Text(
                label,
                maxLines: maxLines ?? 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: labelFontSize ?? 14, color: Theme.of(context).primaryColorDark)),
          ),
          Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: textFontSize ?? 22),
          )
        ],
      ),
    );
  }
}