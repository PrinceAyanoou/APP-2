import 'package:flutter/material.dart';
import '../main.dart';
import '../models/request_model.dart';
import '../services/api.dart';

class NewRequestPage extends StatefulWidget {
  const NewRequestPage({Key? key}) : super(key: key);

  @override
  State<NewRequestPage> createState() => _NewRequestPageState();
}

class _NewRequestPageState extends State<NewRequestPage> {
  RequestType _type = RequestType.academic;
  final _titleCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final app = AppStateScope.of(context);
    if (!app.profile.isComplete()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Profil incomplet (${app.profile.completenessPercentage()}%). Complétez votre profil avant de faire une demande.')));
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final result = await ApiService.createRequest(_titleCtrl.text.trim(),
          _type == RequestType.academic ? 'academic' : 'professional');
      if (result['success']) {
        final data = result['data'];
        final req = InternshipRequest(
            id: data['id'],
            title: data['title'],
            type: _type,
            status: data['status']);
        app.addRequest(req);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Demande créée avec succès')));
          _titleCtrl.clear();
        }
      } else {
        _showError(result['error'] ?? 'Erreur lors de la création');
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    final app = AppStateScope.of(context);
    final isComplete = app.profile.isComplete();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Faire une demande',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            if (!isComplete)
              Card(
                color: Colors.yellow[50],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.orange),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(
                              'Votre profil est à ${app.profile.completenessPercentage()}% — complétez-le à 100% avant de soumettre une demande.')),
                      TextButton(
                          onPressed: () => DefaultTabController.of(context),
                          child: const Text('Aller au profil'))
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              child: Column(children: [
                DropdownButtonFormField<RequestType>(
                  initialValue: _type,
                  items: const [
                    DropdownMenuItem(
                        value: RequestType.academic,
                        child: Text('Stage académique')),
                    DropdownMenuItem(
                        value: RequestType.professional,
                        child: Text('Stage professionnel')),
                  ],
                  onChanged: (v) => setState(() => _type = v!),
                  decoration:
                      const InputDecoration(labelText: 'Type de demande'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                    controller: _titleCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Titre / entreprise / sujet'),
                    validator: (v) => v!.isEmpty ? 'Requis' : null),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (isComplete && !_isSubmitting) ? _submit : null,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Soumettre la demande'),
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
