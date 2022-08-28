
import 'package:bytebank_with_db/database/app_database.dart';
import 'package:sqflite/sqflite.dart';
import '../../Models/contact.dart';

class ContactDao {

  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY, '
      '$_name TEXT, '
      '$_accountNumber INTEGER)';

  static const String _tableName = 'contacts';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _accountNumber = 'account_number';

  // Versão sem async/await
  // Future<int> save(Contact contact) {
//   return createDatabase().then((db) {
//     Map<String, dynamic> contactMap = Map();
//     contactMap['name'] = contact.fullName;
//     contactMap['account_number'] = contact.accountNumber;
//     return db.insert('contacts', contactMap);
//   });
// }

  Future<int> save(Contact contact) async {
    final Database db = await getDatabase();
    Map<String, dynamic> contactMap = toMap(contact);
    return db.insert(_tableName, contactMap);
  }

  Map<String, dynamic> toMap(Contact contact) {
    final Map<String, dynamic> contactMap = {};
    contactMap[_name] = contact.fullName;
    contactMap[_accountNumber] = contact.accountNumber;
    return contactMap;
  }

  //Versão sem async/await
  // Future<List<Contact>> findAll() {
//   return createDatabase().then((db) {
//     return db.query('contacts').then((maps) {
//       final List<Contact> contacts = [];
//
//       for (Map<String, dynamic> map in maps) {
//         final Contact contact = Contact(
//           map['id'],
//           map['name'],
//           map['account_number'],
//         );
//         contacts.add(contact);
//       }
//       return contacts;
//     });
//   });
// }

  Future<List<Contact>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);

    List<Contact> contacts = toList(result);
    return contacts;
  }

  List<Contact> toList(List<Map<String, dynamic>> result) {
    final List<Contact> contacts = [];
    for (Map<String, dynamic> row in result) {
      final Contact contact = Contact(
        row[_id],
        row[_name],
        row[_accountNumber],
      );
      contacts.add(contact);
    }
    return contacts;
  }
}