import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String id;
  String title;
  String description;
  DateTime date;
  String location;
  String organizer;
  String eventType;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.organizer,
    required this.eventType,
  });

  // Factory method to create an EventModel from Firestore document data
  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return EventModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      location: data['location'] ?? '',
      organizer: data['organizer'] ?? '',
      eventType: data['eventType'] ?? '',
    );
  }

  // Method to convert EventModel to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'location': location,
      'organizer': organizer,
      'eventType': eventType,
    };
  }
}
