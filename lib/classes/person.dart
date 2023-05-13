
class Person {
  final String _id = idGenerator();
  String firstName = '';
  String? middleName;
  String lastName = '';
  Map<String, List<String>> contacts = {};

  String get id => _id;


  Person(this.firstName, String this.middleName, this.lastName);

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
}