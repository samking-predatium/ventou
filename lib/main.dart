

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ventou/desktop/desktop_first_screen.dart';
import 'package:ventou/firebase_options.dart';
import 'package:ventou/phone/phone_first_screen.dart';
import 'package:ventou/redirection.dart';
import 'package:ventou/tablet/tablet_first_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Redirection(
        onPhone: PhoneFirstScreen(), 
        onTablet: TabletFirstScreen(), 
        onDesktop: DesktopFirstScreen(),
      ),
    );
  }
}
