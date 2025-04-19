import 'package:events_amo/widgets/comunity_event_card.dart';
import 'package:flutter/material.dart';

// Community Events Page
class CommunityEventsPage extends StatelessWidget {
  final List<Map<String, dynamic>> communityEvents = [
    {
      'title': 'Weekly Yoga in the Park',
      'image': 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
      'date': DateTime(2025, 4, 25),
      'location': 'Central Park',
      'organizer': 'Mindful Movement',
      'attendees': 18,
      'category': 'wellness',
    },
    {
      'title': 'Board Games Night',
      'image': 'https://images.unsplash.com/photo-1610890716171-6b1bb98ffd09?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
      'date': DateTime(2025, 4, 22),
      'location': 'The Game Café',
      'organizer': 'Game Enthusiasts',
      'attendees': 24,
      'category': 'social',
    },
    {
      'title': 'Urban Photography Walk',
      'image': 'https://images.unsplash.com/photo-1512790182412-b19e6d62bc39?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
      'date': DateTime(2025, 4, 30),
      'location': 'Downtown',
      'organizer': 'Shot Perfect',
      'attendees': 12,
      'category': 'arts',
    },
    {
      'title': 'Trail Running Group',
      'image': 'https://images.unsplash.com/photo-1502904550040-7534597429ae?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
      'date': DateTime(2025, 4, 27),
      'location': 'Mountain Trails',
      'organizer': 'Trail Blazers',
      'attendees': 8,
      'category': 'sports',
    },
    {
      'title': 'Coding Workshop: Web 5.0',
      'image': 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
      'date': DateTime(2025, 5, 3),
      'location': 'Digital Hub',
      'organizer': 'Code Masters',
      'attendees': 32,
      'category': 'learning',
    },
  ];

  final List<String> categories = [
    'all', 'wellness', 'social', 'arts', 'sports', 'learning', 'food', 'music'
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            _buildCategoryFilter(context),
            _buildEventsList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floating: true,
      title: Text(
        "Community Events",
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.filter_list,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () {
            // Open filter
          },
        ),
        SizedBox(width: 10),
      ],
    );
  }

  Widget _buildCategoryFilter(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FilterChip(
                label: Text(
                  category.toUpperCase(),
                  style: TextStyle(
                    color: category == 'all' 
                        ? Colors.white 
                        : Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: category == 'all' 
                    ? Theme.of(context).colorScheme.tertiary.withOpacity(0.3) 
                    : Theme.of(context).scaffoldBackgroundColor,
                selected: category == 'all',
                onSelected: (bool selected) {
                  // Filter events
                },
                selectedColor: Theme.of(context).colorScheme.tertiary.withOpacity(0.3),
                checkmarkColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: category == 'all'
                        ? Theme.of(context).colorScheme.tertiary
                        : Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEventsList(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (index < communityEvents.length) {
            final event = communityEvents[index];
            return CommunityEventCard(
              title: event['title'],
              imageUrl: event['image'],
              date: event['date'],
              location: event['location'],
              organizer: event['organizer'],
              attendees: event['attendees'],
              category: event['category'],
            );
          }
          return null;
        },
        childCount: communityEvents.length,
      ),
    );
  }
}