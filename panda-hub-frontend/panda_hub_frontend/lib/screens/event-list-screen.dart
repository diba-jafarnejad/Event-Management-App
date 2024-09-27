import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/event-model.dart';
import 'event-info-screen.dart';
import 'create-update-event-screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EventListScreen extends StatefulWidget {
  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  // Store the selected event type
  String? selectedEventType;

  // Method to fetch events from Firestore based on the selected filter
  Stream<List<EventModel>> fetchFilteredEvents() {
    CollectionReference eventsCollection = FirebaseFirestore.instance.collection('events');

    // If no filter is selected, fetch all events
    if (selectedEventType == null || selectedEventType!.isEmpty) {
      return eventsCollection.snapshots().map((snapshot) => snapshot.docs
          .map((doc) => EventModel.fromFirestore(doc))
          .toList());
    }

    // If a filter is selected, fetch events based on the selected event type
    return eventsCollection
        .where('eventType', isEqualTo: selectedEventType)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => EventModel.fromFirestore(doc))
        .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Events', style: GoogleFonts.eduNswActFoundation()),
        actions: [
          // Dropdown for filtering by event type
          DropdownButton<String>(
            value: selectedEventType,
            hint: Text('Filter by Type'),
            items: ['Conference', 'Workshop', 'Webinar']
                .map((type) => DropdownMenuItem<String>(value: type, child: Text(type)))
                .toList(),
            onChanged: (value) {
              // Update the selected event type and trigger a rebuild
              setState(() {
                selectedEventType = value;
              });
            },
            icon: Icon(Icons.filter_list),
          ),
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              // Clear the filter
              setState(() {
                selectedEventType = null;
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<List<EventModel>>(
        stream: fetchFilteredEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No events found.'));
          }

          List<EventModel> events = snapshot.data!;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return ListTile(
                tileColor: Color(0xFFDDC5EB),
                isThreeLine: true,
                title: Text(event.title, style: GoogleFonts.eduNswActFoundation()),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.eventType, style: GoogleFonts.eduNswActFoundation()),
                    Text(DateFormat('yyyy-MM-dd').format(event.date), style: GoogleFonts.eduNswActFoundation()),
                  ],
                ),
                onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventInfoScreen(event: event)),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreateUpdateEventScreen()),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}