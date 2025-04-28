import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../models/event.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService;

  bool _isLoading = false;
  String? _error;
  List<Event> _savedEvents = [];
  List<Event> _attendingEvents = [];

  UserProvider(this._userService);

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Event> get savedEvents => _savedEvents;
  List<Event> get attendingEvents => _attendingEvents;

  Future<void> fetchSavedEvents() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _savedEvents = await _userService.getSavedEvents();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      print('Error fetching saved events: $_error');
      notifyListeners();
    }
  }

  Future<void> fetchAttendingEvents() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _attendingEvents = await _userService.getAttendingEvents();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      print('Error fetching attending events: $_error');
      notifyListeners();
    }
  }

  Future<bool> toggleSaveEvent(Event event, bool currentSavedStatus) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (currentSavedStatus) {
        await _userService.unsaveEvent(event.id);
        _savedEvents.removeWhere((e) => e.id == event.id);
      } else {
        await _userService.saveEvent(event.id);
        // Add the event to local list if it doesn't exist
        if (!_savedEvents.any((e) => e.id == event.id)) {
          _savedEvents.add(event);
        }
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      print('Error toggling save event: $_error');
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleAttendEvent(
    Event event,
    bool currentAttendingStatus,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (currentAttendingStatus) {
        await _userService.unattendEvent(event.id);
        _attendingEvents.removeWhere((e) => e.id == event.id);
      } else {
        await _userService.attendEvent(event.id);
        // Add the event to local list if it doesn't exist
        if (!_attendingEvents.any((e) => e.id == event.id)) {
          _attendingEvents.add(event);
        }
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      print('Error toggling attend event: $_error');
      notifyListeners();
      return false;
    }
  }

  bool isEventSaved(Event event) {
    return _savedEvents.any((savedEvent) => savedEvent.id == event.id);
  }

  bool isEventAttending(Event event) {
    return _attendingEvents.any(
      (attendingEvent) => attendingEvent.id == event.id,
    );
  }

  Future<bool> deleteCurrentUser() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _userService.deleteCurrentUser();

      // Reset local state
      clear();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      print('Error deleting user: $_error');
      notifyListeners();
      return false;
    }
  }

  // Clear method for logout
  void clear() {
    _savedEvents.clear();
    _attendingEvents.clear();
    notifyListeners();
  }

  Future<bool> submitEventProposal(Event event, List<XFile> images) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _userService.submitEventProposal(event, images);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      print('Error submitting event proposal: $_error');
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchUserData() async {
    await fetchSavedEvents();
    await fetchAttendingEvents();
  }

  // Add a method to clear errors
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
