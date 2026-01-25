import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../services/reward_ad_service.dart';
import '../services/att_service.dart';
import '../services/qr_history_service.dart';

class GenerateQrScreen extends StatefulWidget {
  final String? initialData;

  const GenerateQrScreen({super.key, this.initialData});

  @override
  State<GenerateQrScreen> createState() => _GenerateQrScreenState();
}

class _GenerateQrScreenState extends State<GenerateQrScreen> {
  final RewardAdService _adService = RewardAdService();

  final TextEditingController _controller = TextEditingController();
  final GlobalKey _qrKey = GlobalKey();

  String _qrData = '';

  @override
  void initState() {
    super.initState();

    if (widget.initialData != null) {
      _controller.text = widget.initialData!;
      _qrData = widget.initialData!;
    }

    _prepareAds(); // ✅ ATT + AdMob + preload
  }

  Future<void> _prepareAds() async {
    // 🔐 STEP 1: Request ATT permission (iOS only)
    await AttService.requestIfNeeded();

    // 📢 STEP 2: Initialize AdMob AFTER ATT
    await MobileAds.instance.initialize();

    // 🎯 STEP 3: Preload rewarded ad silently
    _adService.preload();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// SHARE QR (AD IF AVAILABLE, OTHERWISE DIRECT SHARE)
  Future<void> _shareQr() async {
    if (_qrData.isEmpty) return;

    _adService.showIfAvailable(
      onComplete: () async {
        final boundary =
        _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

        final image = await boundary.toImage(pixelRatio: 3);
        final byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);

        final Uint8List pngBytes = byteData!.buffer.asUint8List();

        final XFile file = XFile.fromData(
          pngBytes,
          mimeType: 'image/png',
          name: 'qr.png',
        );

        await QrHistoryService.add(_qrData);

        await Share.shareXFiles(
          [file],
          text: 'Generated using QR Pro',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Generate QR')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Enter text or link',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() => _qrData = value.trim());
                },
              ),
              const SizedBox(height: 24),

              if (_qrData.isNotEmpty)
                RepaintBoundary(
                  key: _qrKey,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: QrImageView(
                      data: _qrData,
                      size: 220,
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              if (_qrData.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _shareQr,
                    icon: const Icon(Icons.share),
                    label: const Text('Share QR'),
                  ),
                ),

              const SizedBox(height: 24),

              Text(
                'An ad may be shown before sharing',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
