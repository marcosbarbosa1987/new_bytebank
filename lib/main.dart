import 'package:bytebank_with_db/screens/dashboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ByteBankApp());
}

class ByteBankApp extends StatelessWidget {
  const ByteBankApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.green
        ).copyWith(
            secondary: Colors.green[900]
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: TextButton.styleFrom(
                backgroundColor: Colors.blueAccent[700]
            )
        ),
      ),
      home: const Dashboard(),
    );
  }
}