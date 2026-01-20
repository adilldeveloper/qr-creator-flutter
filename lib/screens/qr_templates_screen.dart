import 'package:flutter/material.dart';
import 'generate_qr_screen.dart';

class QrTemplatesScreen extends StatelessWidget {
  const QrTemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Templates')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _templateTile(
            context,
            icon: Icons.wifi,
            title: 'WiFi QR',
            subtitle: 'Share WiFi easily',
            preset: 'WIFI:T:WPA;S:MyWifi;P:password;;',
          ),
          _templateTile(
            context,
            icon: Icons.message,
            title: 'WhatsApp QR',
            subtitle: 'Chat without saving number',
            preset: 'https://wa.me/8801XXXXXXXXX',
          ),
          _templateTile(
            context,
            icon: Icons.email,
            title: 'Email QR',
            subtitle: 'Quick email access',
            preset: 'mailto:example@email.com',
          ),
          _templateTile(
            context,
            icon: Icons.phone,
            title: 'Phone QR',
            subtitle: 'Call instantly',
            preset: 'tel:+8801XXXXXXXXX',
          ),
        ],
      ),
    );
  }

  Widget _templateTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required String preset,
      }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GenerateQrScreen(initialData: preset),
            ),
          );
        },
      ),
    );
  }
}
