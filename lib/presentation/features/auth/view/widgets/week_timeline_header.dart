import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeeklyTimelineHeader extends StatelessWidget {
  const WeeklyTimelineHeader({super.key});

  // Logic to calculate the start and end date of the current week
  String _getCurrentWeekRange() {
    final now = DateTime.now();
    // Find the start of the week (Monday)
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    // Find the end of the week (Sunday)
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    // Format for display (e.g., "Dec 1 - Dec 7, 2025")
    final formatter = DateFormat('MMM d, yyyy');
    final startDayFormat = DateFormat('MMM d');

    final startString = startDayFormat.format(startOfWeek);
    final endString = formatter.format(endOfWeek);

    // If the week crosses months, show month for both
    if (startOfWeek.month != endOfWeek.month) {
      return '${DateFormat('MMM d').format(startOfWeek)} - ${formatter.format(endOfWeek)}';
    }

    return '$startString - ${formatter.format(endOfWeek)}';
  }

  @override
  Widget build(BuildContext context) {
    final weekRange = _getCurrentWeekRange();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Arrow Button (not strictly needed by the screenshot, but good for UI)
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 18,
              color: Colors.grey,
            ),
            onPressed: () {
              // TODO: Implement logic to move to the previous week
            },
          ),

          // Current Week Display
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weekRange,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const Text(
                      '(Current Week)',
                      style: TextStyle(fontSize: 10, color: Colors.blue),
                    ),
                  ],
                ),
                // This is a placeholder for the right-side range, which is part of the full widget
                // but kept simple here as the "Current Week" is the focus.
                const SizedBox(width: 12),
                Text(
                  'Dec 8 - Dec 14, 2025', // Placeholder for next week range
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          // Right Arrow Button
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Colors.grey,
            ),
            onPressed: () {
              // TODO: Implement logic to move to the next week
            },
          ),
        ],
      ),
    );
  }
}
