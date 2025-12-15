import 'package:flutter/material.dart';
import 'package:oc_academy_app/data/models/home/course_progress_response.dart';

class TestPrepProgressCard extends StatefulWidget {
  final CourseProgressDetail data;

  const TestPrepProgressCard({Key? key, required this.data}) : super(key: key);

  @override
  State<TestPrepProgressCard> createState() => _TestPrepProgressCardState();
}

class _TestPrepProgressCardState extends State<TestPrepProgressCard> {
  // If null, "Overall Progress" is selected.
  // If not null, the specific subject is selected.
  DetailedProgress? _selectedDetail;

  @override
  void initState() {
    super.initState();
    // Default to "Overall Progress" (null)
    _selectedDetail = null;
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
    // FIX: Using Expanded here ensures the two stat boxes in _buildDetailStats
    // divide the available space equally, preventing horizontal overflow.
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
                  // FIX: Ensure value text doesn't overflow the small stat box
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              maxLines: 1, // FIX: Ensure label doesn't wrap/overflow vertically
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // Custom Vertical Bar Chart Widget
  Widget _buildBarChart() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      height: 300, // Fixed height for the chart area
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Y-Axis Labels (These have a fixed, non-expanding width)
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('100%', style: TextStyle(color: Colors.grey, fontSize: 14)),
              Text('75%', style: TextStyle(color: Colors.grey, fontSize: 14)),
              Text('50%', style: TextStyle(color: Colors.grey, fontSize: 14)),
              Text('25%', style: TextStyle(color: Colors.grey, fontSize: 14)),
              Text('0%', style: TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
          const SizedBox(width: 8), // Reduced gap slightly
          // Vertical Divider
          Container(width: 1, color: Colors.grey[300]),
          const SizedBox(width: 8), // Reduced gap slightly
          // Bars (This is the most critical part to use Expanded)
          // FIX: Expanded ensures the bar chart area uses all REMAINING space.
          Expanded(
            child: widget.data.detailedProgress!.isEmpty
                ? const Center(child: Text("No Data"))
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final dataLength = widget.data.detailedProgress!.length;

                      // FIX: Calculate width per bar to fit all.
                      // If dataLength is small, the calculated width will be large,
                      // but constraints.maxWidth prevents it from causing an overflow.
                      final barWidth = 60.0; // Fixed width for readability

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        // FIX: Added SingleChildScrollView to allow bars to scroll
                        // if the number of subjects exceeds screen width.
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .start, // Align to start for scrolling
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: widget.data.detailedProgress!.map((detail) {
                            final double percent =
                                ((detail.progressPercent ?? 0) / 100.0).clamp(
                                  0.0,
                                  1.0,
                                );

                            return Padding(
                              padding: const EdgeInsets.only(
                                right: 16.0,
                              ), // Space between bars
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedDetail = detail;
                                  });
                                },
                                child: Tooltip(
                                  message:
                                      "${detail.name}\n${detail.progressPercent}%",
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // The Bar
                                      Container(
                                        width: barWidth,
                                        height:
                                            (constraints.maxHeight * 0.9) *
                                            percent,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF285698),
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(4),
                                          ),
                                        ),
                                      ),
                                      // X-Axis Label/Marker
                                      Container(
                                        height: 1,
                                        width: barWidth,
                                        color: const Color(0xFF285698),
                                        margin: const EdgeInsets.only(top: 2),
                                      ),
                                      // FIX: Added X-Axis label for bars
                                      SizedBox(
                                        width: barWidth,
                                        child: Text(
                                          detail.name ?? '',
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFF285698),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Widget for the Detailed View (Stats)
  Widget _buildDetailStats() {
    final progressValue = _selectedDetail?.progress ?? '0/0';
    final timeSpentValue = _formatDuration(_selectedDetail?.totalTimeSpent);

    // This Row is where the overflow was also likely happening.
    // The use of Expanded inside _buildStatBox corrects this.
    return Row(
      children: [
        _buildStatBox(
          icon: Icons.checklist,
          value: progressValue,
          label: _selectedDetail?.progressTitle ?? 'Module Progress',
        ),
        const SizedBox(width: 16),
        _buildStatBox(
          icon: Icons.access_time,
          value: timeSpentValue,
          label: 'Total Time Spent',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.detailedProgress == null ||
        widget.data.detailedProgress!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
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
                // Dropdown (No layout changes needed here)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 2.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<DetailedProgress?>(
                      value: _selectedDetail,
                      isExpanded: true,
                      isDense: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.blue,
                      ),
                      // Prepare Items List
                      items: [
                        // 1. Overall Progress Item
                        const DropdownMenuItem<DetailedProgress?>(
                          value: null,
                          child: Text(
                            "Overall Progress",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        // 2. Map detailed items
                        ...widget.data.detailedProgress!.map((detail) {
                          return DropdownMenuItem<DetailedProgress?>(
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
                        }),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedDetail = value;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Content: Graph OR Detail Stats based on selection
                _selectedDetail == null
                    ? Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              "Course Progress",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          _buildBarChart(),
                          const SizedBox(height: 8),
                          const Text(
                            "Subjects",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Click/Hover over a bar to see subject/module name and progress",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      )
                    : _buildDetailStats(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
