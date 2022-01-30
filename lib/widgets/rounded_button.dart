import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    this.buttonColor,
    this.buttonFunction,
    this.buttonText,
    this.textColor,
  }) : super(key: key);

  final Color? buttonColor;
  final Color? textColor;
  final dynamic Function()? buttonFunction;
  final String? buttonText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: (buttonColor == null)
            ? Theme.of(context).primaryColor
            : buttonColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side:
            BorderSide(width: 2, color: Theme.of(context).primaryColor)),
        child: MaterialButton(
          onPressed: buttonFunction,
          minWidth: 200.0,
          height: 48.0,
          highlightColor: Theme.of(context).primaryColor,
          child: Text(
            buttonText.toString(),
            style: TextStyle(color: textColor ?? Colors.white),
          ),
        ),
      ),
    );
  }
}
//0xFF2ba84a
