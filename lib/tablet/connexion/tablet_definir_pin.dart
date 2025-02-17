import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ventou/functions/crypt.dart';
import 'package:ventou/models/model_champs_otp.dart';
import 'package:ventou/variables/animations.dart';
import 'package:ventou/variables/colors.dart';

class TabletDefinirPin extends StatefulWidget {
  final Function(String)? onPinConfirmed;
  const TabletDefinirPin({super.key, this.onPinConfirmed});

  @override
  State<TabletDefinirPin> createState() => _TabletDefinirPinState();
}

class _TabletDefinirPinState extends State<TabletDefinirPin> {
  final EncryptionService _encryptionService = EncryptionService();
  String? _firstPin;
  String? _confirmPin;
  bool _showConfirmation = false;
  bool _hasError = false;
  String _errorMessage = '';
  int _confirmKeyCounter = 0;
  bool _isNavigating = false;

  Future<void> _saveEncryptedPin(String? pin) async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception('Aucun utilisateur connecté');

      // Utilisation du nouveau service de cryptage
      final String encryptedPin;
      if (pin != null && pin.isNotEmpty) {
        // Utilisation de la méthode encrypt du EncryptionService
        encryptedPin = await _encryptionService.encrypt(pin);
      } else {
        encryptedPin = '';
      }

      // Sauvegarder dans Firestore
      final parametresRef = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('parametres')
          .doc('security');

      await parametresRef.set({
        'pinState': pin != null && pin.isNotEmpty,
        'pin': encryptedPin,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint(
          'PIN ${pin != null && pin.isNotEmpty ? "enregistré" : "non défini"} avec succès.');
    } catch (e) {
      debugPrint('Erreur lors de la sauvegarde du PIN : $e');
      throw Exception('Erreur lors de l\'enregistrement du PIN.');
    }
  }

  void _handleFirstPinCompleted(String pin) {
    if (!mounted) return;
    if (pin.length == 4) {
      setState(() {
        _firstPin = pin;
        _showConfirmation = true;
        _hasError = false;
        _errorMessage = '';
        _confirmKeyCounter++;
        _confirmPin = null;
      });
    }
  }

  void _handleConfirmPinCompleted(String pin) {
    if (!mounted) return;
    setState(() {
      _confirmPin = pin;
      if (pin != _firstPin) {
        _hasError = true;
        _errorMessage = 'Les codes PIN ne correspondent pas';
        _confirmPin = null;
        _confirmKeyCounter++;
      } else {
        _hasError = false;
        _errorMessage = '';
      }
    });
  }

  Future<void> _handleContinue() async {
    if (!mounted) return;
    if (_firstPin == null || _confirmPin == null || _firstPin != _confirmPin)
      return;

    try {
      setState(() {
        _isNavigating = true;
      });

      // Sauvegarde sécurisée du PIN
      await _saveEncryptedPin(_firstPin!);

      widget.onPinConfirmed?.call(_firstPin!);

      await Future.delayed(const Duration(milliseconds: 100));

      if (!mounted) return;

      GoRouter.of(context).pushReplacement('/tablet-first-screen');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isNavigating = false;
        _hasError = true;
        _errorMessage =
            'Erreur lors de la sauvegarde ou navigation. Veuillez réessayer.';
      });
    }
  }

  Future<void> _resetPin() async {
    if (!mounted) return;

    try {
      setState(() {
        _isNavigating = true;
      });

      // Sauvegarde d'un PIN vide dans Firestore
      await _saveEncryptedPin(null);

      if (!mounted) return;

      // Redirection vers l'écran d'accueil
      GoRouter.of(context).pushReplacement('/tablet-first-screen');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isNavigating = true;
        _hasError = true;
        _errorMessage = 'Une erreur est survenue. Veuillez réessayer.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
        onWillPop: () async {
          if (_isNavigating) return false;
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: AppColors.blanc,
            foregroundColor: AppColors.orange,
          ),
          body: SafeArea(
            child: Center(
              child: Container(
                width: 400,
                height: 600,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 1)),
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
                      Column(
                        children: [
                          Text(
                            _showConfirmation
                                ? 'Confirmez votre code PIN'
                                : 'Sécurisez votre compte',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _showConfirmation
                                ? ''
                                : 'Définissez un code PIN à 4 chiffres\npour protéger votre compte',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      ModelChampsOtp(
                        key: ValueKey(_showConfirmation
                            ? 'confirm_pin_$_confirmKeyCounter'
                            : 'first_pin_$_confirmKeyCounter'),
                        length: 4,
                        fieldWidth: 60,
                        fieldHeight: 60,
                        fieldBackgroundColor: Colors.grey[100],
                        borderColor: Colors.grey[300]!,
                        focusedBorderColor: AppColors.orange,
                        textStyle: const TextStyle(fontSize: 24),
                        obscureText: true,
                        onCompleted: _showConfirmation
                            ? _handleConfirmPinCompleted
                            : _handleFirstPinCompleted,
                      ),
                      if (_hasError)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            _errorMessage,
                            style:
                                TextStyle(color: Colors.red[700], fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          SizedBox(
                            height: 120,
                          ),
                          if (_showConfirmation &&
                              _confirmPin != null &&
                              !_hasError)
                            ElevatedButton(
                              onPressed: _isNavigating ? null : _handleContinue,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.orange,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: _isNavigating
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text('CONFIRMER',
                                      style: TextStyle(color: Colors.white)),
                            ),
                          if (!_showConfirmation)
                            TextButton(
                              onPressed: _isNavigating ? null : _resetPin,
                              child: _isNavigating
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                AppColors.orange),
                                      ),
                                    )
                                  : const Text('PLUS TARD',
                                      style: TextStyle(
                                          color: AppColors.blue, fontSize: 18)),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
