import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  Key? _key;
  IV? _iv;

  Future<Map<String, String>> _getKeys() async {
    // Retourner les clés en cache si disponibles
    if (_key != null && _iv != null) {
      return {'key': base64Encode(_key!.bytes), 'iv': base64Encode(_iv!.bytes)};
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Utilisateur non connecté');

    // Chercher dans Firestore
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('encryption_keys')
        .doc('keys')
        .get();

    if (doc.exists && doc.data()?['key'] != null && doc.data()?['iv'] != null) {
      _key = Key.fromBase64(doc.data()!['key']);
      _iv = IV.fromBase64(doc.data()!['iv']);
    } else {
      // Générer de nouvelles clés uniquement si elles n'existent pas
      _key = Key.fromSecureRandom(32);
      _iv = IV.fromSecureRandom(16);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('encryption_keys')
          .doc('keys')
          .set({
        'key': base64Encode(_key!.bytes),
        'iv': base64Encode(_iv!.bytes),
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return {'key': base64Encode(_key!.bytes), 'iv': base64Encode(_iv!.bytes)};
  }

  Future<String> encrypt(String data) async {
    final keys = await _getKeys();
    final encrypter = Encrypter(AES(Key.fromBase64(keys['key']!)));
    return encrypter.encrypt(data, iv: IV.fromBase64(keys['iv']!)).base64;
  }

  Future<String> decrypt(String encryptedData) async {
    final keys = await _getKeys();
    final encrypter = Encrypter(AES(Key.fromBase64(keys['key']!)));
    return encrypter.decrypt64(encryptedData, iv: IV.fromBase64(keys['iv']!));
  }

  Future<void> initializePinStorage() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Récupérer le document de sécurité de l'utilisateur
      final securityDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('parametres')
          .doc('security')
          .get();

      final data = securityDoc.data();
      if (data == null || !data.containsKey('pin')) return;

      // Récupérer le PIN crypté
      final encryptedPin = data['pin'] as String;

      // Déchiffrer le PIN
      final decryptedPin = await decrypt(encryptedPin);

      // Stocker localement
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_pin', decryptedPin);
    } catch (e) {
      print('Erreur lors de l\'initialisation du PIN : $e');
    }
  }

// Méthode pour vérifier le PIN localement
  Future<bool> verifyPin(String inputPin) async {
    final prefs = await SharedPreferences.getInstance();
    final storedPin = prefs.getString('user_pin');
    return inputPin == storedPin;
  }
}
