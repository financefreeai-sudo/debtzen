import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  bool get isLoggedIn => _auth.currentUser != null;

  /// ===============================
  /// SEND OTP
  /// ===============================
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
          String msg = "Verification failed.";
          if (e.code == 'invalid-phone-number') {
            msg = "Invalid phone number format.";
          }
          if (e.code == 'too-many-requests') {
            msg = "Too many attempts. Try again later.";
          }
          onError(msg);
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      onError("No internet connection.");
    }
  }

  /// ===============================
  /// VERIFY OTP
  /// ===============================
  Future<Map<String, dynamic>> verifyOTP({
    required String verificationId,
    required String smsCode,
    required String name,
    required String phone,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final result = await _auth.signInWithCredential(credential);
      final user = result.user;

      if (user == null) {
        return {'success': false, 'error': 'Authentication failed'};
      }

      final doc = await _db.collection('users').doc(user.uid).get();

      if (!doc.exists) {
        await _db.collection('users').doc(user.uid).set({
          'name': name,
          'phone': '+91$phone',
          'createdAt': FieldValue.serverTimestamp(),
          'isPro': false,
          'setupComplete': false,
          'totalMonthlyIncome': 0,
          'totalMonthlyEMI': 0,
          'totalMonthlyExpenses': 0,
          'totalOutstandingDebt': 0,
          'totalInvestments': 0,
          'totalAssets': 0,
          'emergencyFundAmount': 0,
          'hasHealthInsurance': false,
          'hasTermInsurance': false,
        });

        return {'success': true, 'isNewUser': true};
      }

      return {'success': true, 'isNewUser': doc['setupComplete'] == false};
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        return {'success': false, 'error': 'Incorrect OTP'};
      }
      return {'success': false, 'error': 'Authentication error'};
    } catch (e) {
      return {'success': false, 'error': 'No internet connection'};
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
