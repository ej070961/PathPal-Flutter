class Volunteer {
  late String uid;
  late String profileUrl;
  late String email;
  late String name;
  late String phoneNumber;
  String? carNumber;

  Volunteer(
      {required this.uid,
      required this.profileUrl,
      required this.email,
      required this.name,
      required this.phoneNumber,
      this.carNumber});
}
