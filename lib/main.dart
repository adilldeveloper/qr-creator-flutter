import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'dart:io';

import 'screens/about_screen.dart';
import 'screens/generate_qr_screen.dart';
import 'screens/qr_templates_screen.dart';
import 'screens/qr_history_screen.dart';

import 'services/usage_service.dart';
import 'widgets/reward_dialog.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ STEP 1: Request ATT FIRST (iOS only)
  if (Platform.isIOS) {
    final status =
    await AppTrackingTransparency.trackingAuthorizationStatus;

    if (status == TrackingStatus.notDetermined) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }

  // ✅ STEP 2: Initialize AdMob AFTER ATT
  await MobileAds.instance.initialize();

  runApp(const MyApp());
}

/// ----------------------------------------------------
/// APP ROOT
/// ----------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Creator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const HomeScreen(),
    );
  }
}

/// ----------------------------------------------------
/// HOME SCREEN
/// ----------------------------------------------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                /// HERO
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.qr_code_2,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'QR Pro',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Fast • Simple • Secure',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 12),

                _modernActionCard(
                  icon: Icons.flash_on,
                  title: 'Quick QR',
                  subtitle: 'Generate QR from text or link',
                  onTap: () => _handleLimitedAccess(
                    context,
                    const GenerateQrScreen(),
                  ),
                ),

                const SizedBox(height: 16),

                _modernActionCard(
                  icon: Icons.dashboard_customize,
                  title: 'QR Templates',
                  subtitle: 'WiFi • WhatsApp • Email • Phone',
                  onTap: () => _handleLimitedAccess(
                    context,
                    const QrTemplatesScreen(),
                  ),
                ),

                const SizedBox(height: 16),

                _myQrLibraryCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const QrHistoryScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                Center(
                  child: Text(
                    '3 free uses daily • Watch a short ad to unlock more',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                _aboutCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AboutScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ----------------------------------------------------
  /// ACCESS CONTROL
  /// ----------------------------------------------------
  Future<void> _handleLimitedAccess(
      BuildContext context,
      Widget screen,
      ) async {
    final canUse = await UsageService.canUseToday();

    if (canUse) {
      await UsageService.increaseUsage();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => screen),
      );
    } else {
      final unlocked = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const RewardDialog(),
      );

      if (unlocked == true) {
        await UsageService.increaseUsage();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen),
        );
      }
    }
  }

  /// ----------------------------------------------------
  /// UI HELPERS
  /// ----------------------------------------------------
  Widget _modernActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              Colors.indigo.shade400,
              Colors.indigo.shade700,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.indigo.withOpacity(0.25),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white70,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _myQrLibraryCard({required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: const [
            Icon(Icons.history, color: Colors.indigo),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                'My QR Codes',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _aboutCard({required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: const [
            Icon(Icons.info_outline, color: Colors.indigo),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                'About QR Creator',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
