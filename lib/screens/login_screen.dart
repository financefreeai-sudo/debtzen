import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  final AuthService _auth = AuthService();
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> sendOTP() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    await _auth.sendOTP(
      phoneNumber: _phoneCtrl.text.trim(),
      onCodeSent: (verificationId) {
        if (!mounted) return;
        setState(() => _loading = false);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OTPScreen(
              verificationId: verificationId,
              phoneNumber: _phoneCtrl.text.trim(),
              name: _nameCtrl.text.trim(),
            ),
          ),
        );
      },
      onError: (error) {
        if (!mounted) return;
        setState(() => _loading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppTheme.red),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.blue,
        title: const Text('Sign In', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                const Text(
                  'Welcome to DebtZen',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.blue,
                  ),
                ),

                const SizedBox(height: 36),

                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Name is required' : null,
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Mobile Number',
                    prefixText: '+91 ',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Phone number is required';
                    }
                    if (v.length != 10) {
                      return 'Enter valid 10-digit number';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 36),

                _loading
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: sendOTP,
                          child: const Text('Send OTP'),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
