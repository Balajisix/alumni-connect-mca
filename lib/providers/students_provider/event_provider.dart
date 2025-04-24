import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/event_model.dart';

class EventProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Event> _events = [];
  bool _isLoading = false;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;

  Future<void> createEvent({
    required String title,
    required String description,
    required DateTime date,
    required String location,
    required String organizerId,
    required String organizerName,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final eventRef = _firestore.collection('events').doc();
      final event = Event(
        id: eventRef.id,
        title: title,
        description: description,
        date: date,
        location: location,
        organizerId: organizerId,
        organizerName: organizerName,
        attendees: [],
        createdAt: DateTime.now(),
      );

      await eventRef.set(event.toMap());
      _events.add(event);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> fetchEvents() async {
    try {
      _isLoading = true;
      notifyListeners();

      final snapshot = await _firestore
          .collection('events')
          .orderBy('date', descending: true)
          .get();

      _events = snapshot.docs
          .map((doc) => Event.fromMap(doc.data()))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
} 