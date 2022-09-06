import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionAuthDialog extends StatefulWidget {

  final Function(String password) onConfirm;

  TransactionAuthDialog({
    required this.onConfirm
  });

  @override
  State<TransactionAuthDialog> createState() => _TransactionAuthDialogState();
}

class _TransactionAuthDialogState extends State<TransactionAuthDialog> {

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return CupertinoAlertDialog(
      title: const Text('Authenticate'),
      content: Padding(
        padding: const EdgeInsets.only(top: 24.0, bottom: 24.0),
        child: CupertinoTextField(
          controller: _passwordController,
          obscureText: true,
          maxLength: 4,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          decoration: BoxDecoration(
            border: Border.all(width: 4.0, color: Theme.of(context).colorScheme.secondary),
            borderRadius: BorderRadius.circular(8.0)
          ),
          style: const TextStyle(
            fontSize: 64.0,
            letterSpacing: 20.0,
          ),
        ),
      ),
      actions: [
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            widget.onConfirm(_passwordController.text);
            Navigator.pop(context);
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
