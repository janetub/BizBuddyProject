import 'package:hive/hive.dart';

part 'person.g.dart';

@HiveType(typeId: 0)
class Person extends HiveObject {
  @HiveField(0)
  final String _id = idGenerator();
  @HiveField(1)
  String name;
  @HiveField(2)
  Map<String, List<String>> contacts = {};


  Person(this.name);

  int addContact(String type, String contact) {
    int flag = 0;
    if (contacts.containsKey(type)) {
      contacts[type]!.add(contact);
      flag = 1;
    } else {
      contacts[type] = [contact];
      flag = 1;
    }
    return flag;
  }

  int removeContact(String type, String contact) {
    int flag = 0;
    if (contacts.containsKey(type)) {
      contacts[type]!.remove(contact);
      flag = 1;
    }
    return flag;
  }

  int editContact(String type, String oldContact, String newContact) {
    int index = contacts[type]!.indexOf(oldContact);
    if (index != -1) {
      contacts[type]![index] = newContact;
    }
    return (index != -1) ? 1 : 0;
  }

  static String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

  String toString() {
    String result = 'Name: ${name}\nID: ${_id}\n';
    for (var entry in contacts.entries) {
      result += '${entry.key}: ${entry.value.join(", ")}\n';
    }
    return result;
  }
}