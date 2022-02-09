## 0.3.6

- Apply new linter rules

## 0.3.5

- Fix a bug when a move can be undone after the OTB game is over.

## 0.3.4

- `Game.flagged()` not takes optional parameter for who ran out of time. (This is used by client applications.)

## 0.3.3

- Group `Game.whiteFlagged()` and `Game.blackFlagged()` into simpler `Game.flagged()`.

## 0.3.2

- Fix a bug with wrong row parsing in `Square.fromICString()` and `Square.toICString()`.

## 0.3.1

- Add support for distinguishing how a game has ended.

## 0.3.0

- Remove flutter from dependencies.

## 0.2.0

- Lower board size to 16 and adjust initial position.

## 0.1.6

- Add `Move.fromICString` and `Square.fromICString` factories.
- Add `GameStatus` to library exports.

## 0.1.5

- Fix not being able to promote with black pieces.

## 0.1.4

- Switch row and column in `Square.toICString()`.

## 0.1.3

- Always copy initial position when using it to prevent bugs with changing the actual initial position.

## 0.1.2

- Fix a bug with undo not working after going backward and not forward.

## 0.1.1

- Fix a bug with wrong legal moves calculation.

## 0.1.0

- Add computation of legal moves.
- Add `GameStatus` and calculation of game status.

## 0.0.4

- Add `Piece.fromFenSymbol(String)` method.

## 0.0.3

- Fix bug with undo move and forward / backward.

## 0.0.2

- Add documentation and more functions.

## 0.0.1

- Initial untested game logic.
