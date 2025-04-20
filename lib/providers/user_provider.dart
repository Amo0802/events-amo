import 'package:flutter/foundation.dart';
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
      notifyListeners();
    }
  }
  
  Future<bool> saveEvent(int eventId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      await _userService.saveEvent(eventId);
      await fetchSavedEvents();
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> unsaveEvent(int eventId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      await _userService.unsaveEvent(eventId);
      
      _savedEvents.removeWhere((event) => event.id == eventId);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> attendEvent(int eventId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      await _userService.attendEvent(eventId);
      await fetchAttendingEvents();
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> unattendEvent(int eventId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      await _userService.unattendEvent(eventId);
      
      _attendingEvents.removeWhere((event) => event.id == eventId);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
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
}