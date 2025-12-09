import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init Database
  await DBHelper.init();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "EcoPatrol",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50), // Hijau biar cocok eco theme
        ),
        useMaterial3: true,
      ),

routes: {
  "/list": (_) => const ListReportScreen(),
}

      // Nanti diganti ke LoginScreen (Mahasiswa 1)
      home: const Scaffold(
        body: Center(
          child: Text(
            "EcoPatrol App",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}