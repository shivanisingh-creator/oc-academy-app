import 'package:flutter/material.dart';

// Data model for a single timeline event
class TimelineActivity {
  final String title;
  final String date;
  final String course;
  final Color courseColor; // To differentiate the course line color

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
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline Line and Dot
          Column(
            children: [
              // The dot
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: activity.courseColor,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ), // Gives a nice effect
                ),
              ),
              // The line
              Expanded(
                child: Container(
                  width: 2,
                  color: isLast
                      ? Colors.transparent
                      : activity.courseColor.withOpacity(0.5),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16.0),

          // Activity Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : 20.0,
              ), // Padding between items
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                  // Optional: A divider for extra separation if needed
                  // const SizedBox(height: 8.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
