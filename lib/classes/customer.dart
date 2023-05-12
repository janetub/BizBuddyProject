import 'dart:collection';

class Customer {
  String id ;
  String firstName;
  String middleName;
  String lastName;
  Map<String, List<String>> contacts = {};

  String get ID => id;

  String getFirstName() => firstName;

  void setFirstName(String value) {
    firstName = value;
  }

  String getMiddleName() => middleName;

  void setMiddleName(String value) {
    middleName = value;
  }

  String getLastName() => lastName;

  void setLastName(String value) {
    lastName = value;
  }

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

  Customer(String firstName, String middleName, String lastName)
  {
    this.id = idGenerator();
    this.firstName = firstName;
    this.middleName = middleName;
    this.lastName = lastName;
  }

  String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }
}