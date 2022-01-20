/// Interface that every database-writable model should implement. This class is
/// defined just to provide distinction between models for database objects and
/// other models.
abstract class InsanichessDatabaseModel extends InsanichessModel {
  /// Provides const constructor.
  const InsanichessDatabaseModel();
}

/// Interface that every model should implement.
abstract class InsanichessModel {
  /// Provides const constructor.
  const InsanichessModel();

  /// Will never be overriden, left for consistency.
  const InsanichessModel.fromJson(Map<String, dynamic> json);

  /// Converts this object to json representation.
  Map<String, Object?> toJson();
}
