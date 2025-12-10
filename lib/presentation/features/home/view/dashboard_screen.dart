import 'package:flutter/material.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/course_card.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/logbook_card.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/verification_card.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/week_timeline_header.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/weekline_activity_widget.dart';
import 'package:oc_academy_app/data/repositories/home_repository.dart';
import 'package:oc_academy_app/data/models/user_courses/user_courses_response.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final HomeRepository _homeRepository = HomeRepository();
  List<UserCourse> _myCourses = [];
  bool _isLoadingCourses = true;

  // Dummy data for weekly schedule (Keeping as is for now)
  final List<Map<String, dynamic>> _weeklySchedule = const [
    {
      'course': 'Certification Course in Cardiac Anaesthesia',
      'activities': [
        {
          'number': 1,
          'title': 'Live Class: Introduction to Cardiac Anatomy',
          'tag': 'Live Class',
          'color': Colors.redAccent,
        },
        {
          'number': 2,
          'title': 'Quiz: Week 1 Assessment',
          'tag': 'Quiz',
          'color': Colors.orange,
        },
      ],
    },
    {
      'course': 'Clinical Course in Advanced Trauma Life Support',
      'activities': [
        {
          'number': 1,
          'title': 'Reading: Trauma Protocols',
          'tag': 'Reading',
          'color': Colors.blue,
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserCourses();
  }

  Future<void> _fetchUserCourses() async {
    final response = await _homeRepository.getUserCourses();
    if (mounted && response?.response?.pendingCourses != null) {
      setState(() {
        _myCourses = response!.response!.pendingCourses!;
        _isLoadingCourses = false;
      });
    } else {
      if (mounted) {
        setState(() {
          _isLoadingCourses = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          children: <Widget>[
            // 1. Get Verified Section
            const VerificationCard(),

            const SizedBox(height: 24.0),

            // 2. Logbook Section
            const LogbookCard(),

            const SizedBox(height: 32.0),

            // 3. My Courses Section Header
            const Text(
              'My Courses',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16.0),

            // 4. My Courses Horizontal List
            SizedBox(
              height: 280, // Adjust height based on content
              child: _isLoadingCourses
                  ? const Center(child: CircularProgressIndicator())
                  : _myCourses.isEmpty
                  ? const Center(child: Text("No courses found"))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _myCourses.length,
                      itemBuilder: (context, index) {
                        final course = _myCourses[index];
                        // Determine color based on index for variety since API doesn't provide color
                        final List<Color> colors = [
                          Colors.redAccent,
                          Colors.teal,
                          Colors.purple,
                          Colors.blue,
                          Colors.orange,
                        ];
                        final color = colors[index % colors.length];

                        return CourseCard(
                          title: course.courseName ?? 'Unknown Course',
                          batchDate: course.endDate != null
                              ? DateTime.fromMillisecondsSinceEpoch(
                                  course.endDate!,
                                ).toString().split(' ')[0]
                              : 'N/A', // Simple date formatting
                          imageBackgroundColor: color,
                        );
                      },
                    ),
            ),

            const SizedBox(height: 32.0),

            // 5. Your Week Section Header
            const Text(
              'Your Week',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16.0),

            // 6. Weekly Timeline Header
            const WeeklyTimelineHeader(),

            const SizedBox(height: 16.0),

            // 7. Weekly Activities List
            ..._weeklySchedule.map((schedule) {
              final activities =
                  (schedule['activities'] as List<Map<String, dynamic>>)
                      .map(
                        (act) => WeeklyActivity(
                          number: act['number'],
                          title: act['title'],
                          tag: act['tag'],
                          tagColor: act['color'],
                        ),
                      )
                      .toList();

              return WeeklyActivityCard(
                courseTitle: schedule['course'],
                activities: activities,
              );
            }).toList(),

            const SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
    ),
  );
}
