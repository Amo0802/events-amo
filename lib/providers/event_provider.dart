import 'package:events_amo/providers/auth_provider.dart';
import 'package:events_amo/providers/user_provider.dart';
import 'package:events_amo/services/navigation_service.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
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

      _promotedEvents = await _eventService.getPromotedEvents(
        page: page,
        size: size,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      print('Error fetching promoted events: $_error');
      notifyListeners();
    }
  }

  Future<void> fetchFilteredEvents(
    String city,
    String category, {
    int page = 0,
    int size = 10,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _eventService.getFilteredEvents(
        city,
        category,
        page: page,
        size: size,
      );
      _filteredEvents = result;

      // Now, after fetching events, update them with user's saved/attending status
      await _updateEventsWithUserStatus(_filteredEvents);

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

      _searchResults = await _eventService.searchEvents(
        query,
        page: page,
        size: size,
      );

      // Using NavigationService approach
      await _updateEventsWithUserStatus(_searchResults);

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

  // Improved patchLocalEvent method that updates events in all locations
  void patchLocalEvent(Event updatedEvent) {
    bool hasUpdated = false;

    // Helper function to update event in a list
    void updateEventInList(List<Event>? events) {
      if (events == null || events.isEmpty) return;

      final index = events.indexWhere((e) => e.id == updatedEvent.id);
      if (index != -1) {
        events[index] = updatedEvent;
        hasUpdated = true;
      }
    }

    // Helper function to update event in a PageResponse
    void updateEventInPageResponse(PageResponse<Event>? page) {
      if (page == null) return;
      updateEventInList(page.content);
    }

    // Update in all possible locations
    updateEventInPageResponse(_events);
    updateEventInPageResponse(_mainEvents);
    updateEventInPageResponse(_promotedEvents);
    updateEventInPageResponse(_filteredEvents);
    updateEventInPageResponse(_searchResults);

    // Update in UserProvider lists if needed
    final context = NavigationService.navigatorKey.currentContext;
    if (context != null) {
      try {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        // Update in saved events
        updateEventInList(userProvider.savedEvents);
        // Update in attending events
        updateEventInList(userProvider.attendingEvents);
      } catch (e) {
        print('Error updating UserProvider lists: $e');
        // If there's an error (like Provider not found), continue without failing
      }
    }

    // Update selected event if it matches
    if (_selectedEvent?.id == updatedEvent.id) {
      _selectedEvent = updatedEvent;
      hasUpdated = true;
    }

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

  Future<void> _updateEventsWithUserStatus(
    PageResponse<Event>? pageResponse,
  ) async {
    if (pageResponse == null || pageResponse.content.isEmpty) return;

    try {
      final context = NavigationService.navigatorKey.currentContext;
      if (context == null) return;

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Only proceed if user is authenticated
      if (authProvider.status != AuthStatus.authenticated) return;

      // Fetch user's saved and attending events if not already loaded
      if (userProvider.savedEvents.isEmpty) {
        await userProvider.fetchSavedEvents();
      }
      if (userProvider.attendingEvents.isEmpty) {
        await userProvider.fetchAttendingEvents();
      }

      // Create sets of IDs for faster lookup
      final savedEventIds = userProvider.savedEvents.map((e) => e.id).toSet();
      final attendingEventIds =
          userProvider.attendingEvents.map((e) => e.id).toSet();

      // Update each event with proper status
      for (var i = 0; i < pageResponse.content.length; i++) {
        final event = pageResponse.content[i];
        pageResponse.content[i] = event.copyWith(
          eventSaved: savedEventIds.contains(event.id),
          eventAttending: attendingEventIds.contains(event.id),
        );
      }
    } catch (e) {
      print('Error updating events with user status: $e');
    }
  }

  void updateSearchResults(PageResponse<Event> results) {
    _searchResults = results;
    notifyListeners();
  }

    // Add this method to EventProvider
  void resetEventStatuses() {
    bool hasUpdated = false;
    
    // Helper function to reset status in a list
    void resetStatusInList(List<Event>? events) {
      if (events == null || events.isEmpty) return;
      
      for (var i = 0; i < events.length; i++) {
        final event = events[i];
        if (event.eventSaved || event.eventAttending) {
          events[i] = event.copyWith(
            eventSaved: false,
            eventAttending: false
          );
          hasUpdated = true;
        }
      }
    }
    
    // Helper function to reset status in a PageResponse
    void resetStatusInPageResponse(PageResponse<Event>? page) {
      if (page == null) return;
      resetStatusInList(page.content);
    }
    
    // Reset in all locations
    resetStatusInPageResponse(_events);
    resetStatusInPageResponse(_mainEvents);
    resetStatusInPageResponse(_promotedEvents);
    resetStatusInPageResponse(_filteredEvents);
    resetStatusInPageResponse(_searchResults);
    
    // Reset selected event if needed
    if (_selectedEvent != null && (_selectedEvent!.eventSaved || _selectedEvent!.eventAttending)) {
      _selectedEvent = _selectedEvent!.copyWith(
        eventSaved: false,
        eventAttending: false
      );
      hasUpdated = true;
    }
    
    if (hasUpdated) {
      notifyListeners();
    }
  }
}
