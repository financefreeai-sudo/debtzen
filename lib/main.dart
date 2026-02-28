import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme.dart';
import 'package:debtzen/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const DebtZenApp());
}

class DebtZenApp extends StatelessWidget {
  const DebtZenApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DebtZen',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: WelcomeScreen(),
    );
  }
}
