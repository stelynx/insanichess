import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        border: Border(),
        middle: Text('Rules'),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 20.0),
          child: MarkdownBody(
            data: _rules,
            styleSheetTheme: MarkdownStyleSheetBaseTheme.cupertino,
          ),
        ),
      ),
    );
  }
}

const String _rules = '''
The game rules are pretty simple. All pieces move the same as their chess siblings.
The only difference in game rules apart from chess are the following:

- Pawns can always move only by one square (even from starting position) and can move diagonally without capturing a piece.
- There is no concept of _stalemate_ or _mate_. To win a game, you must capture opponent's king.
- The game can result in draw if and only if the players agree to a draw.
''';
