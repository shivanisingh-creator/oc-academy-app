import 'package:flutter/material.dart';
import 'package:oc_academy_app/data/models/home/course_progress_response.dart';

class CertificationProgressCard extends StatefulWidget {
  final CourseCategory category;

  const CertificationProgressCard({Key? key, required this.category})
    : super(key: key);

  @override
  State<CertificationProgressCard> createState() =>
      _CertificationProgressCardState();
}

class _CertificationProgressCardState extends State<CertificationProgressCard> {
  CourseProgressDetail? _selectedCourse;

  @override
  void initState() {
    super.initState();
    // Default to the first course if available
    if (widget.category.courseProgressDetail != null &&
        widget.category.courseProgressDetail!.isNotEmpty) {
      _selectedCourse = widget.category.courseProgressDetail!.first;
    }
  }

  // Helper method to format/display duration string directly from API
  String _formatDuration(String? duration) {
    return duration ?? '0 h : 0 m';
  }

  // Widget for the individual stat boxes (e.g., Module Progress)
  Widget _buildStatBox({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0XFF3359A7), size: 24),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0XFF3359A7),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.category.courseProgressDetail == null ||
        widget.category.courseProgressDetail!.isEmpty) {
      return const SizedBox.shrink(); // Don't render if no courses
    }

    // Ensure selected course is valid if list changed (unlikely here but safe)
    if (_selectedCourse == null &&
        widget.category.courseProgressDetail!.isNotEmpty) {
      _selectedCourse = widget.category.courseProgressDetail!.first;
    }

    // Determine the progress text
    final progressValue = _selectedCourse?.progress ?? '0/0';

    // Time spent
    final timeSpentValue = _formatDuration(_selectedCourse?.totalTimeSpent);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.category.title ?? 'Section',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          // The main container
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
                  offset: const Offset(0, 6),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top: Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 2.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<CourseProgressDetail>(
                      value: _selectedCourse,
                      isExpanded: true,
                      isDense: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.blue,
                      ),
                      items: widget.category.courseProgressDetail!.map((
                        course,
                      ) {
                        return DropdownMenuItem<CourseProgressDetail>(
                          value: course,
                          child: Text(
                            course.name ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedCourse = value;
                          });
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Bottom: Stats Row
                Row(
                  children: [
                    // Module Progress Stat Box
                    _buildStatBox(
                      icon: Icons.checklist,
                      value: progressValue,
                      label:
                          _selectedCourse?.progressTitle ?? 'Module Progress',
                    ),
                    const SizedBox(width: 16),
                    // Total Time Spent Stat Box
                    _buildStatBox(
                      icon: Icons.access_time,
                      value: timeSpentValue,
                      label: 'Total Time Spent',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
