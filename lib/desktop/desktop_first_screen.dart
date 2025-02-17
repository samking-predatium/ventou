import 'package:flutter/material.dart';

class DesktopFirstScreen extends StatefulWidget {
  const DesktopFirstScreen({super.key});

  @override
  State<DesktopFirstScreen> createState() => _DesktopFirstScreenState();
}

class _DesktopFirstScreenState extends State<DesktopFirstScreen> {
  @override
  Widget build(BuildContext context) {
 return Scaffold(
      body: Center(
        child: Text("RESPONSIVE SUR ORDINATEUR"),
      ),
    );
  }
}
