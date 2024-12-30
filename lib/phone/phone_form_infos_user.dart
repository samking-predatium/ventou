import 'package:flutter/material.dart';

class PhoneFormInfosUser extends StatefulWidget {
  const PhoneFormInfosUser({super.key});

  @override
  State<PhoneFormInfosUser> createState() => _PhoneFormInfosUserState();
}

class _PhoneFormInfosUserState extends State<PhoneFormInfosUser> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomUser = TextEditingController();
  final TextEditingController prenomsUser = TextEditingController();
  final TextEditingController phoneUser = TextEditingController();
  bool acceptConditions = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // ignore: unused_local_variable
    final isSmallScreen = size.width < 600;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(4),
                  child: Text("Renseignez"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
