import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lista delle email amministratori autorizzate
  static const List<String> _adminEmails = ['marco.mosco@gmail.com'];

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Verifica se l'utente è un amministratore
  bool isAdmin(String email) {
    return _adminEmails.contains(email);
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      // Verifica se l'email è di un amministratore
      if (isAdmin(email)) {
        return await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
      
      // Per gli utenti normali, verifica il dominio
      if (!email.endsWith('@mikai.it')) {
        throw 'Solo le email @mikai.it sono autorizzate';
      }

      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Register with email and password
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      // Verifica se l'email è di un amministratore
      if (isAdmin(email)) {
        UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        
        // Salva i dati dell'utente in Firestore
        await _firestore.collection('users').doc(result.user!.uid).set({
          'email': email,
          'isAdmin': true,
          'createdAt': FieldValue.serverTimestamp(),
        });
        
        return result;
      }
      
      // Per gli utenti normali, verifica il dominio
      if (!email.endsWith('@mikai.it')) {
        throw 'Solo le email @mikai.it sono autorizzate';
      }

      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      await _firestore.collection('users').doc(result.user!.uid).set({
        'email': email,
        'isAdmin': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return result;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }
} 