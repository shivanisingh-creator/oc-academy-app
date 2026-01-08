import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oc_academy_app/data/models/home/course_timeline_response.dart';
import 'package:oc_academy_app/data/repositories/home_repository.dart';

class CourseTimelineSection extends StatefulWidget {
  const CourseTimelineSection({super.key});

  @override
  State<CourseTimelineSection> createState() => _CourseTimelineSectionState();
}

class _CourseTimelineSectionState extends State<CourseTimelineSection> {
  final HomeRepository _homeRepository = HomeRepository();
  final ScrollController _weekScrollController = ScrollController();

  late DateTime _currentWeekStart;
  late DateTime _selectedWeekStart;

  CourseTimelineResponse? _timelineData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // Monday of current week
    _currentWeekStart = now.subtract(Duration(days: now.weekday - 1));
    // Remove time components
    _currentWeekStart = DateTime(
      _currentWeekStart.year,
      _currentWeekStart.month,
      _currentWeekStart.day,
    );
    _selectedWeekStart = _currentWeekStart;

    _fetchTimelineData();
  }

  Future<void> _fetchTimelineData() async {
    setState(() => _isLoading = true);
    final startDate = DateFormat('yyyy-MM-dd').format(_selectedWeekStart);
    final endDate = DateFormat(
      'yyyy-MM-dd',
    ).format(_selectedWeekStart.add(const Duration(days: 6)));

    try {
      final data = await _homeRepository.getCourseTimeline(
        startDate: startDate,
        endDate: endDate,
      );
      if (mounted) {
        setState(() {
          _timelineData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _selectWeek(DateTime weekStart) {
    if (weekStart.isAfter(_currentWeekStart)) return; // Disable future weeks
    setState(() {
      _selectedWeekStart = weekStart;
    });
    _fetchTimelineData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with Arrows
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Your Week',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            Row(
              children: [
                _buildArrowButton(
                  icon: Icons.chevron_left,
                  onPressed: () {
                    _selectWeek(
                      _selectedWeekStart.subtract(const Duration(days: 7)),
                    );
                  },
                ),
                const SizedBox(width: 8),
                _buildArrowButton(
                  icon: Icons.chevron_right,
                  onPressed: _selectedWeekStart.isBefore(_currentWeekStart)
                      ? () => _selectWeek(
                          _selectedWeekStart.add(const Duration(days: 7)),
                        )
                      : null,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Week Selector Row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _weekScrollController,
          child: Row(
            children: _generateWeekList()
                .map((week) => _buildWeekCard(week))
                .toList(),
          ),
        ),
        const SizedBox(height: 24),

        // Timeline Content
        _isLoading
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              )
            : _buildTimelineContent(),
      ],
    );
  }

  Widget _buildArrowButton({required IconData icon, VoidCallback? onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, color: onPressed == null ? Colors.grey : Colors.black),
        onPressed: onPressed,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        padding: EdgeInsets.zero,
      ),
    );
  }

  List<DateTime> _generateWeekList() {
    // Generate weeks relative to the selected week to ensure it's always visible
    List<DateTime> weeks = [];
    // Show 2 weeks before and 2 weeks after the selected week
    DateTime start = _selectedWeekStart.subtract(const Duration(days: 14));
    for (int i = 0; i < 5; i++) {
      weeks.add(start.add(Duration(days: i * 7)));
    }
    return weeks;
  }

  Widget _buildWeekCard(DateTime weekStart) {
    final isSelected = weekStart == _selectedWeekStart;
    final isCurrent = weekStart == _currentWeekStart;
    final isFuture = weekStart.isAfter(_currentWeekStart);

    final startDateStr = DateFormat('MMM d').format(weekStart);
    final endDateStr = DateFormat(
      'MMM d, yyyy',
    ).format(weekStart.add(const Duration(days: 6)));

    return GestureDetector(
      onTap: isFuture ? null : () => _selectWeek(weekStart),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0XFF3359A7) : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? const Color(0XFF3359A7)
                      : Colors.grey[300]!,
                ),
              ),
              child: Text(
                '$startDateStr - $endDateStr',
                style: TextStyle(
                  color: isFuture
                      ? Colors.grey
                      : (isSelected ? Colors.white : Colors.black87),
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
            if (isCurrent) ...[
              const SizedBox(height: 4),
              const Text(
                '(Current Week)',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineContent() {
    if (_timelineData == null ||
        _timelineData!.response == null ||
        _timelineData!.response!.courses == null ||
        _timelineData!.response!.courses!.isEmpty) {
      return const Center(
        child: Text('No activities scheduled for this week.'),
      );
    }

    final courses = _timelineData!.response!.courses!;
    return Column(
      children: courses.map((course) => _buildCourseItem(course)).toList(),
    );
  }

  Widget _buildCourseItem(TimelineCourse course) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          course.name ?? '',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (course.subjects != null)
          ...course.subjects!
              .expand((subject) {
                return subject.modules?.map(
                      (module) => _buildModuleCard(module),
                    ) ??
                    const Iterable<Widget>.empty();
              })
              .cast<Widget>()
              .toList(),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildModuleCard(TimelineModule module) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0XFF3359A7).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${module.displayOrder ?? ''}',
            style: const TextStyle(
              color: Color(0XFF3359A7),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          module.name ?? '',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        children: [
          const Divider(height: 1),
          if (module.chapters != null)
            ...module.chapters!
                .map((chapter) => _buildChapterItem(chapter))
                .toList(),
          if (module.quiz != null)
            ...module.quiz!.map((quiz) => _buildQuizItem(quiz)).toList(),
        ],
      ),
    );
  }

  Widget _buildChapterItem(TimelineChapter chapter) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(
            _getChapterIcon(chapter.chapterType),
            size: 20,
            color: Colors.grey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              chapter.name ?? '',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          _buildStatusIndicator(chapter.chapterStatus),
        ],
      ),
    );
  }

  Widget _buildQuizItem(TimelineQuiz quiz) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.quiz_outlined, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              quiz.name ?? '',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          _buildStatusIndicator(quiz.quizStatus),
        ],
      ),
    );
  }

  IconData _getChapterIcon(int? type) {
    switch (type) {
      case 1:
        return Icons.play_circle_outline;
      case 2:
        return Icons.description_outlined;
      case 3:
        return Icons.image_outlined;
      case 4:
        return Icons.quiz_outlined;
      default:
        return Icons.article_outlined;
    }
  }

  Widget _buildStatusIndicator(int? status) {
    // 1: Not started, 2: In progress, 3: Completed
    if (status == 3) {
      return const Icon(Icons.check_circle, color: Color(0XFF3359A7), size: 20);
    }
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey[400]!, width: 2),
      ),
    );
  }
}
