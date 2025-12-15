import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecopatrol_mobile/providers/session_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("EcoPatrol - Login", style: TextStyle(fontSize: 24)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                await ref.read(sessionProvider.notifier).login();
                if (!context.mounted) return;
                Navigator.pushReplacementNamed(context, '/');
              },
              child: const Text("Login sebagai Warga"),
            )
          ],
        ),
      ),
    );
  }
}