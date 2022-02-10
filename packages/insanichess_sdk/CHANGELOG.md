## 0.6.10

- Add route for /api/games.

## 0.6.9

- Add `InsanichessConfig` with `Duration whiteForFirstMove`, `Duration expirePrivateChallengeAfter`, and `expirePrivateChallengeAfter`.
- Bump required `insanichess` version to `0.3.6`.

## 0.6.8

- `InsanichessChallenge.createdBy` is now `InsanichessPlayer?` instead of `String?`.
- Add equality operator to `InsanichessTimeControl`.

## 0.6.7

- Bump required `insanichess` version to `0.3.5`.

## 0.6.6

- Fix a bug with parsing remaining times of players.

## 0.6.5

- Add routes for accepting and declining challenge.

## 0.6.4

- Add endpoint for retrieving live game data.
- Add player and time spent for move to `MovePlayedGameEvent` so clients can sync their clocks.
- `InsanichessLiveGame` no longer overrides the `move` method.
- `InsanichessLiveGame` overrides `undo` method and restores back time spent for the undone move.
- `InsanichesSLiveGame` now has `updateTime` method that can update the time after a move.
- Added `pieceColorFromJson` function that parses `insanichess.PieceColor` from json representation.
- Bump required `insanichess` version to `0.3.4`.

## 0.6.3

- Add game events `disbanded` and `flagged`.
- Bump required `insanichess` version to `0.3.3`.

## 0.6.2

- Bump required `insanichess` version to `0.3.2`.

## 0.6.1

- Add `InsanichessLiveGame` model that extends `InsanichessGame` with properties required only while the game is active.
- Add logic that handles playing the game without support for timeout.
- Bump required `insanichess` version to `0.3.1`.

## 0.6.0

- Add `InsanichessLiveGameSettings` and update `InsanichessSettings` accordingly.

## 0.5.11

- Add `InsanichessGameEvent` that supports communication between clients and server.

## 0.5.10

- Add `ChallengeStatus` that represent the current status of `InsanichessChallenge`.

## 0.5.9

- Add route for settings.

## 0.5.8

- Rename /api/game to /api/challenge.

## 0.5.7

- Add route for POST /api/game.
- Add `InsanichessChallenge` model for challenges.

## 0.5.6

- Add `isValidUsername` validator.

## 0.5.5

- Add route for POST /api/player.
- Change JSON key for JWT token.

## 0.5.4

- Add email and password validators.

## 0.5.3

- Add JWT to `InsanichessUser`.

## 0.5.2

- Remove appleId field and add optional password field to `InsanichessUser`.

## 0.5.1

- Add optional field for Apple ID to `InsanichessUser` to support login with Apple and changing of the email.

## 0.5.0

- Create `InsanichessModel` base model.
- Create `InsanichessUser` for basic auth purposes.

## 0.4.0

- Remove flutter from dependencies.
- Bump required `insanichess` version to `0.3.0`.

## 0.3.0

- Add fields for time-keeping support per move.

## 0.2.0

- Bump required `insanichess` version to `0.2.0`.

## 0.1.9

- Fix a bug with `InsanichessGame.fromICString`.

## 0.1.8

- Add `InsanichessGame.fromICString` factory.
- Add `toJson` and `fromJson` extensions to `GameStatus`.
- Bump required `insanichess` version to `0.1.6`.

## 0.1.7

- Bump required `insanichess` version to `0.1.5`.

## 0.1.6

- Add `copyWith()` methods to settings classes.

## 0.1.5

- Reorganize `InsanichessSettings`.

## 0.1.4

- Add more options to `InsanichessSettings`.
- Bump required `insanichess` version to `0.1.4`.

## 0.1.3

- Add `InsanichessSettings` and `InsanichessOtbSettings` models.
- Bump required `insanichess` version to `0.1.3`.

## 0.1.2

- Bump required `insanichess` version to `0.1.2`.

## 0.1.1

- Bump required `insanichess` version to `0.1.1`.

## 0.1.0

- Bump required `insanichess` version to `0.1.0`.

## 0.0.3

- Add `Position positionFromFen(String)` utility function.
- Add `id` field to `InsanichessPlayer`.
- `ICString` representation of game now contains all necessary data to restore the game.

## 0.0.2

- Minor improvements

## 0.0.1

- Initial commit
