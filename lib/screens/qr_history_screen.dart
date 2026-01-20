import 'package:flutter/material.dart';

import '../services/qr_history_service.dart';
import 'generate_qr_screen.dart';

class QrHistoryScreen extends StatefulWidget {
  const QrHistoryScreen({super.key});

  @override
  State<QrHistoryScreen> createState() => _QrHistoryScreenState();
}

class _QrHistoryScreenState extends State<QrHistoryScreen> {
  List<String> _history = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final list = await QrHistoryService.getHistory();
    setState(() {
      _history = list;
      _loading = false;
    });
  }

  Future<void> _deleteItem(String data) async {
    await QrHistoryService.remove(data);
    _loadHistory();
  }

  Future<void> _clearAll() async {
    await QrHistoryService.clear();
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My QR Codes'),
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _clearAll,
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
          ? _emptyState()
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _history.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final data = _history[index];
          return _historyTile(data);
        },
      ),
    );
  }

  Widget _historyTile(String data) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GenerateQrScreen(initialData: data),
          ),
        );
      },
      onLongPress: () => _deleteItem(data),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.indigo.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.qr_code, color: Colors.indigo),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                data,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.history, size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'No QR history yet',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
