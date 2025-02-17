import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ventou/functions/crypt.dart';
import 'package:ventou/models/model_champs_otp.dart';
import 'package:ventou/phone/phone_first_screen.dart';
import 'package:ventou/variables/animations.dart';
import 'package:ventou/variables/colors.dart';

class PhoneEntrerPin extends StatefulWidget {
  const PhoneEntrerPin({super.key});

  @override
  State<PhoneEntrerPin> createState() => _PhoneEntrerPinState();
}

class _PhoneEntrerPinState extends State<PhoneEntrerPin> {
  String? _enteredPin;
  bool _hasError = false;
  String _errorMessage = '';
  int _pinAttempts = 0;
  bool _isProcessing = false;
  final _encryptionService = EncryptionService();

  Future<void> _handlePinCompleted(String pin) async {
    if (!mounted) return;

    setState(() {
      _isProcessing = true;
      _enteredPin = pin;
    });

    try {
      debugPrint('Tentative de vérification du PIN: ${pin.length} chiffres');
      bool isPinValid = await _verifyPin(pin);
      debugPrint('Résultat de la vérification: $isPinValid');

      if (isPinValid) {
        if (mounted) {
          setState(() {
            _isProcessing = false;
          });

          // Correction de la navigation
          if (context.mounted) {
            // Option 1: Utiliser push au lieu de pushReplacement
            await Navigator.push(
              context,
              SlidePageRoute(page: PhoneFirstScreen()),
            );
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _hasError = true;
            _errorMessage = 'Code PIN incorrect';
            _enteredPin = null;
            _pinAttempts++;
            _isProcessing = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Erreur dans _handlePinCompleted: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Une erreur est survenue. Veuillez réessayer.';
          _isProcessing = false;
        });
      }
    }
  }

  Future<bool> _verifyPin(String pin) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint('Erreur: Utilisateur non connecté');
        return false;
      }

      debugPrint('Récupération du document de sécurité...');
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('parametres')
          .doc('security')
          .get();

      final data = userDoc.data();
      if (data == null) {
        debugPrint('Erreur: Document de sécurité non trouvé');
        return false;
      }

      if (!data.containsKey('pin') || data['pin'].isEmpty) {
        debugPrint('Erreur: PIN non défini dans le document');
        return false;
      }

      final encryptedPin = data['pin'] as String;
      debugPrint('PIN crypté récupéré, longueur: ${encryptedPin.length}');

      final decryptedPin = await _encryptionService.decrypt(encryptedPin);
      debugPrint('PIN décrypté, longueur: ${decryptedPin.length}');

      // Comparaison sécurisée avec logging
      final isMatch = decryptedPin == pin;
      debugPrint(
          'Comparaison PIN: ${pin.length} chiffres vs ${decryptedPin.length} chiffres');
      debugPrint('Résultat de la comparaison: $isMatch');

      return isMatch;
    } catch (e) {
      debugPrint('Erreur détaillée lors de la vérification du PIN: $e');
      if (e.toString().contains('decrypt')) {
        debugPrint('Erreur spécifique au décryptage détectée');
      }
      return false;
    }
  }

  void _resetPin() {
    if (!mounted) return;
    setState(() {
      _enteredPin = null;
      _hasError = false;
      _errorMessage = '';
      _pinAttempts++;
      _isProcessing = false;
    });
  }

  // Méthode de debug pour vérifier le PIN stocké
  Future<void> _debugStoredPin() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('parametres')
          .doc('security')
          .get();

      final data = doc.data();
      if (data != null) {
        debugPrint('État du PIN: ${data['pinState']}');
        debugPrint('PIN crypté existe: ${data.containsKey('pin')}');
        if (data.containsKey('pin')) {
          debugPrint('Longueur du PIN crypté: ${data['pin'].length}');
        }
      }
    } catch (e) {
      debugPrint('Erreur debug PIN: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.blanc,
        foregroundColor: AppColors.orange,
        leading: _isProcessing
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
      ),
      body: WillPopScope(
        onWillPop: () async => !_isProcessing,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomAnimations.animateListTile(
                    Center(
                      child: Image.asset(
                        'images/logo.png',
                        height: size.height * 0.08,
                        fit: BoxFit.contain,
                      ),
                    ),
                    0,
                  ),
                  const SizedBox(height: 80),
                  Column(
                    children: [
                      const Text(
                        'Entrez votre code PIN',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.blue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Saisissez votre code PIN à 4 chiffres',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ModelChampsOtp(
                    key: ValueKey('pin_input_$_pinAttempts'),
                    length: 4,
                    fieldWidth: 60,
                    fieldHeight: 60,
                    fieldBackgroundColor: Colors.grey[100],
                    borderColor: Colors.grey[300]!,
                    focusedBorderColor: AppColors.orange,
                    textStyle: const TextStyle(fontSize: 24),
                    obscureText: true,
                    onCompleted: _handlePinCompleted,
                  ),
                  if (_hasError) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red[700]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _errorMessage,
                              style: TextStyle(
                                color: Colors.red[700],
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 100),
                  if (!_isProcessing) ...[
                    TextButton(
                      onPressed: _resetPin,
                      child: const Text(
                        'Réinitialiser',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        final navigator = GoRouter.of(context);
                        navigator.push('/verifier-compte');
                      },
                      child: const Text(
                        'Code pin oublié ?',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.orange,
                        ),
                      ),
                    ),
                  ],
                  if (_isProcessing)
                    const CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.orange),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
