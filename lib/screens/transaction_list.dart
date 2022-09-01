import 'package:bytebank_with_db/http/webclients/transactions_webclient.dart';
import 'package:flutter/material.dart';

import '../Models/contact.dart';
import '../components/centered_message.dart';
import '../components/progress.dart';

class TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TransactionWebClient webClient = TransactionWebClient();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Transaction Feed'),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
        body: FutureBuilder<List<Transaction>>(
          future: webClient.findAll(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                // TODO: Handle this case.
                break;
              case ConnectionState.waiting:
                return const Progress();
              case ConnectionState.active:
                // TODO: Handle this case.
                break;
              case ConnectionState.done:
                final List<Transaction> transactions = snapshot.data ?? [];
                if (transactions.isNotEmpty) {
                  return ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return _TransactionItem(transactions[index]);
                    },
                  );
                }
                return const CenteredMessage(
                  'No transactions found',
                  icon: Icons.warning,
                );
            }
            return const CenteredMessage('Unknown error');
          },
        ));
  }
}

class _TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const _TransactionItem(this.transaction);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.monetization_on),
        title: Text(transaction.value.toString()),
        subtitle: Text(transaction.contact.accountNumber.toString()),
      ),
    );
  }
}

class Transaction {
  final double value;
  final Contact contact;

  Transaction(this.value, this.contact);

  Transaction.fromJson(Map<String, dynamic> json) :
      value = json['value'],
      contact = Contact.fromJson(json['contact']);

  Map<String, dynamic> toJson() =>
      {
        'value': value,
        'contact': contact.toJson()
      };
}
