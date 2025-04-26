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
  
  Future<bool> toggleSaveEvent(int eventId, bool currentSavedStatus) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      if (currentSavedStatus) {
        await _userService.unsaveEvent(eventId);
        _savedEvents.removeWhere((event) => event.id == eventId);
      } else {
        await _userService.saveEvent(eventId);
        // Optionally fetch the updated list
        await fetchSavedEvents();
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
  
  Future<bool> toggleAttendEvent(int eventId, bool currentAttendingStatus) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      if (currentAttendingStatus) {
        await _userService.unattendEvent(eventId);
        _attendingEvents.removeWhere((event) => event.id == eventId);
      } else {
        await _userService.attendEvent(eventId);
        // Optionally fetch the updated list
        await fetchAttendingEvents();
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
  
  bool isEventSaved(int eventId) {
    return _savedEvents.any((event) => event.id == eventId);
  }
  
  bool isEventAttending(int eventId) {
    return _attendingEvents.any((event) => event.id == eventId);
  }

  Future<bool> deleteCurrentUser() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _userService.deleteCurrentUser();

      // Reset local state
      _savedEvents.clear();
      _attendingEvents.clear();

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
  
  // Add a method to clear errors
  void clearError() {
    _error = null;
    notifyListeners();
  }
}