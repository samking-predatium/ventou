import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  String? _firstPin;
  String? _confirmPin;
  bool _showConfirmation = false;
  bool _hasError = false;
  String _errorMessage = '';
  int _confirmKeyCounter = 0;
  bool _isNavigating = false;

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

      // Appeler le callback avant la navigation
      widget.onPinConfirmed?.call(_firstPin!);

      // Attendre un court instant pour s'assurer que le setState est terminé
      await Future.delayed(const Duration(milliseconds: 100));

      if (!mounted) return;

      // Utiliser un BuildContext valide pour la navigation
      final navigator = GoRouter.of(context);
      navigator.push('/tablet-first-screen');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isNavigating = false;
        _hasError = true;
        _errorMessage = 'Erreur de navigation. Veuillez réessayer.';
      });
    }
  }

  void _resetPin() {
    if (!mounted) return;
    setState(() {
      _firstPin = null;
      _confirmPin = null;
      _showConfirmation = false;
      _hasError = false;
      _errorMessage = '';
      _confirmKeyCounter++;
      _isNavigating = false;
    });
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
                    if (!_showConfirmation) ...[
                      Column(
                        children: [
                          const Text(
                            'Définissez votre code PIN',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Choisissez un code PIN à 4 chiffres',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ModelChampsOtp(
                        key: ValueKey('first_pin_$_confirmKeyCounter'),
                        length: 4,
                        fieldWidth: 60,
                        fieldHeight: 60,
                        fieldBackgroundColor: Colors.grey[100],
                        borderColor: Colors.grey[300]!,
                        focusedBorderColor: AppColors.orange,
                        textStyle: const TextStyle(fontSize: 24),
                        obscureText: true,
                        onCompleted: _handleFirstPinCompleted,
                      ),
                    ] else ...[
                      Column(
                        children: [
                          const Text(
                            'Confirmez votre code PIN',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Saisissez à nouveau votre code PIN',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      ModelChampsOtp(
                        key: ValueKey('confirm_pin_$_confirmKeyCounter'),
                        length: 4,
                        fieldWidth: 60,
                        fieldHeight: 60,
                        fieldBackgroundColor: Colors.grey[100],
                        borderColor: Colors.grey[300]!,
                        focusedBorderColor: AppColors.orange,
                        textStyle: const TextStyle(fontSize: 24),
                        obscureText: true,
                        onCompleted: _handleConfirmPinCompleted,
                      ),
                    ],
                    if (_showConfirmation &&
                        _confirmPin != null &&
                        !_hasError) ...[
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _isNavigating ? null : _handleContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orange,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: _isNavigating
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Continuer',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ],
                    if (_hasError)
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
                    const SizedBox(height: 20),
                    if (!_isNavigating)
                      TextButton(
                        onPressed: _resetPin,
                        child: Text(
                          _showConfirmation ? 'Recommencer' : 'Réinitialiser',
                          style: const TextStyle(fontSize: 16),
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
