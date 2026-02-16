class Profile {
  String firstName = '';
  String lastName = '';
  String email = '';
  String phone = '';
  String university = '';
  String degree = '';
  String gradYear = '';
  String company = '';
  String position = '';

  int completenessPercentage() {
    final fields = [
      firstName,
      lastName,
      email,
      phone,
      university,
      degree,
      gradYear,
      company,
      position,
    ];
    final filled = fields.where((f) => f.trim().isNotEmpty).length;
    return ((filled / fields.length) * 100).round();
  }

  bool isComplete() => completenessPercentage() == 100;
}
