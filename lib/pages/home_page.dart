// Home Page - Official Events
import 'package:events_amo/widgets/featured_event_card.dart';
import 'package:events_amo/widgets/standard_event_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> featuredEvents = [
    {
      'title': 'Tech Summit 2025',
      'image': 'https://images.unsplash.com/photo-1505373877841-8d25f7d46678?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
      'date': DateTime(2025, 5, 15),
      'location': 'Digital Conference Center',
      'isPromoted': true,
    },
    {
      'title': 'Annual Music Festival',
      'image': 'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
      'date': DateTime(2025, 6, 20),
      'location': 'City Park',
      'isPromoted': true,
    },
    {
      'title': 'Art Exhibition Opening',
      'image': 'https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
      'date': DateTime(2025, 5, 5),
      'location': 'Modern Art Gallery',
      'isPromoted': false,
    },
    {
      'title': 'Startup Weekend',
      'image': 'https://images.unsplash.com/photo-1543269865-cbf427effbad?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
      'date': DateTime(2025, 5, 10),
      'location': 'Innovation Hub',
      'isPromoted': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            _buildPromotedEvents(context),
            _buildUpcomingEvents(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floating: true,
      title: Row(
        children: [
          Text(
            "Neo",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Text(
            "Events",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () {
            // Navigate to notifications
          },
        ),
        SizedBox(width: 10),
      ],
    );
  }

  Widget _buildPromotedEvents(BuildContext context) {
    final promotedEvents = featuredEvents.where((event) => event['isPromoted']).toList();
    
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  "Promoted Events",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 320,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: promotedEvents.length,
              itemBuilder: (context, index) {
                final event = promotedEvents[index];
                return FeaturedEventCard(
                  title: event['title'],
                  imageUrl: event['image'],
                  date: event['date'],
                  location: event['location'],
                  isPromoted: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEvents(BuildContext context) {
    final standardEvents = featuredEvents.where((event) => !event['isPromoted']).toList();
    
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                children: [
                  Icon(
                    Icons.event_available,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Upcoming Official Events",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }
          final eventIndex = index - 1;
          if (eventIndex < standardEvents.length) {
            final event = standardEvents[eventIndex];
            return StandardEventCard(
              title: event['title'],
              imageUrl: event['image'],
              date: event['date'],
              location: event['location'],
            );
          }
          return null;
        },
        childCount: standardEvents.length + 1,
      ),
    );
  }
}