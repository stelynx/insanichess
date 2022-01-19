import 'package:insanichess/insanichess.dart' as insanichess;

import '../../time_control.dart';
import '../../util/enum/challenge_status.dart';
import '../insanichess_model.dart';

/// Represents an issued challenge for a game.
class InsanichessChallenge implements InsanichessDatabaseModel {
  /// The player's username who created this challenge.
  final String? createdBy;

  /// Time control for the game.
  final InsanichessTimeControl timeControl;

  /// Challenger's color preference or null.
  final insanichess.PieceColor? preferColor;

  /// Whether the challenge is private.
  final bool isPrivate;

  /// Current status of the challenge.
  final ChallengeStatus status;

  /// Creates new `InsanichessChallenge` object with [timeControl], challenger's
  /// [preferColor] selection, and whether this game [isPrivate] or not.
  const InsanichessChallenge({
    required this.createdBy,
    required this.timeControl,
    required this.preferColor,
    required this.isPrivate,
    required this.status,
  });

  /// Creates new `InsanichessChallenge` from [json].
  InsanichessChallenge.fromJson(Map<String, dynamic> json)
      : createdBy = json[InsanichessChallengeJsonKey.createdBy],
        timeControl = InsanichessTimeControl.fromJson(
            json[InsanichessChallengeJsonKey.timeControl]),
        preferColor = json[InsanichessChallengeJsonKey.preferColor] == 'w'
            ? insanichess.PieceColor.white
            : json[InsanichessChallengeJsonKey.preferColor] == 'b'
                ? insanichess.PieceColor.black
                : null,
        isPrivate = json[InsanichessChallengeJsonKey.isPrivate],
        status =
            challengeStatusFromJson(json[InsanichessChallengeJsonKey.status]);

  /// Copies the object and sets [createdBy] to [username]. It throws
  /// `UnsupportedError` in case this object already has non-empty [createdBy]
  /// field value.
  InsanichessChallenge addCreatedBy(String username) {
    if (createdBy != null) {
      throw UnsupportedError('This challenge already has creator data');
    }

    return InsanichessChallenge(
      createdBy: username,
      timeControl: timeControl,
      preferColor: preferColor,
      isPrivate: isPrivate,
      status: status,
    );
  }

  /// Copies the object with new [status].
  InsanichessChallenge updateStatus(ChallengeStatus status) {
    return InsanichessChallenge(
      createdBy: createdBy,
      timeControl: timeControl,
      preferColor: preferColor,
      isPrivate: isPrivate,
      status: status,
    );
  }

  /// Converts this object to json representation.
  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      InsanichessChallengeJsonKey.createdBy: createdBy,
      InsanichessChallengeJsonKey.timeControl: timeControl.toJson(),
      InsanichessChallengeJsonKey.preferColor:
          preferColor == insanichess.PieceColor.white
              ? 'w'
              : preferColor == insanichess.PieceColor.black
                  ? 'b'
                  : null,
      InsanichessChallengeJsonKey.isPrivate: isPrivate,
      InsanichessChallengeJsonKey.status: status.toJson(),
    };
  }
}

/// Keys used in `InsanichessChallenge` json representations.
abstract class InsanichessChallengeJsonKey {
  /// Key for `InsanichessChallenge.createdBy`.
  static const String createdBy = 'created_by';

  /// Key for `InsanichessChallenge.timeControl`.
  static const String timeControl = 'time_control';

  /// Key for `InsanichessChallenge.preferColor`.
  static const String preferColor = 'prefer_color';

  /// Key for `InsanichessChallenge.isPrivate`.
  static const String isPrivate = 'is_private';

  /// Key for `InsanichessChallenge.status`.
  static const String status = 'status';
}
