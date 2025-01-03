import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ventou/tablet/connexion/second_tablet_form_infos_user.dart';
import 'package:ventou/variables/animations.dart';
import 'package:ventou/variables/colors.dart';
import 'package:ventou/variables/police.dart';

class FirestTabletFormInfosUser extends StatefulWidget {
  const FirestTabletFormInfosUser({super.key});

  @override
  State<FirestTabletFormInfosUser> createState() => _FirestTabletFormInfosUserState();
}

class _FirestTabletFormInfosUserState extends State<FirestTabletFormInfosUser> {
  
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomUser = TextEditingController();
  final TextEditingController prenomsUser = TextEditingController();
  final TextEditingController phoneUser = TextEditingController();
  bool acceptConditions = false;

  bool isHomme = false;
  bool isFemme = false;

  // Variables pour stocker les messages d'erreur
  String? nomError;
  String? prenomError;
  String? phoneError;
  String? genreError;
  String? conditionsError;

  @override
  void initState() {
    super.initState();
    // Ajouter les listeners pour la validation en temps réel
    nomUser.addListener(() {
      if (nomError != null) {
        setState(() {
          nomError = validateNom(nomUser.text);
        });
      }
    });

    prenomsUser.addListener(() {
      if (prenomError != null) {
        setState(() {
          prenomError = validatePrenom(prenomsUser.text);
        });
      }
    });

    phoneUser.addListener(() {
      if (phoneError != null) {
        setState(() {
          phoneError = validatePhone(phoneUser.text);
        });
      }
    });
  }

  @override
  void dispose() {
    nomUser.dispose();
    prenomsUser.dispose();
    phoneUser.dispose();
    super.dispose();
  }

  // Réinitialiser tous les messages d'erreur
  void _resetErrors() {
    setState(() {
      nomError = null;
      prenomError = null;
      phoneError = null;
      genreError = null;
      conditionsError = null;
    });
  }

  // Fonction de validation du nom
  String? validateNom(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le nom est obligatoire';
    }
    if (!RegExp(r'^[a-zA-ZÀ-ÿ\s-]+$').hasMatch(value)) {
      return 'Le nom ne doit contenir que des lettres';
    }
    if (value.length < 2) {
      return 'Le nom doit contenir au moins 2 caractères';
    }
    return null;
  }

  // Fonction de validation du prénom
  String? validatePrenom(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le prénom est obligatoire';
    }
    if (!RegExp(r'^[a-zA-ZÀ-ÿ\s-]+$').hasMatch(value)) {
      return 'Le prénom ne doit contenir que des lettres';
    }
    if (value.length < 2) {
      return 'Le prénom doit contenir au moins 2 caractères';
    }
    return null;
  }

  // Fonction de validation du numéro de téléphone
  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le numéro de téléphone est obligatoire';
    }
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Le numéro doit contenir 10 chiffres';
    }
    return null;
  }

  void _validateAndNavigate() {
    // Valider tous les champs
    setState(() {
      nomError = validateNom(nomUser.text);
      prenomError = validatePrenom(prenomsUser.text);
      phoneError = validatePhone(phoneUser.text);
      genreError =
          !isHomme && !isFemme ? 'Veuillez sélectionner votre genre' : null;
      conditionsError = !acceptConditions
          ? 'Veuillez accepter les conditions d\'utilisation'
          : null;
    });

    // Vérifier s'il y a des erreurs
    if (nomError == null &&
        prenomError == null &&
        phoneError == null &&
        genreError == null &&
        conditionsError == null) {
      // Si pas d'erreurs, procéder à la navigation
      Map<String, String> userData = {
        'nom': nomUser.text.trim(),
        'prenoms': prenomsUser.text.trim(),
        'telephone': phoneUser.text.trim(),
        'genre': isHomme ? 'Homme' : 'Femme',
      };

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecondTabletFormInfosUser(userData: userData),
        ),
      );
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
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Center(
              child: Form(
                key: _formKey,
                child: Container(
                  height: 730,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 1)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                        CustomAnimations.animateListTile(
                          Image.asset(
                            'images/logo.png',
                            height: size.height * 0.09,
                            fit: BoxFit.contain,
                          ),
                          0,
                        ),
                        const SizedBox(height: 40),
                      Text(
                        "Renseignez vos informations",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: isSmallScreen ? 30 : 38,
                          color: AppColors.blue,
                          fontFamily: AppsFont.font3,
                        ),
                      ),
                       const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(3),
                        width: 600,
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 55,
                                child: CupertinoTextField(
                                  controller: nomUser,
                                  onChanged: (value) {
                                    if (nomError != null) {
                                      setState(() {
                                        nomError = validateNom(value);
                                      });
                                    }
                                  },
                                  prefix: const Row(
                                    children: [
                                      SizedBox(width: 10),
                                      Icon(Icons.person_outline, color: AppColors.orange),
                                      SizedBox(width: 10),
                                    ],
                                  ),
                                  placeholder: "Votre nom",
                                  decoration: BoxDecoration(
                                    color: AppColors.blanc.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(15),
                                    border: nomError != null ? Border.all(color: Colors.red) : null,
                                  ),
                                ),
                              ),
                              if (nomError != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 5, left: 10),
                                  child: Text(
                                    nomError!,
                                    style: const TextStyle(color: Colors.red, fontSize: 12),
                                  ),
                                ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 55,
                                child: CupertinoTextField(
                                  controller: prenomsUser,
                                  onChanged: (value) {
                                    if (prenomError != null) {
                                      setState(() {
                                        prenomError = validatePrenom(value);
                                      });
                                    }
                                  },
                                  prefix: const Row(
                                    children: [
                                      SizedBox(width: 10),
                                      Icon(Icons.person_outlined, color: AppColors.orange),
                                      SizedBox(width: 10),
                                    ],
                                  ),
                                  placeholder: "Votre prénom",
                                  decoration: BoxDecoration(
                                    color: AppColors.blanc.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(15),
                                    border: prenomError != null ? Border.all(color: Colors.red) : null,
                                  ),
                                ),
                              ),
                              if (prenomError != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 5, left: 10),
                                  child: Text(
                                    prenomError!,
                                    style: const TextStyle(color: Colors.red, fontSize: 12),
                                  ),
                                ),
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: isHomme,
                                            onChanged: (value) {
                                              setState(() {
                                                isHomme = value!;
                                                if (value) isFemme = false;
                                                genreError = null;
                                              });
                                            },
                                            activeColor: AppColors.orange,
                                          ),
                                          const Text(
                                            "Homme",
                                            style: TextStyle(
                                              color: AppColors.blue,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 50),
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: isFemme,
                                            onChanged: (value) {
                                              setState(() {
                                                isFemme = value!;
                                                if (value) isHomme = false;
                                                genreError = null;
                                              });
                                            },
                                            activeColor: AppColors.orange,
                                          ),
                                          const Text(
                                            "Femme",
                                            style: TextStyle(
                                              color: AppColors.blue,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  if (genreError != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5, left: 10),
                                      child: Text(
                                        genreError!,
                                        style: const TextStyle(color: Colors.red, fontSize: 12),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 55,
                                child: CupertinoTextField(
                                  controller: phoneUser,
                                  onChanged: (value) {
                                    if (phoneError != null) {
                                      setState(() {
                                        phoneError = validatePhone(value);
                                      });
                                    }
                                  },
                                  prefix: const Row(
                                    children: [
                                      SizedBox(width: 10),
                                      Icon(Icons.phone_outlined, color: AppColors.orange),
                                      SizedBox(width: 10),
                                    ],
                                  ),
                                  placeholder: "Votre numéro de téléphone",
                                  keyboardType: TextInputType.phone,
                                  decoration: BoxDecoration(
                                    color: AppColors.blanc.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(15),
                                    border: phoneError != null ? Border.all(color: Colors.red) : null,
                                  ),
                                ),
                              ),
                              if (phoneError != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 5, left: 10),
                                  child: Text(
                                    phoneError!,
                                    style: const TextStyle(color: Colors.red, fontSize: 12),
                                  ),
                                ),
                              const SizedBox(height: 30),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: acceptConditions,
                                        onChanged: (value) {
                                          setState(() {
                                            acceptConditions = value!;
                                            conditionsError = null;
                                          });
                                        },
                                        activeColor: AppColors.orange,
                                      ),
                                      const Expanded(
                                        child: Text(
                                          "J'accepte les conditions d'utilisation",
                                          style: TextStyle(
                                            color: AppColors.orange,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (conditionsError != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5, left: 10),
                                      child: Text(
                                        conditionsError!,
                                        style: const TextStyle(color: Colors.red, fontSize: 12),
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
                                  onPressed: _validateAndNavigate,
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
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
