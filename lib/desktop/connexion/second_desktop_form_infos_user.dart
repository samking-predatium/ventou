import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ventou/desktop/connexion/desktop_definir_pin.dart';
import 'package:ventou/functions/redimensionner_image.dart';
import 'package:ventou/variables/animations.dart';
import 'package:ventou/variables/colors.dart';
import 'package:ventou/variables/police.dart';

class SecondDesktopFormInfosUser extends StatefulWidget {
  final Map<String, String> userData;

  const SecondDesktopFormInfosUser({super.key, required this.userData});

  @override
  State<SecondDesktopFormInfosUser> createState() =>
      _SecondDesktopFormInfosUserState();
}

class _SecondDesktopFormInfosUserState
    extends State<SecondDesktopFormInfosUser> {
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
        dateError = null; // Réinitialiser l'erreur de la date
      });
    }
  }

  @override
  void initState() {
    super.initState();
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

  Future<void> _clearTemporaryFiles() async {
    final tempDir = Directory.systemTemp;
    final files = tempDir.listSync();
    for (var file in files) {
      if (file is File && file.path.contains('resized_image')) {
        try {
          await file.delete();
        } catch (e) {
          debugPrint('Erreur lors de la suppression du fichier: $e');
        }
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    await _checkAndRequestPermissions();

    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: source,
      );

      if (pickedFile != null) {
        // Créer un dossier permanent dans les documents de l'application
        final appDir =
            await getApplicationDocumentsDirectory(); // Ajoutez l'import: import 'package:path_provider/path_provider.dart';
        final imagesDir = Directory('${appDir.path}/profile_images');
        if (!await imagesDir.exists()) {
          await imagesDir.create(recursive: true);
        }

        if (mounted) {
          final result = await showDialog<File>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ImageResizer(
                    key: UniqueKey(),
                    imageFile: File(pickedFile.path),
                    onImageResized: (File file) async {
                      // Copier le fichier redimensionné dans le dossier permanent
                      final timestamp = DateTime.now().millisecondsSinceEpoch;
                      final newPath =
                          '${imagesDir.path}/profile_$timestamp.jpg';
                      final newFile = await file.copy(newPath);
                      Navigator.of(context).pop(newFile);
                    },
                    defaultWidth: 200,
                    defaultHeight: 200,
                  ),
                ),
              );
            },
          );

          if (result != null && mounted) {
            setState(() {
              _imageFile = result;
              imageError = null;
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Erreur lors de la sélection de l\'image : $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la sélection de l\'image : $e'),
          ),
        );
      }
    }
  }

  void _validateAndFinish() async {
    setState(() {
      communeError = validateCommune(commune.text);
      quartierError = validateQuartier(quartier.text);
      dateError = validateDate(dateController.text);
      imageError = validateImage();
    });

    if (communeError == null &&
        quartierError == null &&
        dateError == null &&
        imageError == null) {
      try {
        // Obtenir l'utilisateur actuellement connecté
        User? currentUser = FirebaseAuth.instance.currentUser;

        if (currentUser != null) {
          // Référence au document de l'utilisateur
          DocumentReference userRef = FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid);

          // Si vous avez une image, la télécharger d'abord
          String? imageUrl;
          if (_imageFile != null) {
            final storageRef = FirebaseStorage.instance
                .ref()
                .child('profile_pictures/${currentUser.uid}');
            await storageRef.putFile(_imageFile!);
            imageUrl = await storageRef.getDownloadURL();
          }

          // Mettre à jour le document utilisateur
          await userRef.update({
            ...widget.userData,
            'commune': commune.text,
            'quartier': quartier.text,
            'dateNaissance': birthDate,
            if (imageUrl != null) 'photoUrl': imageUrl,
          });

          if (mounted) {
            // Redirection directe vers l'écran de définition du PIN
            Navigator.pushReplacement(
              context,
              SlidePageRoute(
                page: DesktopDefinirPin(),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors de la mise à jour : $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 1024;
    return Scaffold(
      backgroundColor: AppColors.blanc,
      appBar: AppBar(
        backgroundColor: AppColors.blanc,
        foregroundColor: AppColors.orange,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 30, bottom: 30),
              child: Form(
                child: Container(
                  height: 670,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 1)),
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
                        "Finalisons votre profil",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: isSmallScreen ? 30 : 38,
                          color: AppColors.blue,
                          fontFamily: AppsFont.font3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
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
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: GestureDetector(
                                          onTap: _showImageSourceDialog,
                                          child: Container(
                                            width: 190,
                                            height: 190,
                                            decoration: BoxDecoration(
                                              color: AppColors.blanc
                                                  .withOpacity(0.3),
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: ClipOval(
                                              child: _imageFile != null
                                                  ? Image.file(
                                                      _imageFile!,
                                                      key: ValueKey(
                                                          _imageFile!.path +
                                                              DateTime.now()
                                                                  .toString()),
                                                      fit: BoxFit.cover,
                                                      width: 120,
                                                      height: 120,
                                                    )
                                                  : const Icon(
                                                      Icons.camera_alt,
                                                      size: 40,
                                                      color: AppColors.orange,
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (imageError != null)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Text(
                                            imageError!,
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 12),
                                          ),
                                        ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        "Photo de profil",
                                        style: TextStyle(
                                          color: AppColors.blue,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 30),
                                        AnimatedOpacity(
                                          opacity: 1.0,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                  placeholder:
                                                      "Date de naissance",
                                                  readOnly: true,
                                                  onTap: _pickDate,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.blanc
                                                        .withOpacity(0.3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    border: dateError != null
                                                        ? Border.all(
                                                            color: Colors.red)
                                                        : null,
                                                  ),
                                                ),
                                              ),
                                              if (dateError != null)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5, left: 10),
                                                  child: Text(
                                                    dateError!,
                                                    style: const TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        AnimatedOpacity(
                                          opacity: 1.0,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 55,
                                                child: CupertinoTextField(
                                                  controller: commune,
                                                  prefix: const Row(
                                                    children: [
                                                      SizedBox(width: 10),
                                                      Icon(
                                                        Icons
                                                            .location_on_outlined,
                                                        color: AppColors.orange,
                                                      ),
                                                      SizedBox(width: 10),
                                                    ],
                                                  ),
                                                  placeholder: "Votre Commune",
                                                  decoration: BoxDecoration(
                                                    color: AppColors.blanc
                                                        .withOpacity(0.3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    border: communeError != null
                                                        ? Border.all(
                                                            color: Colors.red)
                                                        : null,
                                                  ),
                                                ),
                                              ),
                                              if (communeError != null)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5, left: 10),
                                                  child: Text(
                                                    communeError!,
                                                    style: const TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        AnimatedOpacity(
                                          opacity: 1.0,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 55,
                                                child: CupertinoTextField(
                                                  controller: quartier,
                                                  prefix: const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10, right: 10),
                                                    child: Icon(
                                                      Icons
                                                          .location_city_outlined,
                                                      color: AppColors.orange,
                                                    ),
                                                  ),
                                                  placeholder: "Votre Quartier",
                                                  decoration: BoxDecoration(
                                                    color: AppColors.blanc
                                                        .withOpacity(0.3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    border: quartierError !=
                                                            null
                                                        ? Border.all(
                                                            color: Colors.red)
                                                        : null,
                                                  ),
                                                ),
                                              ),
                                              if (quartierError != null)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5, left: 10),
                                                  child: Text(
                                                    quartierError!,
                                                    style: const TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ))
                              ],
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
      ),
    );
  }
}
