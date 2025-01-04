import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Déclencher le flux d'authentification Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return null;

      // Obtenir les détails d'authentification
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      // Créer un nouvel identifiant
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Une fois connecté, retourner l'UserCredential
      final userCredential = await _auth.signInWithCredential(credential);
      
      // Vérifier et créer/mettre à jour le document utilisateur
      if (userCredential.user != null) {
        await _handleUserFirestore(userCredential.user!);
      }

      return userCredential;
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la connexion Google: $e');
      }
      return null;
    }
  }

  // Nouvelle méthode pour gérer le document utilisateur
  Future<void> _handleUserFirestore(User user) async {
    try {
      final userDocRef = _firestore.collection('users').doc(user.uid);
      final userDoc = await userDocRef.get();

      if (!userDoc.exists) {
        // Création d'un nouveau document si l'utilisateur n'existe pas
        await userDocRef.set({
          'email': user.email,
          'uid': user.uid,
          'dateInscription': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        });
        if (kDebugMode) {
          print('Nouveau document utilisateur créé');
        }
      } else {
        // Mise à jour de la dernière connexion si l'utilisateur existe
        await userDocRef.update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
        if (kDebugMode) {
          print('Document utilisateur mis à jour');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la gestion du document utilisateur: $e');
      }
      throw Exception('Erreur lors de la gestion du document utilisateur');
    }
  }

  // Méthode utilitaire pour vérifier si un utilisateur existe dans Firestore
  Future<bool> checkUserExists(String uid) async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();
      return userDoc.exists;
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la vérification de l\'utilisateur: $e');
      }
      return false;
    }
  }
}



// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   Future<UserCredential?> signInWithGoogle() async {
//     try {
//       // Déclencher le flux d'authentification Google
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

//       if (googleUser == null) return null;

//       // Obtenir les détails d'authentification
//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;

//       // Créer un nouvel identifiant
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       // Une fois connecté, retourner l'UserCredential
//       return await _auth.signInWithCredential(credential);
//     } catch (e) {
//       if (kDebugMode) {
//         print('Erreur lors de la connexion Google: $e');
//       }
//       return null;
//     }
//   }
// }
