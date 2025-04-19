// Event Detail Page - Shows when an event container is tapped
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDetailPage extends StatefulWidget {
  final Map<String, dynamic> eventData;
  final bool isOfficial;

  const EventDetailPage({
    Key? key, 
    required this.eventData,
    this.isOfficial = false,
  }) : super(key: key);

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  bool isSaved = false;
  bool isAttending = false;
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEventHeader(context),
                _buildEventActions(context),
                _buildEventDetails(context),
                _buildOrganizerInfo(context),
                _buildAttendeesList(context),
                _buildRelatedEvents(context),
                SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: widget.isOfficial ? null : _buildAttendButton(context),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Event Image
            Image.network(
              widget.eventData['image'] ?? 'https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
              fit: BoxFit.cover,
            ),
            // Gradient overlay for text visibility
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            // Category badge if it's a community event
            if (!widget.isOfficial && widget.eventData['category'] != null)
              Positioned(
                top: 80,
                left: 16,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(widget.eventData['category'], context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.eventData['category'].toString().toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            // Promoted badge
            if (widget.isOfficial && widget.eventData['isPromoted'] == true)
              Positioned(
                top: 80,
                right: 16,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "PROMOTED",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      leading: InkWell(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: EdgeInsets.only(left: 16, top: 16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 16, top: 16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              Icons.share_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              // Share event
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 16, top: 16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                isSaved = !isSaved;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEventHeader(BuildContext context) {
    final date = widget.eventData['date'] as DateTime? ?? DateTime.now();
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            widget.eventData['title'] ?? 'Event Title',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          // Date and time
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('EEEE, MMMM d, yyyy').format(date),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      DateFormat('h:mm a').format(date),
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          // Location
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.eventData['location'] ?? 'Event Location',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Tap for directions",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Row(
        children: [
          // Attending count
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.people_alt_outlined,
                  color: Theme.of(context).colorScheme.tertiary,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  "${widget.eventData['attendees'] ?? 0} attending",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          // Calendar button
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                Icons.calendar_month_outlined,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
                // Add to calendar
              },
            ),
          ),
          SizedBox(width: 12),
          // Notification button
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                Icons.notifications_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                // Set reminder
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventDetails(BuildContext context) {
    // Mock description for demo
    final description = widget.eventData['description'] ?? 
      "Join us for an amazing event that you won't want to miss! This event features top speakers, interactive workshops, and networking opportunities with like-minded individuals. We'll be covering the latest trends and innovations in the field, with hands-on demonstrations and opportunities to try out new technologies. Refreshments will be provided throughout the day, and there will be plenty of time for questions and discussions.";
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "About Event",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isExpanded ? description : description.length > 150 ? "${description.substring(0, 150)}..." : description,
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              if (description.length > 150)
                TextButton(
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Text(
                    isExpanded ? "Show less" : "Read more",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(80, 30),
                    alignment: Alignment.centerLeft,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrganizerInfo(BuildContext context) {
    // Only show for community events
    if (widget.isOfficial) return SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Organizer",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Color(0xFF1A1F38),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.eventData['organizer'] ?? 'Event Organizer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "17 events hosted",
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // View organizer profile
                  },
                  child: Text("View"),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendeesList(BuildContext context) {
    // Mock attendees data
    final attendees = [
      {'name': 'Jane Smith', 'image': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80'},
      {'name': 'Mike Johnson', 'image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80'},
      {'name': 'Sarah Wilson', 'image': 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80'},
      {'name': 'David Brown', 'image': 'https://images.unsplash.com/photo-1499996860823-5214fcc65f8f?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80'},
      {'name': 'Others', 'image': ''},
    ];
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Attendees",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // View all attendees
                },
                child: Text("View All"),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              // Display first 4 attendees as overlapping circle avatars
              for (int i = 0; i < attendees.length - 1; i++)
                Container(
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage(attendees[i]['image']!),
                  ),
                ),
              // The "more" circle
              Container(
                margin: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 2,
                  ),
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.transparent,
                  child: Text(
                    "+${(widget.eventData['attendees'] ?? 0) - 4}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              // Status text
              if (isAttending)
                Text(
                  "You're attending",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedEvents(BuildContext context) {
    // Only show for official events
    if (!widget.isOfficial) return SizedBox.shrink();
    
    // Mock related events
    final relatedEvents = [
      {
        'title': 'Workshop: Advanced Techniques',
        'image': 'https://images.unsplash.com/photo-1551434678-e076c223a692?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
        'date': DateTime.now().add(Duration(days: 10)),
      },
      {
        'title': 'Panel Discussion: Future Trends',
        'image': 'https://images.unsplash.com/photo-1515187029135-18ee286d815b?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
        'date': DateTime.now().add(Duration(days: 12)),
      },
    ];
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Related Events",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: relatedEvents.length,
              itemBuilder: (context, index) {
                final event = relatedEvents[index];
                return Container(
                  width: 280,
                  margin: EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color(0xFF1A1F38),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        child: Image.network(
                          event['image'] as String,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Content
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event['title'] as String,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 14,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  DateFormat('MMM d').format(event['date'] as DateTime),
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 55,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                isAttending = !isAttending;
              });
            },
            child: Text(
              isAttending ? "Cancel Attendance" : "Attend Event",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isAttending 
                  ? Colors.grey[800] 
                  : Theme.of(context).colorScheme.secondary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category, BuildContext context) {
    switch (category) {
      case 'wellness':
        return Colors.green;
      case 'social':
        return Colors.blue;
      case 'arts':
        return Colors.purple;
      case 'sports':
        return Colors.orange;
      case 'learning':
        return Colors.red;
      case 'food':
        return Colors.amber;
      case 'music':
        return Colors.pink;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }
}