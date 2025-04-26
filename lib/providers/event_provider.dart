import 'package:flutter/foundation.dart';
import '../models/event.dart';
import '../models/page_response.dart';
import '../services/event_service.dart';

class EventProvider with ChangeNotifier {
  final EventService _eventService;
  
  bool _isLoading = false;
  String? _error;
  PageResponse<Event>? _events;
  PageResponse<Event>? _mainEvents;
  PageResponse<Event>? _promotedEvents;
  PageResponse<Event>? _filteredEvents;
  PageResponse<Event>? _searchResults;
  Event? _selectedEvent;
  
  EventProvider(this._eventService) {
    // Initialize data loading when provider is created
    fetchMainEvents();
    fetchPromotedEvents();
  }
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  PageResponse<Event>? get events => _events;
  PageResponse<Event>? get mainEvents => _mainEvents;
  PageResponse<Event>? get promotedEvents => _promotedEvents;
  PageResponse<Event>? get filteredEvents => _filteredEvents;
  PageResponse<Event>? get searchResults => _searchResults;
  Event? get selectedEvent => _selectedEvent;
  
  Future<void> fetchEvents({int page = 0, int size = 10}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      _events = await _eventService.getEvents(page: page, size: size);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      print('Error fetching events: $_error');
      notifyListeners();
    }
  }
  
  Future<void> fetchMainEvents({int page = 0, int size = 10}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      _mainEvents = await _eventService.getMainEvents(page: page, size: size);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      print('Error fetching main events: $_error');
      notifyListeners();
    }
  }
  
  Future<void> fetchPromotedEvents({int page = 0, int size = 10}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      _promotedEvents = await _eventService.getPromotedEvents(page: page, size: size);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      print('Error fetching promoted events: $_error');
      notifyListeners();
    }
  }
  
  Future<void> fetchFilteredEvents(String city, String category, {int page = 0, int size = 10}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final result = await _eventService.getFilteredEvents(city, category, page: page, size: size);
      _filteredEvents = result;
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      print('Error fetching filtered events: $_error');
      notifyListeners();
    }
  }
  
  Future<void> searchEvents(String query, {int page = 0, int size = 10}) async {
    if (query.isEmpty) {
      _searchResults = null;
      notifyListeners();
      return;
    }
    
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      _searchResults = await _eventService.searchEvents(query, page: page, size: size);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      print('Error searching events: $_error');
      notifyListeners();
    }
  }
  
  Future<void> fetchEventById(int id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      _selectedEvent = await _eventService.getEvent(id);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      print('Error fetching event by ID: $_error');
      notifyListeners();
    }
  }
  
  Future<bool> createEvent(Event event) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      await _eventService.createEvent(event);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      print('Error creating event: $_error');
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> updateEvent(int id, Event event) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      await _eventService.updateEvent(id, event);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      print('Error updating event: $_error');
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> deleteEvent(int id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      await _eventService.deleteEvent(id);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      print('Error deleting event: $_error');
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> submitEventProposal(Event event) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      await _eventService.submitEventProposal(event);
      
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

  void patchLocalEvent(Event updatedEvent) {
    bool hasUpdated = false;

    void updateEventInList(PageResponse<Event>? page) {
      if (page == null) return;

      final index = page.content.indexWhere((e) => e.id == updatedEvent.id);
      if (index != -1) {
        page.content[index] = updatedEvent;
        hasUpdated = true;
      }
    }

    updateEventInList(_events);
    updateEventInList(_mainEvents);
    updateEventInList(_promotedEvents);
    updateEventInList(_filteredEvents);
    updateEventInList(_searchResults);

    if (hasUpdated) {
      notifyListeners();
    }
  }
  
  // Helper method to clear errors
  void clearError() {
    _error = null;
    notifyListeners();
  }
  
  // Reset method for testing
  void reset() {
    _isLoading = false;
    _error = null;
    _events = null;
    _mainEvents = null;
    _promotedEvents = null;
    _filteredEvents = null;
    _searchResults = null;
    _selectedEvent = null;
    notifyListeners();
  }
}