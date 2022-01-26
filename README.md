![](misc/github_banner.png)

# Insanichess

Insanichess is a free and open-source project implemented in pure Dart with Flutter for client applications.
Insanichess will stay free forever and all source is available to everyone on this repository.

[![](misc/download-on-the-app-store.png)](https://apps.apple.com/us/app/insanichess/id1600564831)
[![](misc/google-play-badge.png)](https://play.google.com/store/apps/details?id=com.stelynx.insanichess)

[![[app] Build Android](https://github.com/stelynx/insanichess/actions/workflows/app.build_android.yml/badge.svg)](https://github.com/stelynx/insanichess/actions/workflows/app.build_android.yml)
[![[app] Build iOS](https://github.com/stelynx/insanichess/actions/workflows/app.build_ios.yml/badge.svg)](https://github.com/stelynx/insanichess/actions/workflows/app.build_ios.yml)
[![[app] Lint & Test](https://github.com/stelynx/insanichess/actions/workflows/app.lint_test.yml/badge.svg)](https://github.com/stelynx/insanichess/actions/workflows/app.lint_test.yml)
[![[insanichess] Lint & Test](https://github.com/stelynx/insanichess/actions/workflows/insanichess.lint_test.yml/badge.svg)](https://github.com/stelynx/insanichess/actions/workflows/insanichess.lint_test.yml)
[![[insanichess_engine] Lint & Test](https://github.com/stelynx/insanichess/actions/workflows/insanichess_engine.lint_test.yml/badge.svg)](https://github.com/stelynx/insanichess/actions/workflows/insanichess_engine.lint_test.yml)
[![[insanichess_sdk] Lint & Test](https://github.com/stelynx/insanichess/actions/workflows/insanichess_sdk.lint_test.yml/badge.svg)](https://github.com/stelynx/insanichess/actions/workflows/insanichess_sdk.lint_test.yml)
[![[server] Deploy Staging](https://github.com/stelynx/insanichess/actions/workflows/server.deploy_staging.yml/badge.svg)](https://github.com/stelynx/insanichess/actions/workflows/server.deploy_staging.yml)
[![[server] Lint & Test](https://github.com/stelynx/insanichess/actions/workflows/server.lint_test.yml/badge.svg)](https://github.com/stelynx/insanichess/actions/workflows/server.lint_test.yml)

![](https://img.shields.io/github/languages/code-size/stelynx/insanichess?color=brown&logo=github&style=flat)
![](https://img.shields.io/tokei/lines/github/stelynx/insanichess?label=lines&logo=github&style=flat)
![](https://img.shields.io/github/license/stelynx/insanichess)
[![](https://img.shields.io/pub/v/insanichess?color=3dc6fd&label=insanichess&logo=dart)](https://pub.dev/packages/insanichess)
[![](https://img.shields.io/pub/v/insanichess_engine?color=3dc6fd&label=insanichess_engine&logo=dart)](https://pub.dev/packages/insanichess_engine)
[![](https://img.shields.io/pub/v/insanichess_sdk?color=3dc6fd&label=insanichess_sdk&logo=dart)](https://pub.dev/packages/insanichess_sdk)

<hr>

_Are you ready to experience chess on a whole new level? More squares and more pieces make only your battle plan imagination an obstacle from achieving a victory!_

Do you feel bounded while playing chess? Are you playing the same opening over and over again and you became bored? Insanichess is a perfect solution for chess players (and others) that want to experience a chess game on a scope of mediaval battles! Arrange your pawns in a turtle formation, let your cavalry do the breakthrough supported by deadly bishops, all that while your rooks defend your king and queen. Let your battle imagination free in this insane chess variant inspired by classic game of chess and epic mediaval battles!

Do you have a friend that always beats you in chess? Now you have an option to beat him at a REAL chess game!

## App Features

- Play an **online** game with custom time control and ability to specify preferred piece color.
- Finished games are stored in the database.
- Play OTB (over-the-board) games. The games are stored locally and can be found in Game History.
- Change settings for online and OTB games.

### Future Features

Currently, support for the following is being added to the Dart backend (sorted by priority):

- Web version.
- Play with random opponent.
- OTB games will be saved on a server instead of locally.
- Profile editing and searching for other players.
- Making friends.
- Tournaments.
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
- There is no castling. Your king must stand his ground!
- There is no concept of _stalemate_ or _mate_. To win a game, you must capture opponent's king.
- The game can result in draw if and only if the players agree to a draw.

## Repository structure

Insanichess repository consists of three major parts:

- [app](app) is a Flutter project containing client side code (mobile and web app);
- [server](server) is a pure Dart project containing server side code;
- [packages](packages) contains three Dart packages: [`insanichess`](packages/insanichess) that
  holds implementation of game rules, [`insanichess_engine`](packages/insanichess_engine) that
  holds implementation of Insanichess evaluation engine, and [`insanichess_sdk`](packages/insanichess_sdk) that
  extends `insanichess` package with functionality that both client and server applications need.

## Contributing

If you have a feature request or a bug to report, please open an issue.
