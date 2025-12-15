import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sessionProvider = AsyncNotifierProvider.autoDispose<SessionNotifier, bool>(
      () => SessionNotifier(),
);

class SessionNotifier extends AutoDisposeAsyncNotifier<bool> {
  late SharedPreferences _prefs;

  @override
  Future<bool> build() async {
    _prefs = await SharedPreferences.getInstance();
    final isLoggedIn = _prefs.getBool('isLoggedIn') ?? false;
    return isLoggedIn;
  }

  Future<void> login() async {
    await _prefs.setBool('isLoggedIn', true);
    state = const AsyncData(true);
  }

  Future<void> logout() async {
    await _prefs.setBool('isLoggedIn', false);
    state = const AsyncData(false);
  }
}