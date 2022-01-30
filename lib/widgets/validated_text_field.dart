import 'package:flutter/material.dart';

import '../constant.dart';

class ValidatedTextField extends StatelessWidget {
  const ValidatedTextField({
    Key? key,
    this.labelText,
    this.hintText,
    this.fieldValidator,
    this.fieldObscure,
    this.keyboardType,
    this.fieldController,
    this.readOnly,
    this.fieldIcon,
    this.suffixIcon,
  }) : super(key: key);

  final String? labelText;
  final String? hintText;
  final String? Function(String?)? fieldValidator;
  final bool? fieldObscure;
  final TextInputType? keyboardType;
  final TextEditingController? fieldController;
  final bool? readOnly;
  final IconData? fieldIcon;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    bool obscure = (fieldObscure == true) ? true : false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
      child: Card(
        semanticContainer: false,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
          enableInteractiveSelection: false,
          controller: fieldController,
          decoration: kTextFieldDecoration.copyWith(
            labelText: labelText,
            hintText: hintText,
            prefixIcon: Icon(fieldIcon,color: Colors.grey.shade400,size: 24),
            suffixIcon: suffixIcon,
          ),
          textAlign: TextAlign.center,
          validator: fieldValidator,
          obscureText: obscure,
          keyboardType: keyboardType,
          readOnly: (readOnly == null) ? false : true,
        ),
      ),
    );
  }
}
