import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ventou/authentification/google_auth.dart';
import 'package:ventou/desktop/connexion/desktop_entrer_pin.dart';
import 'package:ventou/desktop/connexion/desktop_login_screen.dart';
import 'package:ventou/desktop/connexion/firest_desktop_form_infos_user.dart';
import 'package:ventou/desktop/desktop_first_screen.dart';
import 'package:ventou/phone/connexion/firest_phone_form_infos_user.dart';
import 'package:ventou/phone/connexion/phone_entrer_pin.dart';
import 'package:ventou/phone/connexion/phone_login_screen.dart';
import 'package:ventou/phone/phone_first_screen.dart';
import 'package:ventou/redirection.dart';
import 'package:ventou/tablet/connexion/firest_tablet_form_infos_user.dart';
import 'package:ventou/tablet/connexion/tablet_entrer_pin.dart';
import 'package:ventou/tablet/connexion/tablet_login_screen.dart';
import 'package:ventou/tablet/tablet_first_screen.dart';

class EcranInitial extends StatelessWidget {
  const EcranInitial({Key? key}) : super(key: key);

  Widget _buildLoadingScreen() {
    return Center(
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Center(
          child: Lottie.asset(
            'images/Animation - 1736773892666.json',
            width: 300,
            height: 300,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Future<bool> _checkWithDelay(Future<bool> futureCheck) async {
    final result = await Future.wait([
      futureCheck,
      Future.delayed(const Duration(seconds: 3)),
    ]);
    return result.first;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen();
        }

        // Si l'utilisateur n'est pas connecté, afficher l'écran de connexion
        if (!snapshot.hasData) {
          return const Redirection(
            onPhone: PhoneLoginScreen(),
            onTablet: TabletLoginScreen(),
            onDesktop: DesktopLoginScreen(),
          );
        }

        final user = snapshot.data!;
        return FutureBuilder<List<bool>>(
          future: Future.wait([
            AuthService().checkPinState(user.uid),
            AuthService().checkProfileComplete(user.uid),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingScreen();
            }

            if (snapshot.hasError || snapshot.data == null) {
              return const Center(child: Text('Une erreur est survenue.'));
            }

            final pinState = snapshot.data![0];
            final isProfileComplete = snapshot.data![1];

            // 1. Si le profil n'est pas complet, rediriger vers le formulaire
            if (!isProfileComplete) {
              return const Redirection(
                onPhone: FirestPhoneFormInfosUser(),
                onTablet: FirestTabletFormInfosUser(),
                onDesktop: FirestDesktopFormInfosUser(),
              );
            }

            // 2. Si le PIN est activé, rediriger vers l'écran de saisie du PIN
            if (pinState) {
              return const Redirection(
                onPhone: PhoneEntrerPin(),
                onTablet: TabletEntrerPin(),
                onDesktop: DesktopEntrerPin(),
              );
            }

            // 3. Si le profil est complet et pas de PIN, aller à l'écran d'accueil
            return const Redirection(
              onPhone: PhoneFirstScreen(),
              onTablet: TabletFirstScreen(),
              onDesktop: DesktopFirstScreen(),
            );
          },
        );
      },
    );
  }
}