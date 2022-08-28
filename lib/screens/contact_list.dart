import 'package:bytebank_with_db/database/dao/contact_dao.dart';
import 'package:bytebank_with_db/screens/contact_form.dart';
import 'package:flutter/material.dart';

import '../Models/contact.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {

  final ContactDao _contactDao = ContactDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: FutureBuilder<List<Contact>>(
        initialData: const [],
        future: _contactDao.findAll(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const <Widget>[
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text('Loading'),
                    ),
                  ],
                ),
              );
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              final List<Contact> contacts = snapshot.data ?? [];
              return ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  return _ContactItem(contacts[index]);
                },
              );
          }
          return const Text('Unknown error');
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ContactForm(),
            )
          ).then((value) => {
            setState(() {
              widget.createState();
            })
          });
        },
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final Contact _contact;

  const _ContactItem(this._contact);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          _contact.fullName,
          style: const TextStyle(fontSize: 24.0),
        ),
        subtitle: Text(
          _contact.accountNumber.toString(),
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
