import 'package:flutter/material.dart';

class TextInputField extends StatefulWidget {
  final TextEditingController inputController;
  final String hintText;
  final bool autoFocus;
  final bool readOnly;
  final EdgeInsets? padding;
  final EdgeInsets? scrollPadding;
  final Color? primaryColor;
  final Color? secondaryColor;
  final Color? accentColor;
  final Color? backgroundColor;
  final Color? errorColor;
  final String labelText;
  final String? helperText;
  final Function(String?)? validator;
  final Function()? onTap;
  final int? minLines;
  final int? maxLines;

  const TextInputField(
      {Key? key,
      required this.inputController,
      required this.hintText,
      required this.labelText,
      this.padding,
      this.scrollPadding,
      this.validator,
      this.autoFocus = false,
      this.readOnly = false,
      this.primaryColor,
      this.secondaryColor,
      this.accentColor,
      this.backgroundColor,
      this.errorColor,
      this.helperText,
      this.minLines,
      this.maxLines,
      this.onTap})
      : super(key: key);

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  late Color? primaryColor;
  late Color? focusColor;
  late Color? accentColor;
  late Color? backgroundColor;
  late Color? errorColor;

  late bool _isShowClearTextButton;

  setColors(BuildContext context) {
    primaryColor = widget.primaryColor ?? Theme.of(context).primaryColorDark;
    focusColor = widget.secondaryColor ?? Theme.of(context).primaryColorDark;
    accentColor = widget.accentColor ??
        Theme.of(context).inputDecorationTheme.enabledBorder?.borderSide.color;
    backgroundColor = widget.backgroundColor ?? Theme.of(context).inputDecorationTheme.fillColor;
    errorColor = widget.errorColor ?? Theme.of(context).errorColor;
  }

  String? onValidate(String? value) {
    if (widget.validator != null) {
      return widget.validator!(value);
    }
    return null;
  }

  onTap() {
    if (widget.onTap != null) {
      widget.onTap!();
    }
    hideShowClearTextButton(widget.inputController.text.isNotEmpty);
    widget.inputController.addListener(onChange);
  }

  onFocusChange(bool isFocus) {
    if (!isFocus) {
      widget.inputController.removeListener(onChange);
      hideShowClearTextButton(false);
    }
  }

  onChange() {
    if (_isShowClearTextButton ^ widget.inputController.text.isNotEmpty) {
      hideShowClearTextButton(widget.inputController.text.isNotEmpty);
    }
  }

  hideShowClearTextButton(bool isShow) {
    setState(() {
      _isShowClearTextButton = isShow;
    });
  }

  clearText() {
    setState(() {
      widget.inputController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    _isShowClearTextButton = false;
  }

  @override
  Widget build(BuildContext context) {
    setColors(context);

    return Padding(
      padding: widget.padding ?? const EdgeInsets.fromLTRB(6.0, 10.0, 6.0, 8.0),
      child: Focus(
        onFocusChange: onFocusChange,
        child: TextFormField(
          minLines: widget.minLines ?? 1,
          maxLines: widget.maxLines ?? 4,
          scrollPadding: widget.scrollPadding ?? const EdgeInsets.all(20.0),
          onTap: onTap,
          controller: widget.inputController,
          validator: onValidate,
          autofocus: widget.autoFocus,
          readOnly: widget.readOnly,
          keyboardType: TextInputType.text,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            label: Text(widget.labelText),
            labelStyle: TextStyle(color: widget.primaryColor),
            floatingLabelStyle: TextStyle(
              color: widget.primaryColor,
            ),
            filled: false,
            fillColor: widget.accentColor,
            hintText: widget.hintText,
            helperText: widget.helperText,
            helperStyle: const TextStyle(height: 0.5),
            errorStyle: const TextStyle(height: 0.5),
            hintStyle: TextStyle(color: Colors.grey.withOpacity(.75)),
            suffixIcon: _isShowClearTextButton
                ? InkWell(
                    onTap: clearText,
                    child: const Icon(Icons.clear, color: Color(0xFF757575), size: 22),
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
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
        ),
      ),
    );
  }
}
