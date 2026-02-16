enum RequestType { academic, professional }

class InternshipRequest {
  final String id;
  final String title;
  final RequestType type;
  String status; // e.g. 'En cours', 'Acceptée', 'Refusée'
  final DateTime createdAt;

  InternshipRequest(
      {required this.id,
      required this.title,
      required this.type,
      this.status = 'En cours',
      DateTime? createdAt})
      : createdAt = createdAt ?? DateTime.now();
}
