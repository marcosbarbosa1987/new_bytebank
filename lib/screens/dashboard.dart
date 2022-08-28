import 'package:bytebank_with_db/screens/contact_list.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text('Dashboard'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('images/bytebank_logo.png'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 40.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                color: Theme.of(context).colorScheme.secondary,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ContactsList()
                    ),
                    );
                  },
                  child: SizedBox(
                    height: 100,
                    width: 150,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Icon(
                            Icons.people,
                            color: Colors.white,
                            size: 32.0,
                          ),
                          Text(
                            'Contacts',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
