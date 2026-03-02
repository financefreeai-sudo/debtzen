import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme.dart';
import 'quick_setup_screen.dart';
import 'main_navigation.dart';

class OTPScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final String name;

  const OTPScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
    required this.name,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> _ctrl = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final AuthService _auth = AuthService();
  bool _loading = false;

  String get otp => _ctrl.map((c) => c.text).join();

  Future<void> verify() async {
    if (otp.length != 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter all 6 digits')));
      return;
    }

    setState(() => _loading = true);

    final result = await _auth.verifyOTP(
      verificationId: widget.verificationId,
      smsCode: otp,
      name: widget.name,
      phoneNumber: widget.phoneNumber,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (result['success'] == true) {
      if (result['isNewUser'] == true) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const QuickSetupScreen()),
          (_) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => MainNavigation()),
          (_) => false,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['error'] ?? 'Verification failed'),
          backgroundColor: AppTheme.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.blue,
        title: const Text('Verify OTP', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Text(
              'OTP sent to +91 ${widget.phoneNumber}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 36),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (i) {
                return SizedBox(
                  width: 45,
                  child: TextField(
                    controller: _ctrl[i],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) {
                      if (v.isNotEmpty && i < 5) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                  ),
                );
              }),
            ),

            const SizedBox(height: 40),

            _loading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: verify,
                      child: const Text('Verify & Continue'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
