import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school_connect/models/school.dart';

Future<School> fetchSchoolDetails(String schoolId) async {
  DocumentSnapshot schoolSnapshot = await FirebaseFirestore.instance
      .collection('schools')
      .doc(schoolId)
      .get();
  return School.fromMap(
      schoolSnapshot.data() as Map<String, dynamic>, schoolSnapshot.id);
}
