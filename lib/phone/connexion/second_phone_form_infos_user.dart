import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ventou/phone/phone_first_screen.dart';
import 'package:ventou/variables/colors.dart';
import 'package:ventou/variables/police.dart'; // Ajout pour la gestion des permissions

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

  Future<void> _checkAndRequestPermissions() async {
    if (Platform.isIOS || Platform.isAndroid) {
      final status = await Permission.photos.request();
      if (status.isDenied) {
        // Gérer le cas où l'utilisateur refuse la permission
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Permission d\'accès aux photos requise')),
        );
      }
    }
  }

  void _enrisgrerInscription() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PhoneFirstScreen(),
      ),
    );
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
              const SizedBox(
                height: 30,
              ),
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
                leading: const Icon(
                  Icons.camera_alt,
                  color: AppColors.orange,
                ),
                title: const Text('Prendre une photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(
                    ImageSource.camera,
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: AppColors.blue,
                ),
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
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sélection de l\'image: $e')),
      );
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
            colorScheme: const ColorScheme.light(
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 768;

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
                    const SizedBox(
                      height: 70,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: Text(
                        "Finalisons votre profil",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: isSmallScreen ? 26 : 34,
                          color: AppColors.blue,
                          fontFamily: AppsFont.font3,
                        ),
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
                            // ignore: deprecated_member_use
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
                                color: Colors.grey[200],
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
                          const SizedBox(height: 10),
                          const Text(
                            "Photo de profil",
                            style: TextStyle(
                              color: AppColors.blue,
                              fontSize: 16,
                            ),
                          ),
                          // Reste du code inchangé...
                          const SizedBox(height: 30),
                          AnimatedOpacity(
                            opacity: 1.0,
                            duration: const Duration(milliseconds: 500),
                            child: SizedBox(
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
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          AnimatedOpacity(
                            opacity: 1.0,
                            duration: const Duration(milliseconds: 500),
                            child: SizedBox(
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
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          AnimatedOpacity(
                            opacity: 1.0,
                            duration: const Duration(milliseconds: 500),
                            child: SizedBox(
                              height: 55,
                              child: CupertinoTextField(
                                controller: quartier,
                                prefix: const Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.location_city_outlined,
                                      color: AppColors.orange,
                                    ),
                                    SizedBox(width: 10),
                                  ],
                                ),
                                placeholder: "Votre Quartier",
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
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
                                onPressed: _enrisgrerInscription,
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
