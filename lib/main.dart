import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecopatrol_mobile/models/report_model.dart';

import 'providers/session_provider.dart';
import 'screens/login_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/form_report_screen.dart';
import 'screens/list_report_screen.dart';
import 'screens/detail_report_screen.dart';
import 'screens/edit_report_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(sessionProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "EcoPatrol",

      home: isLoggedIn
          ? ListReportScreen(reports: [])
          : const LoginScreen(),

      routes: {
        "/login": (_) => const LoginScreen(),
        "/settings": (_) => const SettingsScreen(),
        "/form": (_) => const FormReportScreen(),

        "/list": (_) => ListReportScreen(reports: []),
      },

      onGenerateRoute: (settings) {
        if (settings.name == "/detail") {
          final report = settings.arguments as ReportModel?;

          if (report == null) return null;

          return MaterialPageRoute(
            builder: (_) => DetailReportScreen(report: report),
          );
        }

        if (settings.name == "/edit") {
          final report = settings.arguments as ReportModel?;

          if (report == null) return null;

          return MaterialPageRoute(
            builder: (_) => EditReportScreen(report: report),
          );
        }

        return null;
      },
    );
  }
}
