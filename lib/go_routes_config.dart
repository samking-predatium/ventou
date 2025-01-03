import 'package:go_router/go_router.dart';
import 'package:ventou/desktop/connexion/desktop_definir_pin.dart';
import 'package:ventou/desktop/connexion/desktop_entrer_pin.dart';
import 'package:ventou/desktop/connexion/desktop_verifier_code_send_by_mail.dart';
import 'package:ventou/desktop/connexion/desktop_verifier_compte.dart';
import 'package:ventou/desktop/desktop_first_screen.dart';
import 'package:ventou/main_2.dart';
import 'package:ventou/phone/connexion/phone_definir_pin.dart';
import 'package:ventou/phone/connexion/phone_entrer_pin.dart';
import 'package:ventou/phone/connexion/verifier_code_send_by_mail.dart';
import 'package:ventou/phone/connexion/verifier_compte.dart';
import 'package:ventou/phone/phone_first_screen.dart';
import 'package:ventou/tablet/connexion/tablet_definir_pin.dart';
import 'package:ventou/tablet/connexion/tablet_entrer_pin.dart';
import 'package:ventou/tablet/connexion/tablet_verifier_code_send_by_mail.dart';
import 'package:ventou/tablet/connexion/tablet_verifier_compte.dart';
import 'package:ventou/tablet/tablet_first_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const Main2(),
    ),

    // PHONE ROOT
    GoRoute(
      path: '/definir-pin',
      builder: (context, state) => PhoneDefinirPin(
        onPinConfirmed: state.extra as Function(String)?,
      ),
    ),

    GoRoute(
      path: '/first-screen',
      builder: (context, state) => const PhoneFirstScreen(),
    ),

    GoRoute(
      path: '/entree-pin',
      builder: (context, state) => const PhoneEntrerPin(),
    ),

    GoRoute(
      path: '/verifier-compte',
      builder: (context, state) => const VerifierCompte(),
    ),

    GoRoute(
      path: '/verifier-code-send',
      builder: (context, state) => const VerifierCodeSendByMail(),
    ),

    //Tablet root
    GoRoute(
      path: '/tablet-definir-pin',
      builder: (context, state) => const TabletDefinirPin(),
    ),
    GoRoute(
      path: '/tablet-first-screen',
      builder: (context, state) => const TabletFirstScreen(),
    ),

  GoRoute(
      path: '/tablet-entree-pin',
      builder: (context, state) => const TabletEntrerPin(),
    ),

  GoRoute(
      path: '/tablet-verifier-compte',
      builder: (context, state) => const TabletVerifierCompte(),
    ),


  GoRoute(
      path: '/tablet-verifier-code-send',
      builder: (context, state) => const TabletVerifierCodeSendByMail(),
    ),

   // desktop root


   GoRoute(
      path: '/desktop-definir-pin',
      builder: (context, state) => const DesktopDefinirPin(),
    ),
    GoRoute(
      path: '/desktop-first-screen',
      builder: (context, state) => const DesktopFirstScreen(),
    ),

  GoRoute(
      path: '/desktop-entree-pin',
      builder: (context, state) => const DesktopEntrerPin(),
    ),

  GoRoute(
      path: '/desktop-verifier-compte',
      builder: (context, state) => const DesktopVerifierCompte(),
    ),


  GoRoute(
      path: '/desktop-verifier-code-send',
      builder: (context, state) => const DesktopVerifierCodeSendByMail(),
    ),

  ],
);
