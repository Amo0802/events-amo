import 'package:events_amo/models/event.dart';
import 'package:events_amo/providers/event_provider.dart';
import 'package:events_amo/widgets/featured_event_card.dart';
import 'package:events_amo/widgets/standard_event_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Fetch data when widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<EventProvider>(context, listen: false);
      provider.fetchPromotedEvents();
      provider.fetchMainEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<EventProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return CustomScrollView(
              slivers: [
                _buildAppBar(context),
                _buildPromotedEvents(
                  context,
                  provider.promotedEvents?.content ?? [],
                ),
                _buildUpcomingEvents(
                  context,
                  provider.mainEvents?.content ?? [],
                ),
              ],
            );
          },
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
      // actions: [
      //   IconButton(
      //     icon: Icon(
      //       Icons.notifications_outlined,
      //       color: Colors.white,
      //       size: 28,
      //     ),
      //     onPressed: () {
      //       // Navigate to notifications
      //     },
      //   ),
      //   SizedBox(width: 10),
      // ],
    );
  }

  Widget _buildPromotedEvents(
    BuildContext context,
    List<Event> promotedEvents,
  ) {
    if (promotedEvents.isEmpty) {
      return SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.amber),
                SizedBox(width: 8),
                Text(
                  "Promoted Events",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          CarouselSlider.builder(
            itemCount: promotedEvents.length,
            itemBuilder: (context, index, _) {
              final event = promotedEvents[index];
              return FeaturedEventCard(event: event);
            },
            options: CarouselOptions(
              height: 320,
              enlargeCenterPage: true,
              autoPlay: true,
              viewportFraction: 0.85,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEvents(BuildContext context, List<Event> events) {
    if (events.isEmpty) return SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Row(
              children: [
                Icon(
                  Icons.event_available,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                SizedBox(width: 8),
                Expanded(
                  // Wrap in Expanded
                  child: Text(
                    "Upcoming Official Events",
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis, // Add this
                  ),
                ),
              ],
            ),
          );
        }
        final event = events[index - 1];
        return StandardEventCard(event: event);
      }, childCount: events.length + 1),
    );
  }
}
