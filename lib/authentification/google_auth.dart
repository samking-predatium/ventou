import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Initialise FirebaseAuth pour gérer l'authentification des utilisateurs.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Initialise Firestore pour interagir avec la base de données cloud NoSQL.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Configure Google Sign-In pour l'authentification via un compte Google.
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb
        ? '848704699189-811mt1fjnol0q6embd1br4ba9puac9rv.apps.googleusercontent.com'
        : null,
  );

  // Permet de surveiller les changements d'état d'authentification (connexion/déconnexion).
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Retourne l'utilisateur actuellement connecté, ou null si aucun utilisateur n'est connecté.
  User? get currentUser => _auth.currentUser;

  // Permet à un utilisateur de se connecter à l'application via Google.
  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      // Vérifie si un utilisateur est déjà connecté avant d'entamer une nouvelle connexion.
      if (_auth.currentUser != null) {
        await _updateLastLogin(_auth.currentUser!.uid);
        final isProfileComplete =
            await checkProfileComplete(_auth.currentUser!.uid);
        return {
          'user': _auth.currentUser,
          'isNewUser': false,
          'isProfileComplete': isProfileComplete,
        };
      }

      // Ouvre l'interface de connexion Google pour que l'utilisateur puisse s'authentifier.
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // Si l'utilisateur annule la connexion.
        return {'user': null, 'isNewUser': false, 'isProfileComplete': false};
      }

      // Récupère les jetons d'authentification pour Google afin de les utiliser avec Firebase.
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Crée les informations d'identification nécessaires pour lier Google à Firebase.
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Connecte l'utilisateur avec les informations d'identification Google dans Firebase.
      final userCredential = await _auth.signInWithCredential(credential);
      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

      if (userCredential.user != null) {
        // Gère les informations de l'utilisateur dans Firestore.
        await _handleUserFirestore(userCredential.user!, isNewUser);
        final isProfileComplete =
            await checkProfileComplete(userCredential.user!.uid);

        return {
          'user': userCredential.user,
          'isNewUser': isNewUser,
          'isProfileComplete': isProfileComplete,
        };
      }

      // Retourne une réponse par défaut si aucun utilisateur n'est connecté.
      return {'user': null, 'isNewUser': false, 'isProfileComplete': false};
    } catch (e) {
      // Affiche l'erreur si le mode débogage est activé.
      if (kDebugMode) print('Erreur lors de la connexion Google: $e');
      return {'user': null, 'isNewUser': false, 'isProfileComplete': false};
    }
  }

  // Ajoute ou met à jour les données utilisateur dans Firestore en fonction de leur statut (nouveau/existant).
  Future<void> _handleUserFirestore(User user, bool isNewUser) async {
    final userDocRef = _firestore.collection('users').doc(user.uid);

    try {
      if (isNewUser) {
        // Ajoute un nouveau document utilisateur dans la collection 'users'.
        await userDocRef.set({
          'email': user.email,
          'uid': user.uid,
          'dateInscription': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        });
      } else {
        // Met à jour la date de dernière connexion pour les utilisateurs existants.
        await _updateLastLogin(user.uid);
      }
    } catch (e) {
      // Affiche une erreur en cas d'échec de gestion des documents.
      if (kDebugMode) {
        print('Erreur lors de la gestion du document utilisateur: $e');
      }
      throw Exception('Erreur lors de la gestion du document utilisateur');
    }
  }

  // Vérifie si le profil de l'utilisateur contient les champs nécessaires et qu'ils ne sont pas vides.
  Future<bool> checkProfileComplete(String uid) async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();
      final data = userDoc.data();

      if (data == null) return false;

      // Liste des champs obligatoires pour considérer le profil comme complet.
      final requiredFields = ['nom', 'prenoms', 'telephone'];
      for (var field in requiredFields) {
        if (data[field] == null || (data[field] as String).isEmpty) {
          return false;
        }
      }

      return true;
    } catch (e) {
      // Affiche une erreur si la vérification échoue.
      if (kDebugMode) print('Erreur lors de la vérification du profil: $e');
      return false;
    }
  }

  // Met à jour le champ 'lastLogin' pour indiquer la dernière connexion de l'utilisateur.
  Future<void> _updateLastLogin(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Affiche une erreur si la mise à jour échoue.
      if (kDebugMode) {
        print('Erreur lors de la mise à jour de la dernière connexion: $e');
      }
      throw Exception('Erreur lors de la mise à jour de la dernière connexion');
    }
  }

  Future<bool> checkPinState(String uid) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('parametres')
          .doc('security')
          .get();

      final data = userDoc.data();
      if (data == null) return false;

      // Vérifie si le champ `pinState` est bien défini et retourne sa valeur
      return data['pinState'] as bool? ?? false;
    } catch (e) {
      if (kDebugMode) print('Erreur lors de la vérification du PIN : $e');
      return false;
    }
  }
}
