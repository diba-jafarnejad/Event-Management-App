import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../model/event-model.dart';

class CreateUpdateEventScreen extends StatefulWidget {
  final EventModel? event;

  CreateUpdateEventScreen({this.event});

  @override
  _CreateUpdateEventScreenState createState() => _CreateUpdateEventScreenState();
}

class _CreateUpdateEventScreenState extends State<CreateUpdateEventScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  late String title;
  late String description;
  late String location;
  late String organizer;
  late String eventType;
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
  final DateFormat timeFormatter = DateFormat('hh:mm a');


  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      title = widget.event!.title;
      description = widget.event!.description;
      location = widget.event!.location;
      organizer = widget.event!.organizer;
      eventType = widget.event!.eventType;
      date = widget.event!.date;
      _dateController.text = dateFormatter.format(date);
      _timeController.text = timeFormatter.format(DateTime(date.year, date.month, date.day, time.hour, time.minute));
    }
  }

  // Method to select a date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != date) {
      setState(() {
        date = pickedDate;
        _dateController.text = dateFormatter.format(date); // Update the text field with the selected date
      });
    }
  }

  // Select time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: time,
    );
    if (picked != null && picked != time) {
      setState(() {
        time = picked;
        _timeController.text = picked.format(context); // Update the time field
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event != null ? 'Edit Event' : 'Create Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.event?.title,
                decoration: InputDecoration(labelText: 'Title'),
                onSaved: (value) => title = value!,
                validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                initialValue: widget.event?.description,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => description = value!,
              ),
              TextFormField(
                initialValue: widget.event?.location,
                decoration: InputDecoration(labelText: 'Location'),
                onSaved: (value) => location = value!,
              ),
              TextFormField(
                initialValue: widget.event?.organizer,
                decoration: InputDecoration(labelText: 'Organizer'),
                onSaved: (value) => organizer = value!,
              ),
              DropdownButtonFormField<String>(
                value: widget.event?.eventType ?? 'Conference',
                items: ['Conference', 'Workshop', 'Webinar']
                    .map((type) => DropdownMenuItem<String>(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) => eventType = value!,
                decoration: InputDecoration(labelText: 'Event Type'),
              ),
              SizedBox(height: 20),

              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Select Date',
                  icon: Icon(Icons.calendar_today),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode()); // Prevent keyboard from showing
                  _selectDate(context); // Open date picker
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),

              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(
                  labelText: 'Select Time',
                  icon: Icon(Icons.access_time),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode()); // Prevent keyboard from showing
                  _selectTime(context); // Open time picker
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a time';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final DateTime eventDateTime = DateTime(
                        date.year, date.month, date.day, time.hour, time.minute);
                    final event = EventModel(
                      id: widget.event?.id ?? '',
                      title: title,
                      description: description,
                      date: eventDateTime,
                      location: location,
                      organizer: organizer,
                      eventType: eventType,
                    );

                    if (widget.event != null) {
                      // Update the existing event
                      await FirebaseFirestore.instance
                          .collection('events')
                          .doc(event.id)
                          .update(event.toFirestore());
                    } else {
                      // Create a new event
                      await FirebaseFirestore.instance.collection('events').add(event.toFirestore());
                    }

                    Navigator.pop(context);
                  }
                },
                child: Text(widget.event != null ? 'Save Changes' : 'Create Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    _dateController.dispose(); // Dispose the controller when no longer needed
    super.dispose();
    _timeController.dispose(); // Dispose the time controller as well
    super.dispose();
  }
}