import 'dart:async';

import 'package:bytebank_with_db/Models/transaction.dart';
import 'package:bytebank_with_db/components/progress.dart';
import 'package:bytebank_with_db/components/response_dialog.dart';
import 'package:bytebank_with_db/components/transaction_auth_dialog.dart';
import 'package:bytebank_with_db/http/webclients/transactions_webclient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../Models/contact.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  const TransactionForm(this.contact);

  @override
  TransactionFormState createState() => TransactionFormState();
}

class TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();
  final TransactionWebClient _webClient = TransactionWebClient();
  final String transactionId = const Uuid().v4();
  bool _sending = false;

  @override
  Widget build(BuildContext context) {
    print('unique uuid => $transactionId');
    return Scaffold(
      appBar: AppBar(
        title: const Text('New transaction'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
               Visibility(
                visible: _sending,
                child: const Progress(
                  message: 'Sending...',
                ),
              ),
              Text(
                widget.contact.name,
                style: const TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  widget.contact.accountNumber.toString(),
                  style: const TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: const TextStyle(fontSize: 24.0),
                  decoration: const InputDecoration(labelText: 'Value'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: const Text('Transfer'),
                    onPressed: () {
                      final double? value =
                          double.tryParse(_valueController.text);
                      if (value != null) {
                        final Transaction transactionCreated =
                            Transaction(transactionId, value, widget.contact);

                        if (transactionCreated.value <= 0) {
                          showDialog(
                              context: context,
                              builder: (contextDialog) {
                                return FailureDialog('you cannot transfer 0');
                              });
                        } else {
                          showDialog(
                              context: context,
                              builder: (contextDialog) {
                                return TransactionAuthDialog(
                                    onConfirm: (String password) {
                                  _save(transactionCreated, password, context);
                                });
                              });
                        }
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _save(Transaction transactionCreated, String password,
      BuildContext context) async {
    setState(() {
      _sending = true;
    });
    _send(transactionCreated, password, context);
  }

  Future<void> _showSuccessMessage(
      Transaction transaction, BuildContext context) async {
    if (transaction != null) {
      await showDialog(
          context: context,
          builder: (contextDialog) {
            return SuccessDialog('successfull transaction');
          });
      Navigator.pop(context);
    }
  }

  Future<void> _send(Transaction transactionCreated, String password,
      BuildContext context) async {
    try {
      final Transaction transaction =
          await _webClient.save(transactionCreated, password);
      _showSuccessMessage(transaction, context);
    } on TimeoutException catch (e) {
      _showFailureMessage(context, message: e.message.toString());
    } on HttpException catch (e) {
      _showFailureMessage(context, message: e.message);
    } on Exception catch (e) {
      _showFailureMessage(context);
    } finally {
      setState(() {
        _sending = false;
      });
    }
  }

  void _showFailureMessage(BuildContext context,
      {String message = 'unknown error'}) {
    showDialog(
        context: context,
        builder: (contextDialog) {
          return FailureDialog(message);
        });
  }
}
