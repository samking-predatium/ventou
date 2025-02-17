import 'package:flutter/material.dart';

class TabletFirstScreen extends StatefulWidget {
  const TabletFirstScreen({super.key});

  @override
  State<TabletFirstScreen> createState() => _TabletFirstScreenState();
}

class _TabletFirstScreenState extends State<TabletFirstScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("RESPONSIVE SUR TABLETTE"),
      ),
    );
  }
}
