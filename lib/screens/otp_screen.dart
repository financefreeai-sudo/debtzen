import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../services/auth_service.dart';
import '../theme.dart';
import 'quick_setup_screen.dart';
import 'main_navigation.dart';

class OTPScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const OTPScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen>
    with SingleTickerProviderStateMixin {
  final AuthService auth = AuthService();

  final List<TextEditingController> _ctrl = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final List<FocusNode> _focus = List.generate(6, (_) => FocusNode());

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  bool _loading = false;
  int _resendSeconds = 27;
  Timer? _timer;

  String get otp => _ctrl.map((c) => c.text).join();

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _shakeAnimation = Tween<double>(
      begin: 0,
      end: 12,
    ).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeController);

    startTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focus[0].requestFocus();
    });
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendSeconds == 0) {
        t.cancel();
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shakeController.dispose();
    for (final c in _ctrl) c.dispose();
    for (final f in _focus) f.dispose();
    super.dispose();
  }

  Future<void> verify() async {
    if (otp.length != 6) return;

    final userName = Provider.of<UserProvider>(
      context,
      listen: false,
    ).user.name;

    FocusScope.of(context).unfocus();
    setState(() => _loading = true);

    final result = await auth.verifyOTP(
      verificationId: widget.verificationId,
      smsCode: otp,
      name: userName,
      phone: widget.phoneNumber,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (result['success'] == true) {
      if (result['isNewUser'] == true) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => QuickSetupScreen(userName: userName),
          ),
          (_) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigation()),
          (_) => false,
        );
      }
    } else {
      _shakeController.forward(from: 0);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['error'] ?? "Verification failed"),
          backgroundColor: AppTheme.red,
        ),
      );

      for (final c in _ctrl) c.clear();
      _focus[0].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.navy, AppTheme.blue, AppTheme.navy],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Verify OTP",
                      style: GoogleFonts.manrope(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Code sent to +91 ${widget.phoneNumber}",
                      style: TextStyle(color: Colors.white.withOpacity(0.6)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.phone_android,
                        size: 36,
                        color: AppTheme.navy,
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        "Enter the 6-digit code below",
                        style: TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 28),

                      AnimatedBuilder(
                        animation: _shakeAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(_shakeAnimation.value, 0),
                            child: child,
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(6, (i) {
                            return SizedBox(
                              width: 48,
                              child: TextField(
                                controller: _ctrl[i],
                                focusNode: _focus[i],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                maxLength: 1,
                                decoration: InputDecoration(
                                  counterText: "",
                                  filled: true,
                                  fillColor: _ctrl[i].text.isNotEmpty
                                      ? AppTheme.navy.withOpacity(0.05)
                                      : Colors.grey.shade100,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: _ctrl[i].text.isNotEmpty
                                          ? AppTheme.navy
                                          : Colors.grey.shade300,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppTheme.navy,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                onChanged: (v) {
                                  if (v.isNotEmpty && i < 5) {
                                    _focus[i + 1].requestFocus();
                                  }

                                  if (otp.length == 6) {
                                    verify();
                                  }

                                  setState(() {});
                                },
                              ),
                            );
                          }),
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextButton(
                        onPressed: _resendSeconds == 0
                            ? () async {
                                setState(() => _resendSeconds = 27);
                                startTimer();

                                await auth.sendOTP(
                                  phoneNumber: widget.phoneNumber,
                                  onCodeSent: (verificationId) {},
                                  onError: (error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(error)),
                                    );
                                  },
                                );
                              }
                            : null,
                        child: Text(
                          _resendSeconds > 0
                              ? "Didn't receive? Resend in ${_resendSeconds}s"
                              : "Resend OTP",
                          style: TextStyle(
                            color: _resendSeconds > 0
                                ? Colors.grey
                                : AppTheme.navy,
                          ),
                        ),
                      ),

                      const Spacer(),

                      _loading
                          ? const CircularProgressIndicator()
                          : AnimatedScale(
                              scale: otp.length == 6 ? 1 : 0.98,
                              duration: const Duration(milliseconds: 200),
                              child: SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: otp.length == 6
                                        ? AppTheme.navy
                                        : Colors.grey.shade300,
                                    foregroundColor: otp.length == 6
                                        ? Colors.white
                                        : Colors.grey.shade600,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  onPressed: otp.length == 6 ? verify : null,
                                  child: const Text(
                                    "Verify & Continue",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
