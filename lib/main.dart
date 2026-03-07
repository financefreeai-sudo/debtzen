import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'theme.dart';
import 'package:debtzen/screens/welcome_screen.dart';
import 'package:debtzen/providers/user_provider.dart';
import 'package:debtzen/main_navigation.dart'; // <-- ADDED

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: const DebtZenApp(),
    ),
  );
}

class DebtZenApp extends StatelessWidget {
  const DebtZenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DebtZen',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainNavigation(), // <-- CHANGED HERE
    );
  }
}
