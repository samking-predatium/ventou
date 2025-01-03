import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ventou/phone/phone_first_screen.dart';
import 'package:ventou/variables/colors.dart';
import 'package:ventou/variables/police.dart';

class SecondPhoneFormInfosUser extends StatefulWidget {
  final Map<String, String> userData;
  const SecondPhoneFormInfosUser({super.key, required this.userData});

  @override
  State<SecondPhoneFormInfosUser> createState() =>
      _SecondPhoneFormInfosUserState();
}

class _SecondPhoneFormInfosUserState extends State<SecondPhoneFormInfosUser> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController commune = TextEditingController();
  final TextEditingController quartier = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  File? _imageFile;
  String birthDate = '';

  // Variables pour stocker les messages d'erreur
  String? communeError;
  String? quartierError;
  String? dateError;
  String? imageError;

  @override
  void initState() {
    super.initState();
    // Ajouter les listeners pour la validation en temps réel
     commune.addListener(() {
    setState(() {
      if (commune.text.isNotEmpty) {
        communeError = null;
      } else if (communeError != null) {
        communeError = validateCommune(commune.text);
      }
    });
  });

  quartier.addListener(() {
    setState(() {
      if (quartier.text.isNotEmpty) {
        quartierError = null;
      } else if (quartierError != null) {
        quartierError = validateQuartier(quartier.text);
      }
    });
  });

    dateController.addListener(() {
      if (dateError != null) {
        setState(() {
          dateError = validateDate(dateController.text);
        });
      }
    });
  }

  @override
  void dispose() {
    commune.dispose();
    quartier.dispose();
    dateController.dispose();
    super.dispose();
  }

  // Réinitialiser tous les messages d'erreur
  void _resetErrors() {
    setState(() {
      communeError = null;
      quartierError = null;
      dateError = null;
      imageError = null;
    });
  }

  // Fonctions de validation
  String? validateCommune(String? value) {
    if (value == null || value.isEmpty) {
      return 'La commune est obligatoire';
    }
    if (value.length < 2) {
      return 'La commune doit contenir au moins 2 caractères';
    }
    return null;
  }

  String? validateQuartier(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le quartier est obligatoire';
    }
    if (value.length < 2) {
      return 'Le quartier doit contenir au moins 2 caractères';
    }
    return null;
  }

  String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'La date de naissance est obligatoire';
    }
    return null;
  }

  String? validateImage() {
    if (_imageFile == null) {
      return 'Une photo de profil est requise';
    }
    return null;
  }

  Future<void> _checkAndRequestPermissions() async {
    if (Platform.isIOS || Platform.isAndroid) {
      final status = await Permission.photos.request();
      if (status.isDenied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Permission d\'accès aux photos requise')),
          );
        }
      }
    }
  }

  void _validateAndFinish() {
    // Valider tous les champs
    setState(() {
      communeError = validateCommune(commune.text);
      quartierError = validateQuartier(quartier.text);
      dateError = validateDate(dateController.text);
      imageError = validateImage();
    });

    // Vérifier s'il y a des erreurs
    if (communeError == null &&
        quartierError == null &&
        dateError == null &&
        imageError == null) {
      // Si pas d'erreurs, procéder à l'enregistrement
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhoneFirstScreen(),
        ),
      );
    } else {
      // Afficher un message d'erreur général
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez corriger les erreurs dans le formulaire'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showImageSourceDialog() async {
    if (Platform.isIOS) {
      return showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
              child: const Text('Prendre une photo'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
              child: const Text('Choisir depuis la galerie'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
        ),
      );
    } else {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Column(
            children: [
              Image.asset(
                'images/logo.png',
                height: 40,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  'Sélectionner une image',
                  style: TextStyle(color: AppColors.orange, fontSize: 20),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.orange),
                title: const Text('Prendre une photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.blue),
                title: const Text('Choisir depuis la galerie'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    await _checkAndRequestPermissions();

    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          imageError = null; // Réinitialiser l'erreur de l'image
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erreur lors de la sélection de l\'image: $e')),
        );
      }
    }
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.orange,
              onPrimary: Colors.white,
              onSurface: AppColors.blue,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        birthDate = DateFormat('dd-MM-yyyy').format(pickedDate);
        dateController.text = birthDate;
        dateError = null; // Réinitialiser l'erreur de la date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 500;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5, top: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 70),
                    Text(
                      "Finalisons votre profil",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: isSmallScreen ? 26 : 34,
                        color: AppColors.blue,
                        fontFamily: AppsFont.font3,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      width: isSmallScreen ? size.width * 0.9 : size.width * 1,
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
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: _showImageSourceDialog,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: AppColors.blanc.withOpacity(0.3),
                                shape: BoxShape.circle,
                                image: _imageFile != null
                                    ? DecorationImage(
                                        image: FileImage(_imageFile!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: _imageFile == null
                                  ? const Icon(
                                      Icons.camera_alt,
                                      size: 40,
                                      color: AppColors.orange,
                                    )
                                  : null,
                            ),
                          ),
                          if (imageError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                imageError!,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 12),
                              ),
                            ),
                          const SizedBox(height: 10),
                          const Text(
                            "Photo de profil",
                            style: TextStyle(
                              color: AppColors.blue,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 30),
                          AnimatedOpacity(
                            opacity: 1.0,
                            duration: const Duration(milliseconds: 500),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 55,
                                  child: CupertinoTextField(
                                    controller: dateController,
                                    prefix: const Row(
                                      children: [
                                        SizedBox(width: 10),
                                        Icon(
                                          Icons.calendar_today,
                                          color: AppColors.orange,
                                        ),
                                        SizedBox(width: 10),
                                      ],
                                    ),
                                    placeholder: "Date de naissance",
                                    readOnly: true,
                                    onTap: _pickDate,
                                    decoration: BoxDecoration(
                                      color: AppColors.blanc.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(15),
                                      border: dateError != null
                                          ? Border.all(color: Colors.red)
                                          : null,
                                    ),
                                  ),
                                ),
                                if (dateError != null)
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 5, left: 10),
                                    child: Text(
                                      dateError!,
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 12),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          AnimatedOpacity(
                            opacity: 1.0,
                            duration: const Duration(milliseconds: 500),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 55,
                                  child: CupertinoTextField(
                                    controller: commune,
                                    prefix: const Row(
                                      children: [
                                        SizedBox(width: 10),
                                        Icon(
                                          Icons.location_on_outlined,
                                          color: AppColors.orange,
                                        ),
                                        SizedBox(width: 10),
                                      ],
                                    ),
                                    placeholder: "Votre Commune",
                                    decoration: BoxDecoration(
                                      color: AppColors.blanc.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(15),
                                      border: communeError != null
                                          ? Border.all(color: Colors.red)
                                          : null,
                                    ),
                                  ),
                                ),
                                if (communeError != null)
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 5, left: 10),
                                    child: Text(
                                      communeError!,
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 12),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          AnimatedOpacity(
                            opacity: 1.0,
                            duration: const Duration(milliseconds: 500),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 55,
                                  child: CupertinoTextField(
                                    controller: quartier,
                                    prefix: const Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Icon(
                                        Icons.location_city_outlined,
                                        color: AppColors.orange,
                                      ),
                                    ),
                                    placeholder: "Votre Quartier",
                                    decoration: BoxDecoration(
                                      color: AppColors.blanc.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(15),
                                      border: quartierError != null
                                          ? Border.all(color: Colors.red)
                                          : null,
                                    ),
                                  ),
                                ),
                                if (quartierError != null)
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 5, left: 10),
                                    child: Text(
                                      quartierError!,
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 12),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          AnimatedOpacity(
                            opacity: 1.0,
                            duration: const Duration(milliseconds: 500),
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColors.orange,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: TextButton(
                                onPressed: _validateAndFinish,
                                child: const Text(
                                  'TERMINER',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
