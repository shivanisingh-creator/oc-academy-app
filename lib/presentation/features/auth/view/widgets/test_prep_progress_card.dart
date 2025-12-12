import 'package:flutter/material.dart';
import 'package:oc_academy_app/data/models/home/course_progress_response.dart';

class TestPrepProgressCard extends StatefulWidget {
  final CourseProgressDetail data;

  const TestPrepProgressCard({Key? key, required this.data}) : super(key: key);

  @override
  State<TestPrepProgressCard> createState() => _TestPrepProgressCardState();
}

class _TestPrepProgressCardState extends State<TestPrepProgressCard> {
  DetailedProgress? _selectedDetail;

  @override
  void initState() {
    super.initState();
    // Default to the first detailed progress item if available
    if (widget.data.detailedProgress != null &&
        widget.data.detailedProgress!.isNotEmpty) {
      _selectedDetail = widget.data.detailedProgress!.first;
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
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFF3359A7),
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
    // If no details, maybe don't render or handle gracefully?
    // For now, let's assume if there's no detailedProgress, we might show
    // the top level progress or just return empty.
    if (widget.data.detailedProgress == null ||
        widget.data.detailedProgress!.isEmpty) {
      // Only if no detailed progress, we fallback to showing generic info?
      // But user said "in that card the dropdown will be respective 'detailedProgress' name"
      // So this widget relies on detailedProgress being present.
      return const SizedBox.shrink();
    }

    // Ensure selected is valid
    if (_selectedDetail == null && widget.data.detailedProgress!.isNotEmpty) {
      _selectedDetail = widget.data.detailedProgress!.first;
    }

    final progressValue = _selectedDetail?.progress ?? '0/0';
    final timeSpentValue = _formatDuration(_selectedDetail?.totalTimeSpent);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title (The Course Name, e.g. "MRCP - Part 1")
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.data.name ?? 'Course',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          // Main Container
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
                // Dropdown (Detailed Progress Items)
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
                    child: DropdownButton<DetailedProgress>(
                      value: _selectedDetail,
                      isExpanded: true,
                      isDense: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.blue,
                      ),
                      items: widget.data.detailedProgress!.map((detail) {
                        return DropdownMenuItem<DetailedProgress>(
                          value: detail,
                          child: Text(
                            detail.name ?? '',
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
                            _selectedDetail = value;
                          });
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Stats Row
                Row(
                  children: [
                    _buildStatBox(
                      icon: Icons.checklist,
                      value: progressValue,
                      label:
                          _selectedDetail?.progressTitle ?? 'Module Progress',
                    ),
                    const SizedBox(width: 16),
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
