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
      disabledColor:
          (color ?? CupertinoTheme.of(context).primaryColor).withOpacity(0.4),
    );
  }
}

class ICTrailingButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const ICTrailingButton({
    Key? key,
    required this.icon,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Semantics(
        container: true,
        excludeSemantics: true,
        label: 'Menu',
        button: true,
        child: DefaultTextStyle(
          style: CupertinoTheme.of(context).textTheme.navActionTextStyle,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 50),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const Padding(padding: EdgeInsetsDirectional.only(start: 6.0)),
                Icon(icon),
              ],
            ),
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }
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
      color: CupertinoTheme.of(context).scaffoldBackgroundColor,
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

class ICGameControlButton extends ICTrailingButton {
  const ICGameControlButton({
    Key? key,
    required IconData icon,
    VoidCallback? onPressed,
  }) : super(
          key: key,
          icon: icon,
          onPressed: onPressed,
        );
}
