import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneFirstScreen extends StatefulWidget {
  const PhoneFirstScreen({super.key});

  @override
  State<PhoneFirstScreen> createState() => _PhoneFirstScreenState();
}

class _PhoneFirstScreenState extends State<PhoneFirstScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Empêcher le retour arrière
      onWillPop: () async {
        // Vous pouvez aussi montrer une boîte de dialogue pour confirmer la sortie
        SystemNavigator.pop(); // Ceci fermera l'application
        return false;
      },
      child: Scaffold(
        // Retirer le bouton retour de l'AppBar si vous en avez un
        appBar: AppBar(
          automaticallyImplyLeading: false, // Ceci cache le bouton retour
        ),
        body: Center(
          child: Text("RESPONSIVE SUR PHONE"),
        ),
      ),
    );
  }
}