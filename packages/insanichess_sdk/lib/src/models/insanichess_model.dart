/// Interface that every database-writable model should implement.
abstract class InsanichessModel {
  /// Provides const constructor.
  const InsanichessModel();

  /// Will never be overriden, left for consistency.
  const InsanichessModel.fromJson(Map<String, dynamic> json);

  /// Converts this object to json representation.
  Map<String, Object?> toJson();
}
