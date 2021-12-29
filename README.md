# Insanichess

[![[app] Build Android](https://github.com/stelynx/insanichess/actions/workflows/app.build_android.yml/badge.svg)](https://github.com/stelynx/insanichess/actions/workflows/app.build_android.yml)
[![[app] Build iOS](https://github.com/stelynx/insanichess/actions/workflows/app.build_ios.yml/badge.svg)](https://github.com/stelynx/insanichess/actions/workflows/app.build_ios.yml)
[![[app] Lint & Test](https://github.com/stelynx/insanichess/actions/workflows/app.lint_test.yml/badge.svg)](https://github.com/stelynx/insanichess/actions/workflows/app.lint_test.yml)
[![[insanichess] Lint & Test](https://github.com/stelynx/insanichess/actions/workflows/insanichess.lint_test.yml/badge.svg)](https://github.com/stelynx/insanichess/actions/workflows/insanichess.lint_test.yml)
[![[insanichess_engine] Lint & Test](https://github.com/stelynx/insanichess/actions/workflows/insanichess_engine.lint_test.yml/badge.svg)](https://github.com/stelynx/insanichess/actions/workflows/insanichess_engine.lint_test.yml)
[![[insanichess_sdk] Lint & Test](https://github.com/stelynx/insanichess/actions/workflows/insanichess_sdk.lint_test.yml/badge.svg)](https://github.com/stelynx/insanichess/actions/workflows/insanichess_sdk.lint_test.yml)

_Are you ready to experience chess on a whole new level? More squares and more pieces make only your battle plan imagination an obstacle from achieving a victory!_

Do you feel bounded while playing chess? Are you playing the same opening over and over again and you became bored? Insanichess is a perfect solution for chess players (and others) that want to experience a chess game on a scope of mediaval battles! Arrange your pawns in a turtle formation, let your cavalry do the breakthrough supported by deadly bishops, all that while your rooks defend your king and queen. Let your battle imagination free in this insane chess variant inspired by classic game of chess and epic mediaval battles!

Do you have a friend that always beats you in chess? Now you have an option to beat him at a REAL chess game!

## App Features

- Insanichess currently supports only OTB (over-the-board) games.
- All your games are saved locally so you can replay them later.

### Future Features

Currently, the mobile app is still in development. Apart from the mobile app, a web version
is also going to be available. Of course, a backend
will be implemented (in Dart) which will provide support for the following:

- Multiplayer games.
- Tournaments.
- Games will be saved on a server instead of locally.
- Game statistics.
- Opening explorer.
- Different chess pieces and board styles.
- Sharing of games.
- _The sky is the limit ..._

## Game rules

The rules of the game are implemented in pure Dart.
The package that holds implementation is [`insanichess`](https://pub.dev/packages/insanichess)
and its implementation is in [packages/insanichess](packages/insanichess).

The game rules are pretty simple. All pieces move the same as their chess siblings.
The only difference in game rules apart from chess are the following:

- Pawns can always move only by one square (even from starting position) and can move diagonally without capturing a piece.
- There is no concept of _stalemate_ or _mate_. To win a game, you must capture opponent's king.
- The game can result in draw if and only if the players agree to a draw.
