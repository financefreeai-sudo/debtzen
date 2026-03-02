import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// TOP CONTENT
                Column(
                  children: [
                    const SizedBox(height: 32),

                    // Logo
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.gold, Color(0xFFE8C96A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(
                        child: Text(
                          '₹',
                          style: GoogleFonts.manrope(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      'DEBTZEN',
                      style: GoogleFonts.manrope(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 4,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'From EMI Stress to Total Calm',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.5),
                        fontStyle: FontStyle.italic,
                      ),
                    ),

                    const SizedBox(height: 28),

                    /// FEATURE CARD
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Column(
                        children: [
                          FeatureRow(
                            emoji: '📊',
                            text: 'Track EMIs, Income & Investments',
                          ),
                          SizedBox(height: 12),
                          FeatureRow(
                            emoji: '🛡️',
                            text: 'Know your Financial Health Score',
                          ),
                          SizedBox(height: 12),
                          FeatureRow(
                            emoji: '🎯',
                            text: 'Plan your Freedom Number',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                /// BOTTOM SECTION
                Column(
                  children: [
                    /// TRUST BADGES
                    const Row(
                      children: [
                        TrustBadge(
                          emoji: '🔒',
                          line1: 'Private',
                          line2: '& Secure',
                        ),
                        SizedBox(width: 8),
                        TrustBadge(
                          emoji: '🏦',
                          line1: 'No Bank',
                          line2: 'Access',
                        ),
                        SizedBox(width: 8),
                        TrustBadge(
                          emoji: '🛡️',
                          line1: 'AES-256',
                          line2: 'Encrypted',
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    /// BUTTON
                    AppTheme.goldButton(
                      label: "Get Started — It's Free",
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// FEATURE ROW
class FeatureRow extends StatelessWidget {
  final String emoji;
  final String text;

  const FeatureRow({super.key, required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.78),
            ),
          ),
        ),
      ],
    );
  }
}

/// TRUST BADGE
class TrustBadge extends StatelessWidget {
  final String emoji;
  final String line1;
  final String line2;

  const TrustBadge({
    super.key,
    required this.emoji,
    required this.line1,
    required this.line2,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 4),
            Text(
              '$line1\n$line2',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 9,
                height: 1.4,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
