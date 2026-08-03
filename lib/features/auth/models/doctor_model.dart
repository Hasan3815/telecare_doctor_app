
class DoctorModel {
  final String id;

  final String name;

  final String email;

  const DoctorModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory DoctorModel.fromFirebase({
    required String id,
    required String email,
  }) {
    return DoctorModel(
      id: id,
      name: 'Dr. Hasan',
      email: email,
    );
  }
}