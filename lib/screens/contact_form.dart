import 'package:flutter/material.dart';

import '../Models/contact.dart';
import '../database/dao/contact_dao.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({Key? key}) : super(key: key);

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  @override
  Widget build(BuildContext context) {

    final TextEditingController controllerName = TextEditingController();
    final TextEditingController controllerAccount = TextEditingController();
    final ContactDao contactDao = ContactDao();

    return Scaffold(
      appBar: AppBar(
        title: const Text('New contact'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
        child: Column(
          children: <Widget>[
             TextField(
               controller: controllerName,
              decoration: const InputDecoration(
                labelText: 'Full name',
              ),
              style: const TextStyle(fontSize: 24.0),
            ),
            TextField(
              controller: controllerAccount,
              decoration: const InputDecoration(
                labelText: 'Account number',
              ),
              style: const TextStyle(fontSize: 24.0),
              keyboardType: TextInputType.number,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  child: const Text('Create'),
                  onPressed: (){
                    final String fullName = controllerName.text;
                    final int? accountNumber = int.tryParse(controllerAccount.text);

                    if (accountNumber != null) {
                      final contact = Contact(0, fullName, accountNumber);
                      contactDao.save(contact).then((id) => Navigator.pop(context)
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
