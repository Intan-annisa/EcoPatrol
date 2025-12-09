import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          // Profile Section
          Container(
            padding: const EdgeInsets.all(24),
            color: Colors.green.shade50,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.green.shade700,
                  child: const Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),
                FutureBuilder<String?>(
                  future: ref.read(authProvider.notifier).getUsername(),
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.data ?? 'User',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),
                const Text(
                  'Admin EcoPatrol',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          // Menu Items
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Tentang Aplikasi'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Tentang EcoPatrol'),
                  content: const Text(
                    'EcoPatrol v1.0\n\n'
                        'Aplikasi Pemantauan Lingkungan & Sampah Liar\n\n'
                        'Dikembangkan untuk membantu warga melaporkan masalah lingkungan.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('TUTUP'),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Bantuan'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Bantuan'),
                  content: const Text(
                    'Cara Menggunakan:\n\n'
                        '1. Klik tombol "Lapor" untuk membuat laporan baru\n'
                        '2. Isi form dan ambil foto bukti\n'
                        '3. Tandai lokasi dengan GPS\n'
                        '4. Kirim laporan\n'
                        '5. Petugas akan menindaklanjuti',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('TUTUP'),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),

          const SizedBox(height: 16),

          // TOMBOL LOGOUT (MAHASISWA 1)
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () => _showLogoutDialog(context, ref),
              icon: const Icon(Icons.logout),
              label: const Text('LOGOUT'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Dialog Logout (MAHASISWA 1)
  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('BATAL'),
          ),
          ElevatedButton(
            onPressed: () async {
              // LOGOUT (MAHASISWA 1 - Hapus Shared Preferences)
              await ref.read(authProvider.notifier).logout();

              if (ctx.mounted) {
                Navigator.pop(ctx); // Close dialog
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('LOGOUT'),
          ),
        ],
      ),
    );
  }
}