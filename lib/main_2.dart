import 'package:flutter/material.dart';
import 'package:ventou/desktop/connexion/desktop_login_screen.dart';
import 'package:ventou/phone/connexion/phone_login_screen.dart';
import 'package:ventou/redirection.dart';
import 'package:ventou/tablet/connexion/tablet_login_screen.dart';

class Main2 extends StatelessWidget {
  const Main2({super.key});


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Redirection(
        onPhone: PhoneLoginScreen(),
        onTablet: TabletLoginScreen(),
        onDesktop: DesktopLoginScreen(),
      ),
    );
  }
}