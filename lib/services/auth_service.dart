import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => _auth.currentUser != null;

  // =========================
  // SEND OTP
  // =========================
  Future<void> sendOTP({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',
        timeout: const Duration(seconds: 60),

        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },

        verificationFailed: (FirebaseAuthException e) {
          print("🔥 Firebase Error Code: ${e.code}");
          print("🔥 Firebase Error Message: ${e.message}");

          onError("Error: ${e.code}");
        },

        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },

        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      onError('Something went wrong. Please try again.');
    }
  }

  // =========================
  // VERIFY OTP
  // =========================
  Future<Map<String, dynamic>> verifyOTP({
    required String verificationId,
    required String smsCode,
    required String name,
    required String phoneNumber,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final result = await _auth.signInWithCredential(credential);
      final user = result.user;

      if (user == null) {
        return {'success': false, 'error': 'Authentication failed.'};
      }

      final doc = await _db.collection('users').doc(user.uid).get();
      final bool isNewUser = !doc.exists;

      if (isNewUser) {
        await _db.collection('users').doc(user.uid).set({
          'name': name,
          'phone': '+91$phoneNumber',
          'createdAt': FieldValue.serverTimestamp(),
          'isPro': false,
          'setupComplete': false,
          'totalMonthlyIncome': 0.0,
          'totalMonthlyEMI': 0.0,
          'totalMonthlyExpenses': 0.0,
          'totalOutstandingDebt': 0.0,
          'totalInvestments': 0.0,
          'totalAssets': 0.0,
          'emergencyFundAmount': 0.0,
          'hasHealthInsurance': false,
          'hasTermInsurance': false,
        });
      }

      return {'success': true, 'isNewUser': isNewUser};
    } on FirebaseAuthException catch (e) {
      String msg = 'Incorrect OTP.';

      if (e.code == 'session-expired') {
        msg = 'OTP expired. Please request again.';
      } else if (e.code == 'invalid-verification-code') {
        msg = 'Invalid OTP.';
      }

      return {'success': false, 'error': msg};
    } catch (e) {
      return {'success': false, 'error': 'Something went wrong.'};
    }
  }

  // =========================
  // SIGN OUT
  // =========================
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
