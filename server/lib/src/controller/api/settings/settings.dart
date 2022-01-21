import 'dart:io';

import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../../../services/database/database_service.dart';
import '../../../util/either.dart';
import '../../../util/failures/database_failure.dart';
import '../../../util/functions/body_parser.dart';
import '../../../util/functions/default_responses.dart';
import '../../../util/functions/jwt.dart';

/// Controller that handles settings requests.
class SettingsController {
  /// Database service instance.
  final DatabaseService _databaseService;

  /// Constructs new `SettingsController` object with [databaseService].
  const SettingsController({required DatabaseService databaseService})
      : _databaseService = databaseService;

  /// Handles settings GET [request].
  ///
  /// Returns 500 in case of internal server error, 401 if bad JWT token, 200 if
  /// everything is ok.
  ///
  /// Returns settings in body. If settings were not found, it creates new entry
  /// in database with default values.
  Future<void> handleGetSettings(HttpRequest request) async {
    // Check JWT.
    final String? jwtToken = getJwtFromRequest(request);
    if (jwtToken == null) return respondWithUnauthorized(request);
    final String? userIdIfValid = getUserIdFromJwtToken(jwtToken);
    if (userIdIfValid == null) return respondWithUnauthorized(request);

    // Check for user's settings
    final Either<DatabaseFailure, InsanichessSettings?>
        existingSettingsOrFailure =
        await _databaseService.getSettingsForUserWithUserId(userIdIfValid);
    if (existingSettingsOrFailure.isError()) {
      return respondWithInternalServerError(request);
    }

    // Return settings if present.
    if (existingSettingsOrFailure.hasValue()) {
      return respondWithJson(
        request,
        existingSettingsOrFailure.value!.toJson(),
      );
    }

    // Create settings if missing.
    final Either<DatabaseFailure, InsanichessSettings> settingsOrFailure =
        await _databaseService
            .createDefaultSettingsForUserWithUserId(userIdIfValid);
    if (settingsOrFailure.isError()) {
      return respondWithInternalServerError(request);
    }

    return respondWithJson(request, settingsOrFailure.value.toJson());
  }

  /// Handles PATCH [request] that updates settings.
  ///
  /// If the user's settings are not found, they are created with defaults and
  /// then updated with provided values. Unknown keys are skipped.
  ///
  /// Returns 500 in case of internal server error, 401 if bad JWT token, 400 in
  /// case of empty body, 200 in case of successful update.
  ///
  /// Returns empty body.
  Future<void> handlePatchSettings(HttpRequest request) async {
    if (request.method != 'PATCH' ||
        request.contentLength <= 0 ||
        request.headers.contentType?.value != ContentType.json.value) {
      return respondWithBadRequest(request);
    }

    // Check JWT.
    final String? jwtToken = getJwtFromRequest(request);
    if (jwtToken == null) return respondWithUnauthorized(request);
    final String? userIdIfValid = getUserIdFromJwtToken(jwtToken);
    if (userIdIfValid == null) return respondWithUnauthorized(request);

    // Check for user's settings
    final Either<DatabaseFailure, InsanichessSettings?>
        existingSettingsOrFailure =
        await _databaseService.getSettingsForUserWithUserId(userIdIfValid);
    if (existingSettingsOrFailure.isError()) {
      return respondWithInternalServerError(request);
    }

    // Create settings if missing.
    if (!existingSettingsOrFailure.hasValue()) {
      final Either<DatabaseFailure, InsanichessSettings> settingsOrFailure =
          await _databaseService
              .createDefaultSettingsForUserWithUserId(userIdIfValid);
      if (settingsOrFailure.isError()) {
        return respondWithInternalServerError(request);
      }
    }

    final Map<String, dynamic> body = await parseBodyFromRequest(request);

    // Try to update the settings object.
    try {
      for (final String key in body.keys) {
        if (key == InsanichessSettingsJsonKey.otb) {
          for (final String otbKey in body[key].keys) {
            String? columnName;
            dynamic columnValue = body[key][otbKey];
            switch (otbKey) {
              case InsanichessOtbSettingsJsonKey.mirrorTopPieces:
                columnName = 'otb_mirror_top_pieces';
                break;
              case InsanichessOtbSettingsJsonKey.rotateChessboard:
                columnName = 'otb_rotate_chessboard';
                break;
              case InsanichessGameSettingsJsonKey.allowUndo:
                columnName = 'otb_allow_undo';
                break;
              case InsanichessGameSettingsJsonKey.alwaysPromoteToQueen:
                columnName = 'otb_promote_queen';
                break;
              case InsanichessGameSettingsJsonKey.autoZoomOutOnMove:
                columnName = 'otb_auto_zoom_out';
                break;
              default:
                break;
            }

            if (columnName == null) continue;

            final Either<DatabaseFailure, void> updateResult =
                await _databaseService.updateSettingsValue(
              columnName,
              columnValue,
              userId: userIdIfValid,
            );
            if (updateResult.isError()) {
              return respondWithInternalServerError(request);
            }
          }

          continue;
        }

        if (key == InsanichessSettingsJsonKey.live) {
          for (final String otbKey in body[key].keys) {
            String? columnName;
            dynamic columnValue = body[key][otbKey];
            switch (otbKey) {
              case InsanichessGameSettingsJsonKey.allowUndo:
                columnName = 'live_allow_undo';
                break;
              case InsanichessGameSettingsJsonKey.alwaysPromoteToQueen:
                columnName = 'live_promote_queen';
                break;
              case InsanichessGameSettingsJsonKey.autoZoomOutOnMove:
                columnName = 'live_auto_zoom_out';
                break;
              default:
                break;
            }

            if (columnName == null) continue;

            final Either<DatabaseFailure, void> updateResult =
                await _databaseService.updateSettingsValue(
              columnName,
              columnValue,
              userId: userIdIfValid,
            );
            if (updateResult.isError()) {
              return respondWithInternalServerError(request);
            }
          }

          continue;
        }

        final dynamic columnValue = body[key];
        dynamic columnName;
        switch (key) {
          case InsanichessSettingsJsonKey.showZoomOutButtonOnLeft:
            columnName = 'zoom_out_button_left';
            break;
          case InsanichessSettingsJsonKey.showLegalMoves:
            columnName = 'show_legal_moves';
            break;
        }

        if (columnName == null) continue;

        final Either<DatabaseFailure, void> updateResult =
            await _databaseService.updateSettingsValue(
          columnName,
          columnValue,
          userId: userIdIfValid,
        );
        if (updateResult.isError()) {
          return respondWithInternalServerError(request);
        }
      }
    } catch (e) {
      return respondWithBadRequest(request);
    }

    return respondWithOk(request);
  }
}
