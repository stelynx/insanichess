import 'package:flutter/cupertino.dart';

class ICGameControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const ICGameControlButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: Icon(icon),
      onPressed: onPressed,
    );
  }
}
