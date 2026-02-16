import 'package:flutter/material.dart';
import '../main.dart';
import '../models/request_model.dart';
import '../services/api.dart';

class RequestsPage extends StatelessWidget {
  const RequestsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final requests = state.requests;

    if (requests.isEmpty) {
      return const Center(child: Text('Aucune demande pour l\'instant'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: requests.length,
      itemBuilder: (ctx, i) {
        final r = requests[i];
        final statusColor = r.status == 'Acceptée'
            ? Colors.green
            : (r.status == 'Refusée' ? Colors.red : Colors.orange);
        final statusIcon = r.status == 'Acceptée'
            ? Icons.check
            : (r.status == 'Refusée' ? Icons.close : Icons.hourglass_top);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(
                    r.type == RequestType.academic ? Icons.school : Icons.work,
                    color: Colors.white)),
            title: Text(r.title,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(r.type == RequestType.academic
                ? 'Académique'
                : 'Professionnelle'),
            trailing: Chip(
              backgroundColor: statusColor.withOpacity(0.12),
              avatar: CircleAvatar(
                  backgroundColor: statusColor,
                  radius: 12,
                  child: Icon(statusIcon, size: 14, color: Colors.white)),
              label: Text(r.status),
            ),
          ),
        );
      },
    );
  }
}
