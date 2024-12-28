import 'package:flutter/material.dart';
import 'package:ventou/authentification/google_auth.dart';
import 'package:ventou/page/bar_de_navigation/navigation.dart';

class PhoneLoginScreen extends StatelessWidget {
  const PhoneLoginScreen({super.key});

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    final authService = AuthService();

    try {
      final userCredential = await authService.signInWithGoogle();

      if (userCredential != null && context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VentouMainScreen(),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de la connexion'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                // Ventou Logo
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                  child: Image.asset(
                    'images/logo.png',
                    height: size.height * 0.08,
                    fit: BoxFit.contain,
                  ),
                ),

                // Garage Sale Illustration
                Container(
                  height: isSmallScreen ? size.height * 0.4 : size.height * 0.5,
                  padding: EdgeInsets.all(size.width * 0.05),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Image.asset(
                            'images/img.jpg',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: size.height * 0.02),

                Text(
                  'Bienvenue',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 28 : 32,
                    color: const Color(0xFF000080),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: size.height * 0.02),

                Text(
                  'Lorem ipsum Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonumkfkvjfrk kjkrjkbjkjbkbkjb cing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: isSmallScreen ? 12 : 14,
                  ),
                ),

                SizedBox(height: size.height * 0.04),

                ElevatedButton(
                  onPressed: () => _handleGoogleSignIn(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF4A460),
                    minimumSize: Size(double.infinity, size.height * 0.06),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/google.png',
                        height: size.height * 0.03,
                        width: size.height * 0.03,
                      ),
                      SizedBox(width: size.width * 0.02),
                      Text(
                        'Continuer avec Google',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: size.height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
