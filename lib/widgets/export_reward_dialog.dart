import 'package:flutter/material.dart';
import '../services/reward_ad_service.dart';

class ExportRewardDialog extends StatefulWidget {
  const ExportRewardDialog({super.key});

  @override
  State<ExportRewardDialog> createState() => _ExportRewardDialogState();
}

class _ExportRewardDialogState extends State<ExportRewardDialog> {
  bool _loading = false;
  final RewardAdService _adService = RewardAdService();

  void _watchAd() {
    if (_loading) return;
    setState(() => _loading = true);

    _adService.load(
      onLoaded: () {
        _adService.show(
          onRewardEarned: () {},
          onAdClosed: () {
            if (mounted) {
              Navigator.pop(context, true); // unlocked export
            }
          },
        );
      },
      onFailed: () {
        if (mounted) {
          setState(() => _loading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ad not available. Try later.')),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Unlock Export'),
      content: _loading
          ? const SizedBox(
        height: 60,
        child: Center(child: CircularProgressIndicator()),
      )
          : const Text('Watch a short ad to save or share this QR.'),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _watchAd,
          child: const Text('Watch Ad'),
        ),
      ],
    );
  }
}
