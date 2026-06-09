import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthRemoteSource {
  FirebaseAuth get _auth {
    try {
      return FirebaseAuth.instance;
    } catch (e) {
      throw Exception('Firebase Auth not initialized. Check your configuration.');
    }
  }

  FirebaseFirestore get _firestore {
    try {
      return FirebaseFirestore.instance;
    } catch (e) {
      throw Exception('Firestore not initialized. Check your configuration.');
    }
  }

  Stream<User?> get authStateChanges {
    try {
      return _auth.authStateChanges();
    } catch (e) {
      return Stream.value(null);
    }
  }

  Future<UserModel?> login(String email, String password) async {
    // Demo mode bypass
    if (email.endsWith('@pc.com') && password == 'password123') {
      final role = email.startsWith('admin') ? UserRole.superAdmin : 
                   email.startsWith('staff') ? UserRole.laundryStaff :
                   email.startsWith('rider') ? UserRole.deliveryRider : UserRole.customer;
      return UserModel(
        id: 'demo-uid',
        email: email,
        name: 'Demo User',
        role: role,
      );
    }

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
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
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        final user = UserModel(
          id: credential.user!.uid,
          email: email,
          name: name,
          role: role,
        );
        await _firestore.collection('users').doc(user.id).set(user.toMap());
        return user;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<UserModel?> getUserData(String uid) async {
    if (uid == 'demo-uid') return null; // Or return a mock user
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
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
      await _auth.signOut();
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }
}
