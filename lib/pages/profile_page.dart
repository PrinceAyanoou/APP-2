import 'package:flutter/material.dart';
import '../main.dart';
import '../models/profile.dart';
import '../services/api.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Profile _draft;
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  final _first = TextEditingController();
  final _last = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _univ = TextEditingController();
  final _degree = TextEditingController();
  final _year = TextEditingController();
  final _company = TextEditingController();
  final _position = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = AppStateScope.of(context);
    _draft = state.profile;

    _first.text = _draft.firstName;
    _last.text = _draft.lastName;
    _email.text = _draft.email;
    _phone.text = _draft.phone;
    _univ.text = _draft.university;
    _degree.text = _draft.degree;
    _year.text = _draft.gradYear;
    _company.text = _draft.company;
    _position.text = _draft.position;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final result = await ApiService.updateProfile({
        'firstName': _first.text,
        'lastName': _last.text,
        'email': _email.text,
        'phone': _phone.text,
        'university': _univ.text,
        'degree': _degree.text,
        'gradYear': _year.text,
        'company': _company.text,
        'position': _position.text,
      });

      if (result['success']) {
        final updated = Profile()
          ..firstName = _first.text
          ..lastName = _last.text
          ..email = _email.text
          ..phone = _phone.text
          ..university = _univ.text
          ..degree = _degree.text
          ..gradYear = _year.text
          ..company = _company.text
          ..position = _position.text;

        AppStateScope.of(context).updateProfile(updated);
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Profil mis à jour')));
        }
      } else {
        _showError(result['error'] ?? 'Failed to update profile');
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    final percent = AppStateScope.of(context).profile.completenessPercentage();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        child: Text('$percent%',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Complétude du profil',
                                style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 6),
                            LinearProgressIndicator(value: percent / 100),
                            const SizedBox(height: 6),
                            Text(
                                percent < 100
                                    ? 'Complétez toutes les sections pour pouvoir postuler.'
                                    : 'Profil complet — vous pouvez postuler.',
                                style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Personal
              ExpansionTile(
                initiallyExpanded: true,
                title: const Text('Informations personnelles'),
                children: [
                  TextFormField(
                      controller: _first,
                      decoration: const InputDecoration(labelText: 'Prénom'),
                      validator: (v) => v!.isEmpty ? 'Requis' : null),
                  const SizedBox(height: 8),
                  TextFormField(
                      controller: _last,
                      decoration: const InputDecoration(labelText: 'Nom'),
                      validator: (v) => v!.isEmpty ? 'Requis' : null),
                  const SizedBox(height: 8),
                  TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (v) => v!.isEmpty ? 'Requis' : null),
                  const SizedBox(height: 8),
                  TextFormField(
                      controller: _phone,
                      decoration:
                          const InputDecoration(labelText: 'Téléphone')),
                  const SizedBox(height: 12),
                ],
              ),

              // Academic
              ExpansionTile(
                title: const Text('Académique'),
                children: [
                  TextFormField(
                      controller: _univ,
                      decoration:
                          const InputDecoration(labelText: 'Université')),
                  const SizedBox(height: 8),
                  TextFormField(
                      controller: _degree,
                      decoration: const InputDecoration(labelText: 'Diplôme')),
                  const SizedBox(height: 8),
                  TextFormField(
                      controller: _year,
                      decoration: const InputDecoration(
                          labelText: 'Année de graduation')),
                  const SizedBox(height: 12),
                ],
              ),

              // Professional
              ExpansionTile(
                title: const Text('Professionnel'),
                children: [
                  TextFormField(
                      controller: _company,
                      decoration: const InputDecoration(
                          labelText: 'Entreprise (si applicable)')),
                  const SizedBox(height: 8),
                  TextFormField(
                      controller: _position,
                      decoration: const InputDecoration(labelText: 'Poste')),
                  const SizedBox(height: 12),
                ],
              ),

              const SizedBox(height: 16),
              ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Enregistrer')),
            ],
          ),
        ),
      ),
    );
  }
}
