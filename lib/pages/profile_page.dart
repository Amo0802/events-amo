import 'package:events_amo/widgets/profile_event_card.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            _buildProfileHeader(context),
            _buildStatsSection(context),
            _buildTabSection(context),
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
              child: Text("Edit Profile"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
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
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
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

  Widget _buildTabSection(BuildContext context) {
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
                  _buildUpcomingEvents(context),
                  _buildPastEvents(context),
                  _buildSavedEvents(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingEvents(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20),
      itemCount: 3,
      itemBuilder: (context, index) {
        return ProfileEventCard(
          title: "Board Games Night",
          date: DateTime(2025, 4, 22),
          location: "The Game Café",
          imageUrl: "https://images.unsplash.com/photo-1610890716171-6b1bb98ffd09?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
        );
      },
    );
  }

  Widget _buildPastEvents(BuildContext context) {
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

  Widget _buildSavedEvents(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20),
      itemCount: 2,
      itemBuilder: (context, index) {
        return ProfileEventCard(
          title: "Tech Summit 2025",
          date: DateTime(2025, 5, 15),
          location: "Digital Conference Center",
          imageUrl: "https://images.unsplash.com/photo-1505373877841-8d25f7d46678?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
        );
      },
    );
  }
}
