import 'package:isar/isar.dart';

part 'contact.g.dart';

/// Isar schema for medical/support contacts stored locally.
@collection
class Contact {
  Id id = Isar.autoIncrement;

  @Index()
  String? contactId;

  late String name;
  late String phone;
  late String category;
  String? address;

  bool isEmergency = false;
}
