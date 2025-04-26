import 'package:events_amo/models/event.dart';
import 'package:events_amo/models/page_response.dart';
import 'package:events_amo/providers/auth_provider.dart';
import 'package:events_amo/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:events_amo/widgets/comunity_event_card.dart';
import 'package:events_amo/providers/event_provider.dart';

class SearchResultsPage extends StatefulWidget {
  final String query;

  const SearchResultsPage({super.key, required this.query});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<EventProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      provider.searchEvents(widget.query).then((_) {
        // After loading search results, update with user's saved/attending status if logged in
        if (authProvider.status == AuthStatus.authenticated && 
            provider.searchResults != null) {
          _updateEventsWithUserStatus(
            provider, 
            userProvider,
            provider.searchResults!
          );
        }
      });
    });
  }
  
  // Helper method to update events with user's status
  Future<void> _updateEventsWithUserStatus(
      EventProvider eventProvider, 
      UserProvider userProvider,
      PageResponse<Event> pageResponse) async {
    if (pageResponse.content.isEmpty) return;
    
    try {
      // Fetch user's saved and attending events if not already loaded
      if (userProvider.savedEvents.isEmpty) {
        await userProvider.fetchSavedEvents();
      }
      if (userProvider.attendingEvents.isEmpty) {
        await userProvider.fetchAttendingEvents();
      }
      
      // Create sets of IDs for faster lookup
      final savedEventIds = userProvider.savedEvents.map((e) => e.id).toSet();
      final attendingEventIds = userProvider.attendingEvents.map((e) => e.id).toSet();
      
      // Update each event with proper status
      final updatedEvents = pageResponse.content.map((event) {
        return event.copyWith(
          eventSaved: savedEventIds.contains(event.id),
          eventAttending: attendingEventIds.contains(event.id)
        );
      }).toList();
      
      // Update the PageResponse with the new list
      final updatedPageResponse = PageResponse(
        content: updatedEvents,
        pageNumber: pageResponse.pageNumber,
        pageSize: pageResponse.pageSize,
        totalElements: pageResponse.totalElements,
        totalPages: pageResponse.totalPages,
        currentPageNumberOfElements: pageResponse.currentPageNumberOfElements,
        last: pageResponse.last
      );
      
      // Update the provider's state
      eventProvider.updateSearchResults(updatedPageResponse);
    } catch (e) {
      print('Error updating events with user status: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Results"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Consumer<EventProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (provider.searchResults?.content == null ||
              provider.searchResults!.content.isEmpty) {
            return Center(child: Text("No results found for '${widget.query}'"));
          } else {
            final events = provider.searchResults!.content;
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                return CommunityEventCard(event: events[index]);
              },
            );
          }
        },
      ),
    );
  }
}
