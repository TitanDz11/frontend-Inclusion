import 'package:isar/isar.dart';

part 'document.g.dart';

/// Isar schema for locally stored documents.
@collection
class Document {
  Id id = Isar.autoIncrement;

  @Index()
  String? documentId;

  late String name;
  late String category;
  String? description;
  String? scannedImagePath;
  String? extractedText;

  late DateTime createdAt;
  late DateTime updatedAt;

  bool isProcessed = false;
}
