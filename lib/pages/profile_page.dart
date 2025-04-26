import 'package:events_amo/models/event.dart';
import 'package:events_amo/providers/user_provider.dart';
import 'package:events_amo/widgets/profile_event_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    final dummyEvents = [
      Event(
        id: 1,
        name: "Sample Music Festival",
        imageUrl: "https://via.placeholder.com/400",
        startDateTime: DateTime.now().add(Duration(days: 2)),
        city: 'BERANE',
        address: "29 novembra",
        price: 50,
        categories: ['ART'],
        description: "A fun day of music and vibes.",
      ),
    ];
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            _buildProfileHeader(context),
            _buildStatsSection(context),
            _buildTabSection(context, user.attendingEvents.isEmpty ? dummyEvents : user.attendingEvents, user.savedEvents.isEmpty ? dummyEvents : user.savedEvents),
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
        "My Profile",
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.settings_outlined,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () {
            // Navigate to settings
          },
        ),
        SizedBox(width: 10),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80'),
            ),
            SizedBox(height: 16),
            Text(
              "Alex Johnson",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Event Enthusiast • Joined Dec 2024",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Edit profile
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
                foregroundColor: Theme.of(context).colorScheme.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 1.5,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: Text("Edit Profile"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStat(context, "Events\nAttended", "18"),
            _buildStat(context, "Events\nCreated", "5"),
            _buildStat(context, "Friends", "34"),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildTabSection(BuildContext context, List<Event> attendingEvents, List<Event> savedEvents) {
    return SliverToBoxAdapter(
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            SizedBox(height: 20),
            TabBar(
              tabs: [
                Tab(text: "Upcoming"),
                Tab(text: "Past"),
                Tab(text: "Saved"),
              ],
              labelColor: Theme.of(context).colorScheme.secondary,
              unselectedLabelColor: Colors.grey[500],
              indicatorColor: Theme.of(context).colorScheme.secondary,
              indicatorSize: TabBarIndicatorSize.label,
            ),
            Container(
              height: 400,
              padding: EdgeInsets.only(top: 20),
              child: TabBarView(
                children: [
                  _buildUpcomingEvents(context, attendingEvents),
                  _buildPastEvents(context, attendingEvents),
                  _buildSavedEvents(context, savedEvents),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingEvents(BuildContext context, List<Event> attendingEvents) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20),
      itemCount: 1,
      itemBuilder: (context, index) {
        return ProfileEventCard(
          event: attendingEvents[index],
        );
      },
    );
  }

  Widget _buildPastEvents(BuildContext context, List<Event> attendingEvents) {
    return Center(
      child: Text(
        "You have no past events",
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildSavedEvents(BuildContext context, List<Event> savedEvents) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20),
      itemCount: 1,
      itemBuilder: (context, index) {
        return ProfileEventCard(
          event: savedEvents[index],
        );
      },
    );
  }
}
