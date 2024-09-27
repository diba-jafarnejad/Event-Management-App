const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();

// HTTP Function to create a new event
exports.createEvent = functions.https.onRequest(async (req, res) => {
    const { title, description, date, location, organizer, eventType } = req.body;

    if (!title || !description || !date || !location || !organizer || !eventType) {
        return res.status(400).send('Missing required fields');
    }

    try {
        const newEvent = {
            title,
            description,
            date: admin.firestore.Timestamp.fromDate(new Date(date)),
            location,
            organizer,
            eventType
        };

        const docRef = await db.collection('events').add(newEvent);
        return res.status(201).send(`Event created with ID: ${docRef.id}`);
    } catch (error) {
        console.error("Error creating event: ", error);
        return res.status(500).send('Error creating event');
    }
});

// HTTP Function to update an existing event
exports.updateEvent = functions.https.onRequest(async (req, res) => {
    const eventId = req.body.id;
    const { title, description, date, location, organizer, eventType } = req.body;

    if (!eventId) {
        return res.status(400).send('Event ID is required');
    }

    try {
        const eventRef = db.collection('events').doc(eventId);
        const updatedEvent = {
            title,
            description,
            date: admin.firestore.Timestamp.fromDate(new Date(date)),
            location,
            organizer,
            eventType
        };

        await eventRef.update(updatedEvent);
        return res.status(200).send('Event updated successfully');
    } catch (error) {
        console.error("Error updating event: ", error);
        return res.status(500).send('Error updating event');
    }
});

// HTTP Function to delete an event
exports.deleteEvent = functions.https.onRequest(async (req, res) => {
    const eventId = req.body.id;

    if (!eventId) {
        return res.status(400).send('Event ID is required');
    }

    try {
        await db.collection('events').doc(eventId).delete();
        return res.status(200).send('Event deleted successfully');
    } catch (error) {
        console.error("Error deleting event: ", error);
        return res.status(500).send('Error deleting event');
    }
});

// Firestore Trigger Function - Log event creation
exports.onEventCreate = functions.firestore
    .document('events/{eventId}')
    .onCreate((snapshot, context) => {
        const newEvent = snapshot.data();
        console.log('New Event Created: ', newEvent);
        return null;
    });

// Firestore Trigger Function - Log event updates
exports.onEventUpdate = functions.firestore
    .document('events/{eventId}')
    .onUpdate((change, context) => {
        const before = change.before.data();
        const after = change.after.data();
        console.log('Event Updated from', before, 'to', after);
        return null;
    });

// Firestore Trigger Function - Log event deletion
exports.onEventDelete = functions.firestore
    .document('events/{eventId}')
    .onDelete((snapshot, context) => {
        const deletedEvent = snapshot.data();
        console.log('Event Deleted: ', deletedEvent);
        return null;
    });