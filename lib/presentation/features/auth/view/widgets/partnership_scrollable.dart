import 'package:flutter/material.dart';
import 'dart:async';

// --- Reusable Widget ---

class PartnershipScroller extends StatefulWidget {
  const PartnershipScroller({super.key});

  @override
  State<PartnershipScroller> createState() => _PartnershipScrollerState();
}

class _PartnershipScrollerState extends State<PartnershipScroller> {
  // A sample list of partner names (used to simulate logo images)
  final List<String> _partners = const [
    'Microsoft', 'Google', 'AWS', 'Cisco', 'IBM', 'Oracle', 'Adobe',
    // Duplicate the list to ensure smooth, continuous scrolling without gaps
    'Microsoft', 'Google', 'AWS', 'Cisco', 'IBM', 'Oracle', 'Adobe',
  ];

  final ScrollController _scrollController = ScrollController();
  late Timer _timer;
  final Duration _scrollDuration = const Duration(milliseconds: 50); // Speed of each scroll step
  final double _scrollStep = 1.0; // Distance to scroll in each step (1 pixel)
  final Duration _initialDelay = const Duration(seconds: 2); // Wait before starting scroll

  @override
  void initState() {
    super.initState();
    // Start the auto-scrolling logic after an initial delay
    Future.delayed(_initialDelay, () {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(_scrollDuration, (timer) {
      if (!_scrollController.hasClients) return;

      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentOffset = _scrollController.offset;

      // Check if we need to loop back
      // The scrollable width is the original list's width (maxScroll / 2)
      double originalListEnd = maxScroll / 2;

      if (currentOffset >= maxScroll) {
        // If we hit the absolute end, jump back to the start of the duplicated list section
        _scrollController.jumpTo(originalListEnd);
      } else {
        // Scroll forward
        _scrollController.animateTo(
          currentOffset + _scrollStep,
          duration: _scrollDuration,
          curve: Curves.linear,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Section
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Text(
            'Our Esteemed Partnerships',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),

        // Partnership Scroller Container
        SizedBox(
          height: 80, // Fixed height for the partnership row
          child: ListView.builder(
            controller: _scrollController,
            physics: const NeverScrollableScrollPhysics(), // Disable manual scrolling
            scrollDirection: Axis.horizontal,
            itemCount: _partners.length,
            itemBuilder: (context, index) {
              return PartnerLogo(name: _partners[index]);
            },
          ),
        ),
      ],
    );
  }
}

// --- Partner Logo Item Widget ---

class PartnerLogo extends StatelessWidget {
  final String name;

  const PartnerLogo({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140, // Fixed width for each logo item
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      // Styling mimics a clean, subtle logo box
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          // In a real app, this would be an Image.asset or Image.network
          '$name Logo',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}