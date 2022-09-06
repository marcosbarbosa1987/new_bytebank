import 'dart:convert';

import 'package:bytebank_with_db/Models/transaction.dart';
import 'package:bytebank_with_db/http/web_client.dart';
import 'package:http/http.dart';

class TransactionWebClient {
  Future<List<Transaction>> findAll() async {
    final Response response =
        await client.get(Uri.parse(baseUrl)).timeout(const Duration(seconds: 30));

    List<Transaction> transactions = _toTransactions(response);
    return transactions;
  }

  List<Transaction> _toTransactions(Response response) {
    final List<dynamic> decodedJson = jsonDecode(response.body);
    final List<Transaction> transactions = decodedJson.map((dynamic json) {
      return Transaction.fromJson(json);
    }).toList();

    return transactions;
  }

  Future<Transaction> save(Transaction transaction, String password) async {
    final String transactionJson = jsonEncode(transaction.toJson());

    await Future.delayed(Duration(seconds: 10));

    final Response response = await client.post(Uri.parse(baseUrl),
        headers: {'Content-type': 'application/json', 'password': password},
        body: transactionJson);

    if (response.statusCode > 199 && response.statusCode < 300) {
      return Transaction.fromJson(jsonDecode(response.body));
    }

    throw HttpException(_getMessage(response.statusCode) ?? '');
  }

  String? _getMessage(int statusCode) {
    if (_statusCodeResponses.containsKey(statusCode)) {
      return _statusCodeResponses[statusCode];
    }
    return 'unknown error';
  }

  final Map<int, String> _statusCodeResponses = {
    400: 'there was an error  submitting  transactions',
    401: 'authentication failed',
    409: 'transaction always exists',
  };
}

class HttpException implements Exception {
  final String message;

  HttpException(this.message);
}