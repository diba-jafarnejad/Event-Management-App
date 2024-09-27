import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/event-model.dart';
import 'create-update-event-screen.dart';

class EventInfoScreen extends StatelessWidget {
  final EventModel event;

  EventInfoScreen({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title, style: GoogleFonts.eduNswActFoundation()),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navigate to the Edit Event Screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateUpdateEventScreen(event: event),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              // Confirm delete action
              bool? confirmDelete = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Delete Event'),
                  content: Text('Are you sure you want to delete this event?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Delete'),
                    ),
                  ],
                ),
              );

              if (confirmDelete == true) {
                // Delete the event from Firestore
                await FirebaseFirestore.instance
                    .collection('events')
                    .doc(event.id)
                    .delete();
                Navigator.pop(context); // Return to the event list screen
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${event.title}', style: GoogleFonts.eduNswActFoundation(fontSize: 18)),
            SizedBox(height: 10),
            Text('Description: ${event.description}', style: GoogleFonts.eduNswActFoundation(fontSize: 18)),
            SizedBox(height: 10),
            Text('Date: ${event.date}', style: GoogleFonts.eduNswActFoundation(fontSize: 18)),
            SizedBox(height: 10),
            Text('Location: ${event.location}', style: GoogleFonts.eduNswActFoundation(fontSize: 18)),
            SizedBox(height: 10),
            Text('Organizer: ${event.organizer}', style: GoogleFonts.eduNswActFoundation(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
