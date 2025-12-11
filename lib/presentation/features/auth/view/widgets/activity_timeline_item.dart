import 'package:flutter/material.dart';

// Data model for a single timeline event
class TimelineActivity {
  final String title;
  final String date;
  final String course;
  final Color courseColor;

  TimelineActivity({
    required this.title,
    required this.date,
    required this.course,
    required this.courseColor,
  });
}

class ActivityTimelineItem extends StatelessWidget {
  final TimelineActivity activity;
  final bool isLast;

  const ActivityTimelineItem({
    super.key,
    required this.activity,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    // IntrinsicHeight ensures the timeline line column matches the height of the content row.
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Timeline Line and Dot Column
          Column(
            children: [
              // The dot (Timeline Marker)
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: activity.courseColor,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
              // The line
              Expanded(
                child: Container(
                  width: 2,
                  // The line is transparent for the last item, otherwise it uses the course color
                  color: isLast
                      ? Colors.transparent
                      : activity.courseColor.withOpacity(0.5),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16.0),

          // 2. Activity Content Column
          Expanded(
            child: Padding(
              // Add padding to create space between this item and the next
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Date (aligned left and right)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          activity.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        activity.date,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),

                  // Course Name
                  Text(
                    activity.course,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
