import 'package:flutter/material.dart';
import 'package:oc_academy_app/presentation/features/home/view/widgets/continue_learning_card.dart';

import 'package:oc_academy_app/presentation/features/auth/view/widgets/course_card.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/course_progress_card.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/test_prep_progress_card.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/logbook_card.dart';

import 'package:oc_academy_app/presentation/features/auth/view/widgets/verification_card.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/week_timeline_header.dart';

import 'package:oc_academy_app/data/repositories/home_repository.dart';
import 'package:oc_academy_app/data/models/user_courses/user_courses_response.dart';
import 'package:oc_academy_app/data/models/user/user_lite_response.dart';
import 'package:oc_academy_app/data/models/home/recent_activity.dart';
import 'package:oc_academy_app/data/models/home/course_progress_response.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final HomeRepository _homeRepository = HomeRepository();
  List<UserCourse> _myCourses = [];
  bool _isLoadingCourses = true;
  bool _showVerificationCard = false;

  bool _showLogbookCard = false;
  List<RecentActivity> _recentActivities = [];
  bool _isLoadingActivities = true;

  // Course Progress Data from API
  List<CourseCategory> _courseCategories = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    // Fetch User Courses
    final coursesFuture = _homeRepository.getUserCourses();
    // Fetch User Lite for permissions
    final userLiteFuture = _homeRepository.getUserLite();
    // Fetch Recent Activity
    final recentActivityFuture = _homeRepository.getRecentActivity();
    // Fetch Course Progress (Certifications, IPGP, etc)
    final courseProgressFuture = _homeRepository.getCourseProgress();

    final results = await Future.wait([
      coursesFuture,
      userLiteFuture,
      recentActivityFuture,
      courseProgressFuture,
    ]);
    final coursesResponse = results[0] as UserCoursesResponse?;
    final userLiteResponse = results[1] as UserLiteResponse?;
    final recentActivities = results[2] as List<RecentActivity>?;
    final courseProgressResponse = results[3] as CourseProgressResponse?;

    if (mounted) {
      setState(() {
        // Handle Courses
        if (coursesResponse?.response?.pendingCourses != null) {
          _myCourses = coursesResponse!.response!.pendingCourses!;
        }
        _isLoadingCourses = false;

        // Handle User Lite Permissions
        if (userLiteResponse?.response != null) {
          final response = userLiteResponse!.response!;
          // Verification Card Logic
          _showVerificationCard = response.isDocVerificationReq == true;

          // Logbook Card Logic (Check if 'LOGBOOK' is in productAccess)
          _showLogbookCard =
              response.productAccess?.contains('LOGBOOK') ?? false;
        }

        // Handle Recent Activity
        if (recentActivities != null) {
          _recentActivities = recentActivities;
        }
        _isLoadingActivities = false;

        // Handle Course Progress (Certifications etc.)
        if (courseProgressResponse?.response != null) {
          _courseCategories = courseProgressResponse!.response!;
        }
      });
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
            if (_showVerificationCard) ...[
              const VerificationCard(),
              const SizedBox(height: 16.0),
            ],

            // 2. Logbook Section
            if (_showLogbookCard) ...[
              const LogbookCard(),
              const SizedBox(height: 32.0),
            ],

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

                        return CourseCard(
                          title: course.courseName ?? 'Unknown Course',
                          batchDate: course.endDate != null
                              ? DateTime.fromMillisecondsSinceEpoch(
                                  course.endDate!,
                                ).toString().split(' ')[0]
                              : 'N/A', // Simple date formatting
                          imageUrl: course
                              .twoxThumbnailUrl, // Use 2x thumbnail from API
                        );
                      },
                    ),
            ),

            const SizedBox(height: 16.0),

            // 5. Your Week Section Header with Navigation Arrows
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Week',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 20),
                      onPressed: () {
                        // Navigate to previous week
                      },
                      color: const Color(0XFF3359A7),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 20),
                      onPressed: () {
                        // Navigate to next week
                      },
                      color: const Color(0XFF3359A7),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const WeeklyTimelineHeader(),
            const SizedBox(height: 16.0),

            if (_isLoadingActivities)
              const Center(child: CircularProgressIndicator())
            else if (_recentActivities.isNotEmpty)
              ContinueLearningCard(activity: _recentActivities.first),

            const SizedBox(height: 16.0),

            // Certifications/Program Sections powered by API
            ..._courseCategories.expand((category) {
              // Special handling for Test Prep (Type 9)
              if (category.courseType == 9) {
                if (category.courseProgressDetail != null) {
                  return category.courseProgressDetail!.map((detail) {
                    return TestPrepProgressCard(data: detail);
                  });
                }
                return <Widget>[];
              } else {
                // Default handling (Certifications, IPGP)
                return [CertificationProgressCard(category: category)];
              }
            }).toList(),
          ],
        ),
      ),
    );
  }
}
