import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../style/colors.dart';
import '../style/constants.dart';

class ICToast extends StatefulWidget {
  final String message;
  final bool isSuccess;
  final VoidCallback dismissWith;

  const ICToast({
    Key? key,
    required this.message,
    required this.isSuccess,
    required this.dismissWith,
  }) : super(key: key);

  static Positioned builder(
    BuildContext context, {
    required String message,
    required VoidCallback dismissWith,
    bool isSuccess = false,
  }) {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom == 0 ? 16 : 0,
      child: SafeArea(
        child: ICToast(
          isSuccess: isSuccess,
          message: message,
          dismissWith: dismissWith,
        ),
      ),
    );
  }

  @override
  State<ICToast> createState() => _ICToastState();
}

class _ICToastState extends State<ICToast> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) widget.dismissWith();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = min(300, MediaQuery.of(context).size.width - 40);

    return GestureDetector(
      onTap: widget.dismissWith,
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
              widget.isSuccess
                  ? CupertinoIcons.check_mark_circled_solid
                  : CupertinoIcons.xmark_circle_fill,
              color: widget.isSuccess ? ICColor.confirm : ICColor.danger,
              size: 24,
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: width - 16 * 2 - 24 - 10,
              child: Text(
                widget.message,
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
