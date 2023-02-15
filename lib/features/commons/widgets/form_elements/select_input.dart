import 'package:flutter/material.dart';

class SelectField<T> extends StatefulWidget {
  final String labelText;
  final List<SelectFieldMenuItem<T>> options;
  final T? initialValue;
  final Function onSelectCallback;
  final EdgeInsets? padding;
  final double? itemHeight;
  final Color? primaryColor;
  final Color? secondaryColor;
  final Color? accentColor;
  final Color? backgroundColor;
  final Color? errorColor;

  const SelectField(
      {Key? key,
        required this.labelText,
        required this.options,
        required this.onSelectCallback,
        this.itemHeight = kMinInteractiveDimension,
        this.initialValue,
        this.padding,
        this.primaryColor,
        this.secondaryColor,
        this.accentColor,
        this.backgroundColor,
        this.errorColor})
      : super(key: key);

  @override
  State<SelectField> createState() => _SelectFieldState<T>();
}

class _SelectFieldState<T> extends State<SelectField> {
  late T _selected;

  late Color? primaryColor;
  late Color? focusColor;
  late Color? accentColor;
  late Color? backgroundColor;
  late Color? errorColor;
  late List<SelectFieldMenuItem<T>>? _options;

  @override
  void initState() {
    _options = widget.options.cast<SelectFieldMenuItem<T>>();
    _selected = widget.initialValue ?? widget.options.first.value;
    super.initState();
  }

  onChange(T? value) {
    setState(() {
      _selected = value!;
    });
    widget.onSelectCallback(value);
  }

  setColors(BuildContext context) {
    primaryColor = widget.primaryColor ?? Theme.of(context).primaryColorDark;
    focusColor = widget.secondaryColor ?? Theme.of(context).primaryColorDark;
    accentColor = widget.accentColor ??
        Theme.of(context).inputDecorationTheme.enabledBorder?.borderSide.color;
    backgroundColor = widget.backgroundColor ?? Theme.of(context).inputDecorationTheme.fillColor;
    errorColor = widget.errorColor ?? Theme.of(context).errorColor;
  }

  @override
  Widget build(BuildContext context) {
    setColors(context);

    return Padding(
      padding: widget.padding ?? const EdgeInsets.fromLTRB(6.0, 8.0, 6.0, 4.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(color: widget.primaryColor),
          hintText: "",
          filled: false,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor!, width: 1.0),
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: focusColor!, width: 1.8),
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: errorColor!, width: 1.0),
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor!, width: 1.0),
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          ),
        ),
        child: DropdownButton<T>(
          items: _options,
          itemHeight: widget.itemHeight,
          value: _selected,
          onChanged: (T? value) => onChange(value),
          underline: const SizedBox(),
          isExpanded: true,
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        ),
      ),
    );
  }
}

class SelectFieldMenuItem<T> extends DropdownMenuItem<T>{
  const SelectFieldMenuItem({
    super.key,
    super.onTap,
    super.value,
    super.enabled = true,
    super.alignment,
    required super.child,
  });

}