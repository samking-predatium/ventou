import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ventou/variables/animations.dart';
import 'package:ventou/variables/colors.dart';

class VerifierCompte extends StatefulWidget {
  const VerifierCompte({super.key});

  @override
  State<VerifierCompte> createState() => _VerifierCompteState();
}

class _VerifierCompteState extends State<VerifierCompte> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  String? emailError;
  bool _isProcessing = false;
  bool _hasError = false;
  String _errorMessage = '';

  Future<void> _handleSubmit() async {
    if (!mounted) return;

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isProcessing = true;
      _hasError = false;
    });

    try {
      await _verifyEmail(_emailController.text);
// REDIRECTION VERS ECRAN DE VERIFICATION DE CODE SEND PAR MAIL
      final navigator = GoRouter.of(context);
      navigator.push('/verifier-code-send');
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Une erreur est survenue. Veuillez réessayer.';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _verifyEmail(String email) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Veuillez entrer votre adresse e-mail';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}\$').hasMatch(value)) {
      return 'Veuillez entrer une adresse e-mail valide';
    }
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
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
              child: Form(
                key: _formKey,
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
                      children: const [
                        Text(
                          'Vérification du compte',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blue,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Entrez votre adresse e-mail pour vérifier votre compte',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    CupertinoTextField(
                      controller: _emailController,
                      onChanged: (value) {
                        if (emailError != null) {
                          setState(() {
                            emailError = validateEmail(value);
                          });
                        }
                      },
                      prefix: const Row(
                        children: [
                          SizedBox(width: 10),
                          Icon(Icons.email_outlined, color: AppColors.orange),
                          SizedBox(width: 10),
                        ],
                      ),
                      placeholder: "Votre adresse e-mail",
                      keyboardType: TextInputType.emailAddress,
                      decoration: BoxDecoration(
                        color: AppColors.blanc.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15),
                        border: emailError != null
                            ? Border.all(color: Colors.red)
                            : null,
                      ),
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
                    const SizedBox(height: 40),
                    if (!_isProcessing)
                      ElevatedButton(
                        onPressed: _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orange,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 120,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Vérifier',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
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
      ),
    );
  }
}