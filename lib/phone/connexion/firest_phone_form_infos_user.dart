import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ventou/phone/connexion/second_phone_form_infos_user.dart';
import 'package:ventou/variables/animations.dart';
import 'package:ventou/variables/colors.dart';
import 'package:ventou/variables/police.dart';

class FirestPhoneFormInfosUser extends StatefulWidget {
  const FirestPhoneFormInfosUser({super.key});

  @override
  State<FirestPhoneFormInfosUser> createState() =>
      _FirestPhoneFormInfosUserState();
}

class _FirestPhoneFormInfosUserState extends State<FirestPhoneFormInfosUser> {
  // ignore: unused_field
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomUser = TextEditingController();
  final TextEditingController prenomsUser = TextEditingController();
  final TextEditingController phoneUser = TextEditingController();
  bool acceptConditions = false;

  bool showPrenomField = false;
  bool showPhoneField = false;
  bool showSubmitButton = false;

  void _navigateToNextScreen() {
    if (nomUser.text.isNotEmpty &&
        prenomsUser.text.isNotEmpty &&
        phoneUser.text.isNotEmpty) {
      // Création d'un Map pour stocker les données
      Map<String, String> userData = {
        'nom': nomUser.text,
        'prenoms': prenomsUser.text,
        'telephone': phoneUser.text,
      };

      // Navigation vers le deuxième écran avec les données

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecondPhoneFormInfosUser(userData: userData),
        ),
      );
    } else {
      // Afficher un message d'erreur si tous les champs ne sont pas remplis
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('Veuillez remplir tous les champs')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // ignore: unused_local_variable
    final isSmallScreen = size.width < 768;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, top: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                CustomAnimations.animateListTile(
                  // Ventou Logo
                  Image.asset(
                    'images/logo.png',
                    height: size.height * 0.08,
                    fit: BoxFit.contain,
                  ),
                  0,
                ),
                const SizedBox(
                  height: 70,
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Text(
                    "Renseignez vos informations",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: isSmallScreen ? 26 : 34,
                        color: AppColors.blue,
                        fontFamily: AppsFont.font3),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 5, right: 1, left: 1),
                  width: isSmallScreen ? size.width * 0.9 : size.width * 1,
                  height: isSmallScreen ? size.height * 0.5 : size.height * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Dans la partie children du Column central, ajoute ceci :

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 55,
                              child: CupertinoTextField(
                                controller: nomUser,
                                prefix: const Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.person_outline,
                                      color: AppColors.orange,
                                    ),
                                    SizedBox(width: 10),
                                  ],
                                ),
                                placeholder: "Votre nom",
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 55,
                              child: CupertinoTextField(
                                controller: prenomsUser,
                                prefix: const Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.person_outlined,
                                      color: AppColors.orange,
                                    ),
                                    SizedBox(width: 10),
                                  ],
                                ),
                                placeholder: "Votre prénom",
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 55,
                              child: CupertinoTextField(
                                controller: phoneUser,
                                prefix: const Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.phone_outlined,
                                      color: AppColors.orange,
                                    ),
                                    SizedBox(width: 10),
                                  ],
                                ),
                                placeholder: "Votre numéro de téléphone",
                                keyboardType: TextInputType.phone,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              children: [
                                Checkbox(
                                  value: acceptConditions,
                                  onChanged: (value) {
                                    setState(() {
                                      acceptConditions = value!;
                                    });
                                  },
                                  activeColor: AppColors.orange,
                                ),
                                const Expanded(
                                  child: Text(
                                    "J'accepte les conditions d'utilisation",
                                    style: TextStyle(
                                      color: AppColors.blue,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColors.orange,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: TextButton(
                                onPressed: _navigateToNextScreen,
                                child: const Text(
                                  'CONTINUER',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
