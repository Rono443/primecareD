import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthRemoteSource {
  // Graceful access to Firebase
  FirebaseAuth? get _auth {
    try {
      return FirebaseAuth.instance;
    } catch (e) {
      return null;
    }
  }

  FirebaseFirestore? get _firestore {
    try {
      return FirebaseFirestore.instance;
    } catch (e) {
      return null;
    }
  }

  Stream<User?> get authStateChanges {
    final auth = _auth;
    if (auth == null) return Stream.value(null);
    return auth.authStateChanges();
  }

  Future<UserModel?> login(String email, String password) async {
    final cleanEmail = email.trim().toLowerCase();
    
    // DEMO MODE: Bypass Firebase for testing
    if (cleanEmail.contains('@pc.com') || cleanEmail.contains('@gmail.com')) {
      final role = cleanEmail.startsWith('admin') ? UserRole.superAdmin : 
                   cleanEmail.startsWith('staff') ? UserRole.laundryStaff :
                   cleanEmail.startsWith('rider') ? UserRole.deliveryRider : UserRole.customer;
      
      return UserModel(
        id: 'demo-uid',
        email: cleanEmail,
        name: 'Demo User',
        role: role,
      );
    }

    final auth = _auth;
    if (auth == null) throw Exception('Firebase not configured. Use a demo email (@pc.com or @gmail.com) to login.');

    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );
      if (credential.user != null) {
        return await getUserData(credential.user!.uid);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<UserModel?> register(String email, String password, String name, UserRole role) async {
    final cleanEmail = email.trim().toLowerCase();

    // DEMO MODE: Bypass Firebase for testing
    if (cleanEmail.contains('@pc.com') || cleanEmail.contains('@gmail.com')) {
      return UserModel(
        id: 'demo-uid-${DateTime.now().millisecondsSinceEpoch}',
        email: cleanEmail,
        name: name,
        role: role,
      );
    }

    final auth = _auth;
    if (auth == null) throw Exception('Firebase not configured. Use a demo email (@pc.com or @gmail.com) to register.');

    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );
      if (credential.user != null) {
        final user = UserModel(
          id: credential.user!.uid,
          email: cleanEmail,
          name: name,
          role: role,
        );
        final firestore = _firestore;
        if (firestore != null) {
          await firestore.collection('users').doc(user.id).set(user.toMap());
        }
        return user;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<UserModel?> getUserData(String uid) async {
    if (uid.startsWith('demo-uid')) return null;
    
    final firestore = _firestore;
    if (firestore == null) return null;

    try {
      final doc = await firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
    return null;
  }

  Future<void> logout() async {
    try {
      await _auth?.signOut();
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }
}
