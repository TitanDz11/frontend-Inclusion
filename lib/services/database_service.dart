import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/document.dart';
import '../models/contact.dart';

/// Service to initialize and manage Isar DB instance.
class DatabaseService {
  static Isar? _isar;

  /// Initialize Isar DB with all schemas.
  static Future<Isar> initialize() async {
    if (_isar != null) return _isar!;

    final dir = await getApplicationDocumentsDirectory();

    _isar = await Isar.open(
      [DocumentSchema, ContactSchema],
      directory: dir.path,
      name: 'inclusion_atlantida',
    );

    return _isar!;
  }

  /// Get the Isar instance.
  static Isar get instance {
    if (_isar == null) {
      throw Exception('Database not initialized. Call initialize() first.');
    }
    return _isar!;
  }

  /// Close the database connection.
  static Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
}
