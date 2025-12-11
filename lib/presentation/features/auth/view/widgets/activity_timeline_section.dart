import 'package:flutter/material.dart';
import 'package:oc_academy_app/data/models/home/recent_activity.dart';
import 'activity_timeline.dart'; // Import the reusable item widget

class ActivityTimelineSection extends StatelessWidget {
  final List<RecentActivity> activities;

  ActivityTimelineSection({super.key, required this.activities});

  // Helper to get month name (could be moved to a utility class)
  String _getMonth(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }

  // Helper to assign colors based on course name (can be expanded)
  Color _getColorForCourse(String courseName) {
    switch (courseName) {
      case 'Clinical Fellowship in Internal Medicine':
        return const Color(0xFF1976D2); // Blue accent
      case 'Clinical Fellowship in Surgery':
        return Colors.green;
      case 'Certification in Metabolic Diseases':
        return Colors.purple;
      case 'Certification Course in Cardiac Anaesthesia':
        return Colors.red;
      default:
        return Colors.grey; // Default color for other courses
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        const Text(
          'Activity Timeline',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16.0),

        // Timeline List Container
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 12,
                offset: const Offset(0, 6), // Strong bottom shadow
              ),
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              // Reusing the single ActivityTimelineItem widget
              ...activities.asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value;
                return _buildActivityItem(data, index);
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(RecentActivity data, int index) {
    // Convert timestamp to readable date if possible, or use a placeholder
    // Assuming lastVisit is epoch millis
    final date = DateTime.fromMillisecondsSinceEpoch(data.lastVisit);
    // Simple formatting, could use intl package if available
    final dateString = "${date.day} ${_getMonth(date.month)} ${date.year}";

    final activity = TimelineActivity(
      status: data.status,
      name: data.name,
      date: dateString,
      course: data.courseName,
      courseColor: _getColorForCourse(data.courseName),
    );

    return ActivityTimelineItem(
      activity: activity,
      // Important: Check if it's the last item
      isLast: index == activities.length - 1,
    );
  }
}
