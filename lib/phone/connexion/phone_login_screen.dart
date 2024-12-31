import 'package:flutter/material.dart';
import 'package:ventou/authentification/google_auth.dart';
import 'package:ventou/phone/connexion/firest_phone_form_infos_user.dart';
import 'package:ventou/phone/phone_first_screen.dart';
import 'package:ventou/variables/animations.dart';
import 'package:ventou/variables/colors.dart';

class PhoneLoginScreen extends StatelessWidget {
  const PhoneLoginScreen({super.key});

  // ignore: unused_element
  Future<void> _handleGoogleSignIn(BuildContext context) async {
    final authService = AuthService();

    try {
      final userCredential = await authService.signInWithGoogle();

      if (userCredential != null && context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PhoneFirstScreen(),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
                child: Text(
              'Erreur lors de la connexion',
              style: TextStyle(color: AppColors.blanc, fontSize: 14),
            )),
            backgroundColor: AppColors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 768;

    return Scaffold(
      backgroundColor: AppColors.blanc,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.02),

                  // Ventou Logo
                  Image.asset(
                    'images/logo.png',
                    height: size.height * 0.08,
                    fit: BoxFit.contain,
                  ),

                  SizedBox(height: size.height * 0.03),

                  CustomAnimations.animateListTile(
                    // Garage Sale Illustration
                    Container(
                      height:
                          isSmallScreen ? size.height * 0.4 : size.height * 0.5,
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

                  SizedBox(height: size.height * 0.03),

                  // Welcome Text
                  CustomAnimations.animateListTile(
                    Text(
                      'Bienvenue',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 36 : 48,
                        color: const Color(0xFF000080),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    1,
                  ),

                  SizedBox(height: size.height * 0.02),

                  // Subtitle Text
                  CustomAnimations.animateListTile(
                    Text(
                      'Vivez une expérience de vente en ligne hors du commun.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.blue,
                        fontSize: isSmallScreen ? 16 : 18,
                      ),
                    ),
                    2,
                  ),

                  SizedBox(height: size.height * 0.06),

                  // Subtitle Text
                  CustomAnimations.animateListTile(
                    // Google Sign-In Button
                    SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        // onPressed: () => _handleGoogleSignIn(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blanc,

                          // padding: EdgeInsets.symmetric( vertical: size.height * 0.03, horizontal: 20),
                          minimumSize: Size(10, size.height * 0.08),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: const BorderSide(
                                color: AppColors.orange, width: 2),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            FadePageRoute(
                              page: const FirestPhoneFormInfosUser(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'images/google.png',
                              height: size.height * 0.03,
                              width: size.height * 0.03,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Continuer avec Google',
                              style: TextStyle(
                                color: AppColors.orange,
                                fontSize: isSmallScreen ? 14 : 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    3,
                  ),

                  SizedBox(height: size.height * 0.03),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
