class Volunteer {
  final String uid;
  final String? profileUrl;
  final String? email;
  final String? name;
  final String? phoneNumber;
  String? carNumber;

  Volunteer(
      {required this.uid,
      required this.profileUrl,
      required this.email,
      required this.name,
      required this.phoneNumber,
      this.carNumber});
}
