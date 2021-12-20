import 'package:flutter/cupertino.dart';
import 'package:insanichess/insanichess.dart' as insanichess;

import '../widgets/ic_board.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: ICBoard(
        board: insanichess.Board(),
      ),
    );
  }
}
