import 'package:events_amo/models/event.dart';
import 'package:events_amo/pages/events_detail_page.dart';
import 'package:events_amo/pages/login_page.dart';
import 'package:events_amo/providers/auth_provider.dart';
import 'package:events_amo/providers/event_provider.dart';
import 'package:events_amo/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommunityEventCard extends StatefulWidget {
  final Event event;

  const CommunityEventCard({super.key, required this.event});

  @override
  State<CommunityEventCard> createState() => _CommunityEventCardState();
}

class _CommunityEventCardState extends State<CommunityEventCard> {
  late bool isAttending;
  late bool isSaved;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    isAttending = widget.event.eventAttending;
    isSaved = widget.event.eventSaved;
  }

  @override
  void didUpdateWidget(CommunityEventCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update local state if the event changes
    if (oldWidget.event.id != widget.event.id ||
        oldWidget.event.eventSaved != widget.event.eventSaved ||
        oldWidget.event.eventAttending != widget.event.eventAttending) {
      setState(() {
        isSaved = widget.event.eventSaved;
        isAttending = widget.event.eventAttending;
      });
    }
  }

  void _toggleAttend() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final eventProvider = Provider.of<EventProvider>(context, listen: false);

    // Check if user is logged in
    if (authProvider.status != AuthStatus.authenticated) {
      // Navigate to login page if not authenticated
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => LoginPage()));
      return;
    }

    // Prevent multiple simultaneous requests
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    // Call the toggle method from UserProvider
    userProvider
        .toggleAttendEvent(widget.event.id, isAttending)
        .then((success) {
          if (success) {
            setState(() {
              isAttending = !isAttending;

              // Create updated event with new status
              final updatedEvent = widget.event.copyWith(
                eventAttending: isAttending,
              );

              // Update the event in all locations
              eventProvider.patchLocalEvent(updatedEvent);
            });
          } else {
            // Show error message if failed
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  userProvider.error ?? 'Failed to update attendance',
                ),
              ),
            );
          }
        })
        .whenComplete(() {
          setState(() {
            _isProcessing = false;
          });
        });
  }

  void _toggleSave() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final eventProvider = Provider.of<EventProvider>(context, listen: false);

    // Check if user is logged in first
    if (authProvider.status != AuthStatus.authenticated) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => LoginPage()));
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
              final updatedEvent = widget.event.copyWith(eventSaved: isSaved);

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
    Provider.of<UserProvider>(context, listen: false);
    final eventProvider = context.read<EventProvider>();
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailPage(event: widget.event),
          ),
        ).then((updatedEvent) {
          // Refresh event status if needed
          if (updatedEvent != null && updatedEvent is Event) {
            eventProvider.patchLocalEvent(
              updatedEvent,
            ); // <-- only update that one
          }
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Color(0xFF1F2533), Color(0xFF131824)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with gradient overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Image.network(
                    widget.event.imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                // Category badge
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(
                        widget.event.categoryLabels,
                        context,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.event.categoryLabels.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                // Date badge
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.tertiary.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          DateFormat(
                            'MMM d',
                          ).format(widget.event.startDateTime),
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
            // Content
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.event.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        widget.event.location,
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                    ],
                  ),
                  // SizedBox(height: 6),
                  // Row(
                  //   children: [
                  //     Icon(
                  //       Icons.person_outline,
                  //       color: Theme.of(context).colorScheme.secondary,
                  //       size: 16,
                  //     ),
                  //     SizedBox(width: 4),
                  //     Text(
                  //       "By $organizer",
                  //       style: TextStyle(
                  //         color: Colors.grey[400],
                  //         fontSize: 14,
                  //       ),
                  //     ),
                  // Spacer(),
                  // Icon(
                  //   Icons.people_outline,
                  //   color: Theme.of(context).colorScheme.secondary,
                  //   size: 16,
                  // ),
                  // SizedBox(width: 4),
                  // Text(
                  //   "$attendees attending",
                  //   style: TextStyle(
                  //     color: Colors.grey[400],
                  //     fontSize: 14,
                  //   ),
                  // ),
                  //   ],
                  // ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: // Update the attend button in build method
                            ElevatedButton(
                          onPressed: _isProcessing ? null : _toggleAttend,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isAttending
                                    ? Colors
                                        .grey[700] // Different color when attending
                                    : Theme.of(context).colorScheme.secondary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: Text(
                            isAttending ? "Cancel Attend" : "Attend",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        icon: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color:
                              isSaved
                                  ? Theme.of(context).colorScheme.tertiary
                                  : Colors.grey[400],
                        ),
                        onPressed: _isProcessing ? null : _toggleSave,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
