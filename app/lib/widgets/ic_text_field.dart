import 'package:flutter/cupertino.dart';

class ICTextField extends StatelessWidget {
  final String placeholder;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;
  final bool obscureText;

  const ICTextField({
    Key? key,
    required this.placeholder,
    required this.onChanged,
    this.keyboardType,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      onChanged: onChanged,
      placeholder: placeholder,
      keyboardType: keyboardType,
      obscureText: obscureText,
      toolbarOptions: const ToolbarOptions(paste: true, selectAll: true),
      padding: const EdgeInsetsDirectional.fromSTEB(14.0, 12.0, 14.0, 12.0),
    );
  }
}
