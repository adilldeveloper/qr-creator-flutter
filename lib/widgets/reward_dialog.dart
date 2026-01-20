import 'package:flutter/material.dart';
import '../services/reward_ad_service.dart';
import '../services/usage_service.dart';
import '../services/connectivity_service.dart';


class RewardDialog extends StatefulWidget {
  const RewardDialog({super.key});

  @override
  State<RewardDialog> createState() => _RewardDialogState();
}

class _RewardDialogState extends State<RewardDialog> {
  bool _loading = false;
  final RewardAdService _adService = RewardAdService();


  void _watchAd() async {
    if (_loading) return;

    final hasInternet = await ConnectivityService.hasInternet();

    if (!hasInternet) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('No Internet Connection'),
            content: const Text(
              'Please turn on Wi-Fi or mobile data to watch the ad.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      return;
    }

    // Internet available → proceed
    setState(() => _loading = true);

    bool _rewardEarned = false;

    _adService.load(
      onLoaded: () {
        _adService.show(
          onRewardEarned: () {
            // Reward earned, set the flag to true
            _rewardEarned = true;
          },
          onAdClosed: () {
            if (mounted) {
              // Close the dialog and pass the reward status
              Navigator.pop(context, _rewardEarned);
            }
          },
        );
      },
      onFailed: () {
        if (mounted) {
          setState(() => _loading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ad not available. Try again later.'),
            ),
          );
        }
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Daily limit reached'),
      content: _loading
          ? const SizedBox(
        height: 60,
        child: Center(child: CircularProgressIndicator()),
      )
          : const Text('Watch a short video to unlock 1 more use.'),
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
