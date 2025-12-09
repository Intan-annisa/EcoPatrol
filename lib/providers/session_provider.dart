import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/shared_prefs_service.dart';

class SessionNotifier extends StateNotifier<bool> {
  SessionNotifier() : super(false) {
    _loadSession();
  }

  void _loadSession() async {
    state = await SharedPrefsService.getLoginStatus();
  }

  void login() {
    state = true;
    SharedPrefsService.saveLoginStatus(true);
  }

  void logout() {
    state = false;
    SharedPrefsService.saveLoginStatus(false);
  }
}

final sessionProvider =
StateNotifierProvider<SessionNotifier, bool>((ref) => SessionNotifier());
