import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About QR Creator'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              const SizedBox(height: 12),

              Text(
                'QR Creator',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              const Text(
                'QR Creator is a fast and easy-to-use QR code generator. '
                    'It helps you create, save, and share QR codes directly on your device.',
                style: TextStyle(fontSize: 15),
              ),

              const SizedBox(height: 24),

              _sectionTitle('Key Features'),
              const SizedBox(height: 8),

              _bullet('Generate QR codes from text or links'),
              _bullet('Ready-made QR templates (WiFi, WhatsApp, Email, Phone)'),
              _bullet('Save and manage QR history'),
              _bullet('Share QR codes'),
              _bullet('Works offline for most features'),

              const SizedBox(height: 24),

              _sectionTitle('Ads & Usage'),
              const SizedBox(height: 8),

              const Text(
                'You can use the app for free with a daily limit. '
                    'Watching a short rewarded ad allows you to unlock additional uses. '
                    'Ads help support continued development of the app.',
              ),

              const SizedBox(height: 24),

              _sectionTitle('Privacy'),
              const SizedBox(height: 8),

              const Text(
                'QR Creator does not require account registration. '
                    'Your QR codes are stored locally on your device. '
                    'Tracking is optional and used only to support ads.',
              ),

              const SizedBox(height: 32),

              Center(
                child: Text(
                  'Version 1.0',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  ', style: TextStyle(fontSize: 16)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
