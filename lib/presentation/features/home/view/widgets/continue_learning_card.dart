import 'package:flutter/material.dart';
import 'package:oc_academy_app/data/models/home/recent_activity.dart';
// timeago library is not needed if you display the date as '3rd Dec 2025'

class ContinueLearningCard extends StatelessWidget {
  final RecentActivity activity;

  const ContinueLearningCard({super.key, required this.activity});

  // Helper to format the timestamp into the required '3rd Dec 2025' format
  String _formatLastAccessed(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    // Simple formatting for the required style (3rd Dec 2025)
    // NOTE: This is a simplified helper. A more robust solution would use
    // intl package for localized and proper date suffixes (1st, 2nd, 3rd, etc.)
    final day = date.day;
    final suffix = (day % 10 == 1 && day % 100 != 11)
        ? 'st'
        : (day % 10 == 2 && day % 100 != 12)
        ? 'nd'
        : (day % 10 == 3 && day % 100 != 13)
        ? 'rd'
        : 'th';

    final monthNames = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final month = monthNames[date.month];
    final year = date.year;

    return '$day$suffix $month $year';
  }

  @override
  Widget build(BuildContext context) {
    // Determine the formatted date string
    final lastAccessedString = _formatLastAccessed(activity.lastVisit);

    // Define the custom gradient colors from the image
    const Color startColor = Color(0xFF285698); // Deeper purple at the top
    const Color endColor = Color(0xFFC93798); // Pink/Magenta at the bottom

    return Container(
      // The image does not show the 'CONTINUE LEARNING' text above,
      // only the main card itself. The initial code's Column structure
      // is removed to focus only on the card as seen in the image.
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: startColor.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        gradient: const LinearGradient(
          colors: [startColor, endColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Section 1: Title and Subtitle
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Continue where you left off',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Jump back into your learning journey.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Section 2: Course Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Icon (Placeholder for the book icon in the image)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(
                      0.2,
                    ), // Light background for the icon
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.book_outlined, // Matching the book icon
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                // Course Text Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Course Name (Top line, smaller text)
                      Text(
                        activity.courseName.toUpperCase(),
                        style: const TextStyle(
                          color:
                              Colors.white70, // Lighter color for course name
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      // Module/Lesson Name (Big text)
                      Text(
                        activity
                            .name, // The module name 'Current advancement in epide...'
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Last accessed date
                      Text(
                        'Last accessed: $lastAccessedString',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24), // Space before the button
          // Section 3: The Button (Matches the white button)
          Container(
            width: double.infinity,
            height: 60, // A standard button height
            margin: const EdgeInsets.all(16.0), // Padding around the button
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 20.0,
                ),
              ),
              onPressed: () {
                // TODO: Implement navigation logic here
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue Learning',
                    style: TextStyle(
                      color:
                          startColor, // Use the primary purple color for the text
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: startColor, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
