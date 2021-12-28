import 'package:flutter/cupertino.dart';

import '../style/colors.dart';
import 'util/cupertino_bordered_button.dart';

class ICButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? color;

  const ICButton({
    Key? key,
    required this.child,
    this.onPressed,
  })  : color = null,
        super(key: key);

  const ICButton.filled({
    Key? key,
    required this.child,
    this.onPressed,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: child,
      onPressed: onPressed,
      color: color,
    );
  }
}

class ICIconButton extends ICButton {
  ICIconButton({
    Key? key,
    required IconData icon,
    VoidCallback? onPressed,
  }) : super(
          key: key,
          child: Icon(icon),
          onPressed: onPressed,
        );
}

class ICTextButton extends ICButton {
  ICTextButton({
    Key? key,
    required String text,
    VoidCallback? onPressed,
  }) : super(
          key: key,
          child: Text(text),
          onPressed: onPressed,
        );

  ICTextButton.filled({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    Color? color,
  }) : super.filled(
          key: key,
          child: Text(text),
          onPressed: onPressed,
          color: color,
        );
}

class ICPrimaryButton extends ICTextButton {
  ICPrimaryButton({
    Key? key,
    required String text,
    VoidCallback? onPressed,
  }) : super.filled(
          key: key,
          text: text,
          onPressed: onPressed,
          color: ICColor.primary,
        );
}

class ICSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const ICSecondaryButton({
    Key? key,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoBorderedButton(
      child: Text(text),
      onPressed: onPressed,
      color: ICColor.primaryContrastingColor,
    );
  }
}

class ICConfirmButton extends ICTextButton {
  ICConfirmButton({
    Key? key,
    required String text,
    VoidCallback? onPressed,
  }) : super.filled(
          key: key,
          text: text,
          onPressed: onPressed,
          color: ICColor.primary,
        );
}

class ICGameControlButton extends ICIconButton {
  ICGameControlButton({
    Key? key,
    required IconData icon,
    VoidCallback? onPressed,
  }) : super(
          key: key,
          icon: icon,
          onPressed: onPressed,
        );
}