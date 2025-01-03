import 'package:flutter/material.dart';

class PhoneFirstScreen extends StatefulWidget {
  const PhoneFirstScreen({super.key});

  @override
  State<PhoneFirstScreen> createState() => _PhoneFirstScreenState();
}

class _PhoneFirstScreenState extends State<PhoneFirstScreen> {
  @override
  Widget build(BuildContext context) {
  return Scaffold(
      body: Center(
        child: Text("RESPONSIVE SUR PHONE"),
      ),
    );
  }
}
