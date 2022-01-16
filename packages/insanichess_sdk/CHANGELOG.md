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
