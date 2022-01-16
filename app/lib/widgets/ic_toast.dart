import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../style/colors.dart';
import '../style/constants.dart';

class ICToast extends StatelessWidget {
  final String message;
  final bool isSuccess;
  final VoidCallback? onTap;

  const ICToast({
    Key? key,
    required this.message,
    required this.isSuccess,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = min(300, MediaQuery.of(context).size.width - 40);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CupertinoTheme.of(context).scaffoldBackgroundColor,
          borderRadius: kBorderRadius,
          boxShadow: kElevatedBoxShadow,
        ),
        child: Row(
          children: <Widget>[
            Icon(
              isSuccess
                  ? CupertinoIcons.check_mark_circled_solid
                  : CupertinoIcons.xmark_circle_fill,
              color: isSuccess ? ICColor.confirm : ICColor.danger,
              size: 24,
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: width - 16 * 2 - 24 - 10,
              child: Text(
                message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
