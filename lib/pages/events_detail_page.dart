import 'package:events_amo/models/event.dart';
import 'package:events_amo/pages/login_page.dart';
import 'package:events_amo/providers/auth_provider.dart';
import 'package:events_amo/providers/event_provider.dart';
import 'package:events_amo/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventDetailPage extends StatefulWidget {
  final Event event;

  const EventDetailPage({super.key, required this.event});

  @override
  EventDetailPageState createState() => EventDetailPageState();
}

class EventDetailPageState extends State<EventDetailPage> {
  late bool isSaved;
  late bool isAttending;
  bool isExpanded = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    isSaved = widget.event.eventSaved;
    isAttending = widget.event.eventAttending;
  }

  void _toggleSave() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final eventProvider = Provider.of<EventProvider>(context, listen: false);

    // Check if user is logged in
    if (authProvider.status != AuthStatus.authenticated) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => LoginPage()));
      return;
    }

    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    userProvider
        .toggleSaveEvent(widget.event.id, isSaved)
        .then((success) {
          if (success) {
            setState(() {
              isSaved = !isSaved;
              
              // Create updated event with new status
              final updatedEvent = widget.event.copyWith(
                eventSaved: isSaved
              );
              
              // Update the event in all locations
              eventProvider.patchLocalEvent(updatedEvent);
            });
          }
        })
        .whenComplete(() {
          setState(() {
            _isProcessing = false;
          });
        });
  }

  void _toggleAttend() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final eventProvider = Provider.of<EventProvider>(context, listen: false);

    // Check if user is logged in
    if (authProvider.status != AuthStatus.authenticated) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => LoginPage()));
      return;
    }

    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    userProvider
        .toggleAttendEvent(widget.event.id, isAttending)
        .then((success) {
          if (success) {
            setState(() {
              isAttending = !isAttending;
              
              // Create updated event with new status
              final updatedEvent = widget.event.copyWith(
                eventAttending: isAttending
              );
              
              // Update the event in all locations
              eventProvider.patchLocalEvent(updatedEvent);
            });
          }
        })
        .whenComplete(() {
          setState(() {
            _isProcessing = false;
          });
        });
  }

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
                SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildAttendButton(context),
    );
  }

  @override
  void dispose() {
    // Return the updated event when navigating back
    Navigator.of(context).pop(widget.event.copyWith(
      eventSaved: isSaved,
      eventAttending: isAttending,
    ));
    super.dispose();
  }


  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(widget.event.imageUrl, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
            if (widget.event.promoted)
              Positioned(
                top: 80,
                right: 16,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: Colors.white, size: 14),
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
        onTap:
            () => Navigator.pop(
              context,
              widget.event.copyWith(
                eventSaved: isSaved,
                eventAttending: isAttending,
              ),
            ),
        child: Container(
          margin: EdgeInsets.only(left: 16, top: 16),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      actions: [
        // Container(
        //   margin: EdgeInsets.only(right: 16, top: 16),
        //   decoration: BoxDecoration(
        //     color: Colors.black.withOpacity(0.4),
        //     shape: BoxShape.circle,
        //   ),
        //   child: IconButton(
        //     icon: Icon(
        //       Icons.share_outlined,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       // Share event
        //     },
        //   ),
        // ),
        Container(
          margin: EdgeInsets.only(right: 16, top: 16),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.white,
            ),
            onPressed: _toggleSave,
          ),
        ),
      ],
    );
  }

  Widget _buildEventHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.event.name,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.calendar_today),
              SizedBox(width: 12),
              Text(
                DateFormat(
                  'EEEE, MMMM d, yyyy • h:mm a',
                ).format(widget.event.startDateTime),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.location_on),
              SizedBox(width: 12),
              Text('${widget.event.address}, ${widget.event.city}'),
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                Icon(Icons.euro, color: Colors.green, size: 18),
                SizedBox(width: 8),
                Text(
                  widget.event.price == 0
                      ? "Free"
                      : "${widget.event.price.toStringAsFixed(2)}€",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventDetails(BuildContext context) {
    final description = widget.event.description;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "About Event",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text(
            isExpanded || description.length < 500
                ? description
                : "${description.substring(0, 500)}...",
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 15,
              height: 1.5,
            ),
          ),
          if (description.length > 150)
            TextButton(
              onPressed: () => setState(() => isExpanded = !isExpanded),
              child: Text(isExpanded ? "Show less" : "Read more"),
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
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 55,
          child: ElevatedButton(
            onPressed: _toggleAttend,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isAttending
                      ? Colors.grey[800]
                      : Theme.of(context).colorScheme.secondary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              isAttending ? "Cancel Attendance" : "Attend Event",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}


  // Widget _buildOrganizerInfo(BuildContext context) {
  //   // Only show for community events
  //   if (widget.isOfficial) return SizedBox.shrink();

  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           "Organizer",
  //           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  //         ),
  //         SizedBox(height: 12),
  //         Container(
  //           padding: EdgeInsets.all(16),
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(16),
  //             color: Color(0xFF1A1F38),
  //           ),
  //           child: Row(
  //             children: [
  //               CircleAvatar(
  //                 radius: 25,
  //                 backgroundImage: NetworkImage(
  //                   'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
  //                 ),
  //               ),
  //               SizedBox(width: 16),
  //               Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       widget.eventData['organizer'] ?? 'Event Organizer',
  //                       style: TextStyle(
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                     SizedBox(height: 4),
  //                     Text(
  //                       "17 events hosted",
  //                       style: TextStyle(color: Colors.grey[400], fontSize: 14),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               TextButton(
  //                 onPressed: () {
  //                   // View organizer profile
  //                 },
  //                 child: Text("View"),
  //                 style: TextButton.styleFrom(
  //                   foregroundColor: Theme.of(context).colorScheme.secondary,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildAttendeesList(BuildContext context) {
  //   // Mock attendees data
  //   final attendees = [
  //     {'name': 'Jane Smith', 'image': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80'},
  //     {'name': 'Mike Johnson', 'image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80'},
  //     {'name': 'Sarah Wilson', 'image': 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80'},
  //     {'name': 'David Brown', 'image': 'https://images.unsplash.com/photo-1499996860823-5214fcc65f8f?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80'},
  //     {'name': 'Others', 'image': ''},
  //   ];

  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               "Attendees",
  //               style: TextStyle(
  //                 fontSize: 22,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 // View all attendees
  //               },
  //               child: Text("View All"),
  //               style: TextButton.styleFrom(
  //                 foregroundColor: Theme.of(context).colorScheme.secondary,
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 12),
  //         Row(
  //           children: [
  //             // Display first 4 attendees as overlapping circle avatars
  //             for (int i = 0; i < attendees.length - 1; i++)
  //               Container(
  //                 margin: EdgeInsets.only(right: 10),
  //                 decoration: BoxDecoration(
  //                   shape: BoxShape.circle,
  //                   border: Border.all(
  //                     color: Theme.of(context).scaffoldBackgroundColor,
  //                     width: 2,
  //                   ),
  //                 ),
  //                 child: CircleAvatar(
  //                   radius: 22,
  //                   backgroundImage: NetworkImage(attendees[i]['image']!),
  //                 ),
  //               ),
  //             // The "more" circle
  //             Container(
  //               margin: EdgeInsets.only(left: 5),
  //               decoration: BoxDecoration(
  //                 shape: BoxShape.circle,
  //                 border: Border.all(
  //                   color: Theme.of(context).scaffoldBackgroundColor,
  //                   width: 2,
  //                 ),
  //                 color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
  //               ),
  //               child: CircleAvatar(
  //                 radius: 22,
  //                 backgroundColor: Colors.transparent,
  //                 child: Text(
  //                   "+${(widget.eventData['attendees'] ?? 0) - 4}",
  //                   style: TextStyle(
  //                     color: Theme.of(context).colorScheme.primary,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(width: 16),
  //             // Status text
  //             if (isAttending)
  //               Text(
  //                 "You're attending",
  //                 style: TextStyle(
  //                   color: Theme.of(context).colorScheme.secondary,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildRelatedEvents(BuildContext context) {
  //   // Only show for official events
  //   if (!widget.isOfficial) return SizedBox.shrink();

  //   // Mock related events
  //   final relatedEvents = [
  //     {
  //       'title': 'Workshop: Advanced Techniques',
  //       'image':
  //           'https://images.unsplash.com/photo-1551434678-e076c223a692?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
  //       'date': DateTime.now().add(Duration(days: 10)),
  //     },
  //     {
  //       'title': 'Panel Discussion: Future Trends',
  //       'image':
  //           'https://images.unsplash.com/photo-1515187029135-18ee286d815b?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
  //       'date': DateTime.now().add(Duration(days: 12)),
  //     },
  //   ];

  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           "Related Events",
  //           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  //         ),
  //         SizedBox(height: 12),
  //         Container(
  //           height: 200,
  //           child: ListView.builder(
  //             scrollDirection: Axis.horizontal,
  //             itemCount: relatedEvents.length,
  //             itemBuilder: (context, index) {
  //               final event = relatedEvents[index];
  //               return Container(
  //                 width: 280,
  //                 margin: EdgeInsets.only(right: 16),
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(16),
  //                   color: Color(0xFF1A1F38),
  //                 ),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     // Image
  //                     ClipRRect(
  //                       borderRadius: BorderRadius.only(
  //                         topLeft: Radius.circular(16),
  //                         topRight: Radius.circular(16),
  //                       ),
  //                       child: Image.network(
  //                         event['image'] as String,
  //                         height: 120,
  //                         width: double.infinity,
  //                         fit: BoxFit.cover,
  //                       ),
  //                     ),
  //                     // Content
  //                     Padding(
  //                       padding: EdgeInsets.all(12),
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             event['title'] as String,
  //                             style: TextStyle(
  //                               fontSize: 16,
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                             maxLines: 1,
  //                             overflow: TextOverflow.ellipsis,
  //                           ),
  //                           SizedBox(height: 8),
  //                           Row(
  //                             children: [
  //                               Icon(
  //                                 Icons.calendar_today,
  //                                 color: Theme.of(context).colorScheme.primary,
  //                                 size: 14,
  //                               ),
  //                               SizedBox(width: 4),
  //                               Text(
  //                                 DateFormat(
  //                                   'MMM d',
  //                                 ).format(event['date'] as DateTime),
  //                                 style: TextStyle(
  //                                   color: Colors.grey[400],
  //                                   fontSize: 12,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }