import 'package:flutter/material.dart';
import 'package:oc_academy_app/presentation/features/home/view/widgets/continue_learning_card.dart';

import 'package:oc_academy_app/presentation/features/auth/view/widgets/course_card.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/course_progress_card.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/test_prep_progress_card.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/logbook_card.dart';

import 'package:oc_academy_app/presentation/features/auth/view/widgets/verification_card.dart';
import 'package:oc_academy_app/presentation/features/home/view/widgets/course_timeline_section.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/activity_timeline_section.dart';

import 'package:oc_academy_app/data/repositories/home_repository.dart';
import 'package:oc_academy_app/data/models/user_courses/user_courses_response.dart';
import 'package:oc_academy_app/data/models/user/user_lite_response.dart';
import 'package:oc_academy_app/data/models/home/recent_activity.dart';
import 'package:oc_academy_app/data/models/home/course_progress_response.dart';
import 'package:oc_academy_app/data/models/home/live_event_response.dart';
import 'package:oc_academy_app/presentation/features/home/view/widgets/live_streaming_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final HomeRepository _homeRepository = HomeRepository();
  List<UserCourse> _activeCourses = [];
  List<UserCourse> _completedCourses = [];
  bool _isLoadingCourses = true;
  bool _showVerificationCard = false;

  bool _showLogbookCard = false;
  List<RecentActivity> _recentActivities = [];
  bool _isLoadingActivities = true;

  // Course Progress Data from API
  List<CourseCategory> _courseCategories = [];
  LiveEvent? _liveEvent;
  bool _isLoadingLiveEvent = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      // Fetch User Courses
      final coursesFuture = _homeRepository.getUserCourses();
      // Fetch User Lite for permissions
      final userLiteFuture = _homeRepository.getUserLite();
      // Fetch Recent Activity
      final recentActivityFuture = _homeRepository.getRecentActivity();
      // Fetch Course Progress (Certifications, IPGP, etc)
      final courseProgressFuture = _homeRepository.getCourseProgress();
      // Fetch Live Event
      final liveEventFuture = _homeRepository.getLiveEvent();

      final results = await Future.wait([
        coursesFuture,
        userLiteFuture,
        recentActivityFuture,
        courseProgressFuture,
        liveEventFuture,
      ]);
      final coursesResponse = results[0] as UserCoursesResponse?;
      final userLiteResponse = results[1] as UserLiteResponse?;
      final recentActivities = results[2] as List<RecentActivity>?;
      final courseProgressResponse = results[3] as CourseProgressResponse?;

      if (mounted) {
        setState(() {
          // Handle Courses
          final coursesRes = coursesResponse;
          if (coursesRes?.response != null) {
            final allCourses = <UserCourse>[];
            final response = coursesRes!.response!;
            if (response.pendingCourses != null) {
              allCourses.addAll(response.pendingCourses!);
            }
            if (response.completedCourses != null) {
              allCourses.addAll(response.completedCourses!);
            }

            _activeCourses = allCourses
                .where((c) => (c.progress ?? 0) < 100)
                .toList();
            _completedCourses = allCourses
                .where((c) => (c.progress ?? 0) == 100)
                .toList();
          }

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

          // Handle Course Progress (Certifications etc.)
          if (courseProgressResponse?.response != null) {
            _courseCategories = courseProgressResponse!.response!;
          }

          // Handle Live Event
          final liveEventResponse = results[4] as LiveEventResponse?;
          if (liveEventResponse?.response != null) {
            _liveEvent = liveEventResponse!.response;
          }
        });
      }
    } catch (e) {
      debugPrint("Error fetching dashboard data: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingCourses = false;
          _isLoadingActivities = false;
          _isLoadingLiveEvent = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasNoCourses =
        !_isLoadingCourses &&
        _activeCourses.isEmpty &&
        _completedCourses.isEmpty &&
        _courseCategories.every(
          (cat) =>
              cat.courseProgressDetail == null ||
              cat.courseProgressDetail!.isEmpty,
        );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 45.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.withOpacity(0.2), height: 1.0),
        ),
      ),
      body: SafeArea(
        child: _isLoadingCourses
            ? const Center(child: CircularProgressIndicator())
            : hasNoCourses
            ? _buildEmptyState()
            : ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 24.0,
                ),
                children: <Widget>[
                  // CONTINUE LEARNING Section moved to top
                  if (_isLoadingActivities)
                    const Center(child: CircularProgressIndicator())
                  else if (_recentActivities.isNotEmpty) ...[
                    ContinueLearningCard(activity: _recentActivities.first),
                    const SizedBox(height: 16.0),
                  ],

                  if (!_isLoadingLiveEvent &&
                      _liveEvent != null &&
                      _liveEvent!.id != null) ...[
                    LiveStreamingCard(event: _liveEvent!),
                    const SizedBox(height: 16.0),
                  ],
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
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _activeCourses.length,
                      itemBuilder: (context, index) {
                        final course = _activeCourses[index];

                        return CourseCard(
                          title: course.courseName ?? 'Unknown Course',
                          endDate: course.endDate,
                          progress: course.progress,
                          imageUrl: course
                              .twoxThumbnailUrl, // Use 2x thumbnail from API
                        );
                      },
                    ),
                  ),

                  if (_completedCourses.isNotEmpty) ...[
                    const SizedBox(height: 24.0),
                    const Text(
                      'Completed Courses',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      height: 280,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _completedCourses.length,
                        itemBuilder: (context, index) {
                          final course = _completedCourses[index];

                          return CourseCard(
                            title: course.courseName ?? 'Unknown Course',
                            endDate: course.endDate,
                            progress: course.progress,
                            imageUrl: course.twoxThumbnailUrl,
                            isCompleted: true,
                            certificateUrl: course.certificateUrl,
                            startDate: course.startDate,
                          );
                        },
                      ),
                    ),
                  ],

                  const SizedBox(height: 16.0),

                  const SizedBox(height: 16.0),

                  // Dynamic Course Timeline Section
                  const CourseTimelineSection(),

                  const SizedBox(height: 12.0),

                  // Activity Timeline Section (Recent Activities)
                  if (_recentActivities.isNotEmpty)
                    ActivityTimelineSection(activities: _recentActivities),

                  const SizedBox(height: 32.0),

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

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // A friendly illustration or icon could go here
          Icon(
            Icons.menu_book_rounded,
            size: 80,
            color: Colors.grey.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          const Text(
            "Looks like you haven't enrolled for any of our courses yet!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF4B5563),
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Enrol today to start your journey towards excellence in medical education.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Go back to Medical Academy Home
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF285698),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text(
              "Explore",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
