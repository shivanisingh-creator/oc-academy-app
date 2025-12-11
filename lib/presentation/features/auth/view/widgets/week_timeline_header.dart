import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeeklyTimelineHeader extends StatefulWidget {
  const WeeklyTimelineHeader({super.key});

  @override
  State<WeeklyTimelineHeader> createState() => _WeeklyTimelineHeaderState();
}

class _WeeklyTimelineHeaderState extends State<WeeklyTimelineHeader> {
  final ScrollController _scrollController = ScrollController();
  int _weeksToShow = 20; // Start with 20 weeks of history
  final int _weeksIncrement = 10; // Load 10 more weeks when scrolling

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Scroll to show current week (rightmost) after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _onScroll() {
    // Load more past weeks when user scrolls near the left edge
    if (_scrollController.position.pixels <= 200) {
      setState(() {
        _weeksToShow += _weeksIncrement;
      });
      // Maintain scroll position after adding more items
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(200 + (_weeksIncrement * 220.0));
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // Calculate week range for a given offset from current week
  Map<String, dynamic> _getWeekRange(int weekOffset) {
    final now = DateTime.now();
    final startOfCurrentWeek = now.subtract(Duration(days: now.weekday - 1));
    final targetWeekStart = startOfCurrentWeek.add(
      Duration(days: 7 * weekOffset),
    );
    final targetWeekEnd = targetWeekStart.add(const Duration(days: 6));

    final startDayFormat = DateFormat('MMM d');
    final endDayFormat = DateFormat('MMM d, yyyy');

    String rangeText;
    if (targetWeekStart.month != targetWeekEnd.month) {
      rangeText =
          '${startDayFormat.format(targetWeekStart)} - ${endDayFormat.format(targetWeekEnd)}';
    } else {
      rangeText =
          '${startDayFormat.format(targetWeekStart)} - ${endDayFormat.format(targetWeekEnd)}';
    }

    return {
      'range': rangeText,
      'isCurrent': weekOffset == 0,
      'weekOffset': weekOffset,
    };
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: _weeksToShow,
        itemBuilder: (context, index) {
          // Calculate week offset: 0 is current week (rightmost), negative for past weeks
          final weekOffset = index - (_weeksToShow - 1);

          final weekData = _getWeekRange(weekOffset);
          final isCurrent = weekData['isCurrent'] as bool;

          return Container(
            width: 220,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0XFF3359A7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isCurrent ? Colors.white : const Color(0XFF3359A7),
                width: isCurrent ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  weekData['range'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isCurrent
                      ? 'Current Week'
                      : '${weekOffset.abs()} ${weekOffset.abs() == 1 ? 'week' : 'weeks'} ago',
                  style: const TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
