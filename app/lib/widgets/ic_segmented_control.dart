import 'package:flutter/cupertino.dart';

import '../style/constants.dart';

const double _kHeight = 40;

class ICSegmentedControl<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final List<String> labels;
  final ValueChanged<T> onChanged;
  final double width;
  final double lineHeight;
  final int? maxItemsInRow;

  const ICSegmentedControl({
    Key? key,
    required this.value,
    required this.items,
    required this.labels,
    required this.onChanged,
    required this.width,
    this.lineHeight = _kHeight,
    this.maxItemsInRow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    if (maxItemsInRow == null) {
      for (int i = 0; i < items.length; i++) {
        children.add(_TaiSegmentedControlElement(
          label: labels[i],
          onTap: items[i] == value ? null : () => onChanged(items[i]),
          width: width / items.length,
        ));
      }
    } else {
      List<Widget> rowChildren = <Widget>[];
      for (int i = 0; i < items.length; i++) {
        rowChildren.add(_TaiSegmentedControlElement(
          label: labels[i],
          onTap: items[i] == value ? null : () => onChanged(items[i]),
          width: width / maxItemsInRow!,
        ));
        if (rowChildren.length == maxItemsInRow) {
          children.add(Row(children: rowChildren));
          rowChildren = <Widget>[];
        }
      }
      if (rowChildren.isNotEmpty) {
        children.add(Row(children: rowChildren));
      }
    }

    return Container(
      width: width + 2,
      constraints: const BoxConstraints(minHeight: _kHeight),
      decoration: BoxDecoration(
        color: CupertinoTheme.of(context).scaffoldBackgroundColor,
        borderRadius: kBorderRadius,
        border: Border.all(
          width: 1,
          color: CupertinoTheme.of(context).primaryColor,
        ),
      ),
      child: maxItemsInRow == null
          ? Row(children: children)
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
    );
  }
}

class _TaiSegmentedControlElement extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final double width;

  const _TaiSegmentedControlElement({
    Key? key,
    required this.label,
    required this.onTap,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: width,
        height: _kHeight,
        decoration: BoxDecoration(
          color: onTap == null
              ? CupertinoTheme.of(context).primaryColor
              : CupertinoTheme.of(context).scaffoldBackgroundColor,
          borderRadius: kBorderRadius,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: onTap == null
                  ? CupertinoTheme.of(context).scaffoldBackgroundColor
                  : CupertinoTheme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
