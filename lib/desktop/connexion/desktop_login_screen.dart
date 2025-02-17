import 'package:flutter/material.dart';
import 'package:ventou/authentification/google_auth.dart';
import 'package:ventou/desktop/connexion/firest_desktop_form_infos_user.dart';
import 'package:ventou/desktop/desktop_first_screen.dart';
import 'package:ventou/variables/animations.dart';
import 'package:ventou/variables/colors.dart';

class DesktopLoginScreen extends StatefulWidget {
  const DesktopLoginScreen({super.key});

  @override
  State<DesktopLoginScreen> createState() => _DesktopLoginScreenState();
}

class _DesktopLoginScreenState extends State<DesktopLoginScreen> {
   bool _isSigningIn = false;
 

  @override
  void initState() {
    super.initState();
  
  }

  
  // tablet_login_screen.dart (modification de la méthode _handleGoogleSignIn)
Future<void> _handleGoogleSignIn(BuildContext context) async {
  setState(() {
    _isSigningIn = true;
  });

  final authService = AuthService();

  try {
    final result = await authService.signInWithGoogle();

    if (result['user'] != null && context.mounted) {
      if (!result['isProfileComplete']) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const FirestDesktopFormInfosUser(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DesktopFirstScreen(),
          ),
        );
      }
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
            child: Text(
              'Erreur lors de la connexion',
              style: TextStyle(color: AppColors.blanc, fontSize: 18),
            ),
          ),
          backgroundColor: AppColors.red,
        ),
      );
    }
  } finally {
    setState(() {
      _isSigningIn = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 1024;
    return Scaffold(
      backgroundColor: AppColors.blanc,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomAnimations.animateListTile(
                        // Garage Sale Illustration
                        Container(
                          height: isSmallScreen
                              ? size.height * 0.6
                              : size.height * 0.8,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Image.asset(
                              'images/img.jpg',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        0,
                      ),
                    ],
                  )),
              Expanded(
                flex: 1,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/logo.png',
                          height: size.height * 0.1,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: size.height * 0.06),
                        CustomAnimations.animateListTile(
                          Text(
                            'Vivez une expérience de vente en ligne hors du commun.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.blue,
                              fontSize: isSmallScreen ? 24 : 30,
                            ),
                          ),
                          2,
                        ),
                        SizedBox(height: size.height * 0.08),
                        CustomAnimations.animateListTile(
                          SizedBox(
                            width: 400,
                            child: ElevatedButton(
                              onPressed: _isSigningIn
                                  ? null
                                  : () => _handleGoogleSignIn(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.blanc,
                                minimumSize: Size(10, size.height * 0.08),
                                foregroundColor: AppColors.orange,
                                surfaceTintColor: AppColors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: const BorderSide(
                                      color: AppColors.orange, width: 2),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_isSigningIn)
                                    const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        backgroundColor: AppColors.blanc,
                                        color: AppColors.orange,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                AppColors.orange),
                                        strokeWidth: 2,
                                      ),
                                    )
                                  else
                                    Image.asset(
                                      'images/google.png',
                                      height: size.height * 0.05,
                                      width: size.height * 0.05,
                                    ),
                                  const SizedBox(width: 10),
                                  Text(
                                    _isSigningIn
                                        ? 'Connexion.....'
                                        : 'Continuer avec Google',
                                    style: TextStyle(
                                      color: AppColors.orange,
                                      fontSize: isSmallScreen ? 22 : 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          3,
                        ),
                        SizedBox(height: size.height * 0.08),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
