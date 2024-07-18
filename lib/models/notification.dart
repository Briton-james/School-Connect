class AppNotification {
  final String id;
  final String message;
  final String type;
  final String schoolId;
  final String volunteerId;

  AppNotification(
      {required this.id,
      required this.message,
      required this.type,
      required this.schoolId,
      required this.volunteerId});

  factory AppNotification.fromMap(
      Map<String, dynamic> data, String documentId) {
    return AppNotification(
        id: documentId,
        message: data['message'] ?? 'No Body',
        type: data['type'] ?? 'application',
        schoolId: data['schoolId'] ?? '',
        volunteerId: data['volunteerId']);
  }
}
