# Event Management App with Firebase and Flutter

This project is a **Flutter-based event management application** that allows users to create, edit, view, and delete events. It uses **Firebase** for backend services, including **Firestore** for database management and **Firebase Cloud Functions** (Node.js) to handle server-side logic. The app provides a seamless user experience by integrating date and time pickers, allowing users to select event dates and times.

## ✨ Features

- **Create, Edit, and Delete Events**: Users can easily manage events with a simple UI and intuitive forms.
- **Date and Time Picker**: Users can select both the date and time for their events using built-in pickers, making event management more precise.
- **Firestore Database**: All event data is stored in Firebase Firestore, ensuring real-time synchronization and robust data management.
- **Firebase Cloud Functions (Node.js)**: Cloud functions handle server-side logic for creating, updating, and deleting events. Trigger functions log event creation, updates, and deletions.
- **Real-time Updates**: Any changes to the event list are automatically updated across all devices in real-time, thanks to Firestore's synchronization capabilities.
- **Form Validation**: The app includes validation for all event fields, ensuring users fill out required fields correctly before submitting.

## 🛠️ Technology Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Node.js with Firebase Cloud Functions
- **Database**: Firestore (Firebase)

## 🚀 How It Works

- **Event Creation**: Users can create new events by filling in details such as the event title, description, date, time, location, organizer, and event type.
- **Event Editing**: Existing events can be edited by modifying their details.
- **Event Deletion**: Users can delete events, with confirmation prompts to prevent accidental deletions.
- **Event List View**: The app displays a list of all events, and users can tap on an event to view its details.
- **Firebase Integration**: Events are stored in Firestore, and the app is integrated with Firebase Cloud Functions for backend logic.
- **Firestore Security**: The app is secured using Firestore security rules, ensuring that only authenticated users can manage events.
