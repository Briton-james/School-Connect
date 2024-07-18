// lib/models/school.dart

class School {
  final String district;
  final String email;
  final String genderComposition;
  final bool isBoarding;
  final bool isPrivate;
  final bool isReligious;
  final int numberOfStudents;
  final String phoneNumber;
  final String profileImageUrl;
  final String region;
  final String registrationNumber;
  final String religion;
  final String religionType;
  final String schoolName;
  final String schoolType;
  final String street;
  final String ward;

  School({
    required this.district,
    required this.email,
    required this.genderComposition,
    required this.isBoarding,
    required this.isPrivate,
    required this.isReligious,
    required this.numberOfStudents,
    required this.phoneNumber,
    required this.profileImageUrl,
    required this.region,
    required this.registrationNumber,
    required this.religion,
    required this.religionType,
    required this.schoolName,
    required this.schoolType,
    required this.street,
    required this.ward,
  });

  factory School.fromMap(Map<String, dynamic> data, String id) {
    return School(
      district: data['district'],
      email: data['email'],
      genderComposition: data['genderComposition'],
      isBoarding: data['isBoarding'],
      isPrivate: data['isPrivate'],
      isReligious: data['isReligious'],
      numberOfStudents: data['numberOfStudents'],
      phoneNumber: data['phoneNumber'],
      profileImageUrl: data['profileImageUrl'],
      region: data['region'],
      registrationNumber: data['registrationNumber'],
      religion: data['religion'],
      religionType: data['religionType'],
      schoolName: data['schoolName'],
      schoolType: data['schoolType'],
      street: data['street'],
      ward: data['ward'],
    );
  }
}
