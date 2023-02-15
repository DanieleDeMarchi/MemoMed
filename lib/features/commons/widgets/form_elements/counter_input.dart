import 'package:flutter/material.dart';

class CounterTile extends StatefulWidget {
  final int initialValue;
  final Widget title;
  final Function(int)? onChange;
  final EdgeInsets? padding;
  final double width;

  const CounterTile(
      {Key? key,
        this.initialValue = 1,
        required this.title,
        this.onChange,
        this.width = 150,
        this.padding})
      : super(key: key);

  @override
  State<CounterTile> createState() => _CounterTileState();
}

class _CounterTileState extends State<CounterTile> {
  late int _value = widget.initialValue;
  final TextEditingController _counterValueInputController = TextEditingController();

  static const double buttonWidth = 48;

  @override
  void initState() {
    super.initState();
    _counterValueInputController.text = widget.initialValue.toString();
  }

  void updateCount(count) {
    setState(() {
      _value = count;
      _counterValueInputController.text = _value.toString();
    });
    if (widget.onChange != null) {
      widget.onChange!(count);
    }
  }

  Widget counterWidget(int count) {
    return Container(
      alignment: Alignment.center,
      width: widget.width - (buttonWidth * 2),
      child: TextFormField(
        readOnly: true,
        controller: _counterValueInputController,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        //onTap: () => _counterValueInputController.selection = TextSelection(
        //    baseOffset: 0, extentOffset: _counterValueInputController.value.text.length),
        //onEditingComplete: () {
        //  if (_counterValueInputController.text.isNotEmpty) {
        //    updateCount(int.parse(_counterValueInputController.text));
        //  } else {
        //    updateCount(_value);
        //  }
        //  FocusManager.instance.primaryFocus?.unfocus();
        //},
        decoration: const InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10.0),
      child: Padding(
        padding: widget.padding ?? const EdgeInsets.fromLTRB(6.0, 8.0, 6.0, 2.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                child: widget.title,
              ),
            ),
            Container(
              width: widget.width,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(15),
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: Theme.of(context).primaryColorDark,
                  width: 1,
                ),
              ),
              child: CountController(
                decrementIconBuilder: (enabled) => Container(
                  width: buttonWidth - 1,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark.withOpacity(enabled ? 1.0 : 0.7),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
                  ),
                  child: const Icon(
                    Icons.remove_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                incrementIconBuilder: (enabled) => Container(
                  width: buttonWidth - 1,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark.withOpacity(enabled ? 1.0 : 0.7),
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(14), bottomRight: Radius.circular(14)),
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                countBuilder: (count) => counterWidget(count),
                count: _value,
                updateCount: (count) => updateCount(count),
                stepSize: 1,
                minimum: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CountController extends StatefulWidget {
  const CountController({
    Key? key,
    required this.decrementIconBuilder,
    required this.incrementIconBuilder,
    required this.countBuilder,
    required this.count,
    required this.updateCount,
    this.stepSize = 1,
    this.minimum,
    this.maximum,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 25.0),
  }) : super(key: key);

  final Widget Function(bool enabled) decrementIconBuilder;
  final Widget Function(bool enabled) incrementIconBuilder;
  final Widget Function(int count) countBuilder;
  final int count;
  final Function(int) updateCount;
  final int stepSize;
  final int? minimum;
  final int? maximum;
  final EdgeInsetsGeometry contentPadding;

  @override
  _CountControllerState createState() => _CountControllerState();
}

class _CountControllerState extends State<CountController> {
  int get count => widget.count;
  int? get minimum => widget.minimum;
  int? get maximum => widget.maximum;
  int get stepSize => widget.stepSize;

  bool get canDecrement => minimum == null || count - stepSize >= minimum!;
  bool get canIncrement => maximum == null || count + stepSize <= maximum!;

  void _decrementCounter() {
    if (canDecrement) {
      setState(() => widget.updateCount(count - stepSize));
    }
  }

  void _incrementCounter() {
    if (canIncrement) {
      setState(() => widget.updateCount(count + stepSize));
    }
  }

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      InkWell(
        onTap: _decrementCounter,
        child: widget.decrementIconBuilder(canDecrement),
      ),
      widget.countBuilder(count),
      InkWell(
        onTap: _incrementCounter,
        child: widget.incrementIconBuilder(canIncrement),
      ),
    ],
  );
}
