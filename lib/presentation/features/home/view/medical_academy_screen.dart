import 'package:flutter/material.dart';
import 'package:oc_academy_app/core/constants/route_constants.dart';
import 'package:oc_academy_app/data/models/home/banner_response.dart'
    as banner_model;
import 'package:oc_academy_app/data/repositories/home_repository.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/blog_post.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/daily_challenge.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/explore_speciality.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/our_programs.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/partnership_scrollable.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/referal_card.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/testimonials_card.dart';
import 'package:oc_academy_app/presentation/features/home/view/home_screen.dart';
import 'package:oc_academy_app/presentation/global/widgets/courses_card.dart';
import 'package:oc_academy_app/data/models/home/most_enrolled_response.dart';
import 'package:oc_academy_app/presentation/features/home/widgets/trending_course_card.dart';
import 'package:oc_academy_app/presentation/features/home/view/dashboard_screen.dart';
import 'package:oc_academy_app/data/repositories/user_repository.dart';
import 'package:flutter/services.dart';
import 'package:oc_academy_app/presentation/features/home/view/widgets/continue_learning_card.dart';
import 'package:oc_academy_app/data/models/home/recent_activity.dart';
import 'package:oc_academy_app/data/models/blog/blog_post_response.dart';

class MedicalAcademyScreen extends StatefulWidget {
  const MedicalAcademyScreen({super.key});

  @override
  State<MedicalAcademyScreen> createState() => _MedicalAcademyScreenState();
}

class FeaturedCoursesSection extends StatelessWidget {
  final List<FeaturedProgramData> courses;

  const FeaturedCoursesSection({required this.courses, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // Adjust height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return FeaturedCourseCard(program: courses[index]);
        },
      ),
    );
  }
}

class _MedicalAcademyScreenState extends State<MedicalAcademyScreen> {
  final HomeRepository _homeRepository = HomeRepository();
  List<banner_model.Banner> _banners = [];
  bool _isLoadingBanners = true;
  int _currentBannerIndex = 0;
  List<MostEnrolledCourse> _fellowshipCourses = [];
  List<MostEnrolledCourse> _certificationCourses = [];
  bool _isLoadingTrending = true;
  final UserRepository _userRepository = UserRepository();
  String? _referralCode;
  int? _userId;
  List<RecentActivity> _recentActivities = [];
  bool _isLoadingActivities = true;
  List<BlogPostResponse> _blogs = [];
  bool _isLoadingBlogs = true;

  @override
  void initState() {
    super.initState();
    _fetchBanners();
    _fetchTrendingCourses();
    _fetchReferralData();
    _fetchRecentActivities();
    _fetchBlogs();
  }

  Future<void> _fetchBlogs() async {
    try {
      final response = await _homeRepository.getBlogPosts();
      if (mounted) {
        setState(() {
          if (response != null) {
            _blogs = response;
          }
          _isLoadingBlogs = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching blogs: $e");
      if (mounted) {
        setState(() {
          _isLoadingBlogs = false;
        });
      }
    }
  }

  Future<void> _fetchRecentActivities() async {
    try {
      final response = await _homeRepository.getRecentActivity();
      if (mounted) {
        setState(() {
          if (response != null && response.isNotEmpty) {
            _recentActivities = response;
          }
          _isLoadingActivities = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching recent activities: $e");
      if (mounted) {
        setState(() {
          _isLoadingActivities = false;
        });
      }
    }
  }

  Future<void> _fetchReferralData() async {
    try {
      final code = await _homeRepository.getReferralCode();
      final userLite = await _userRepository.getUserLite();
      debugPrint("Referral Code: $code");
      debugPrint("User ID: ${userLite?.response?.userId}");
      if (mounted) {
        setState(() {
          _referralCode = code;
          _userId = userLite?.response?.userId;
        });
      }
    } catch (e) {
      debugPrint("Error fetching referral data: $e");
    }
  }

  Future<void> _fetchBanners() async {
    try {
      final response = await _homeRepository.getBanners();
      if (response != null && response.response != null) {
        setState(() {
          _banners = response.response!;
          _isLoadingBanners = false;
        });
      } else {
        setState(() {
          _isLoadingBanners = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingBanners = false;
      });
    }
  }

  Future<void> _fetchTrendingCourses() async {
    try {
      final fellowshipResponse = await _homeRepository.getMostEnrolledCourses(
        type: 7,
      );
      final certificationResponse = await _homeRepository
          .getMostEnrolledCourses(type: 1);

      if (mounted) {
        setState(() {
          if (fellowshipResponse?.response != null) {
            _fellowshipCourses = fellowshipResponse!.response!;
          }
          if (certificationResponse?.response != null) {
            _certificationCourses = certificationResponse!.response!;
          }
          _isLoadingTrending = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingTrending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // A dark primary color to match the app bar/background
    // A distinct blue for the button
    const Color accentBlue = (Color(0XFF3359A7));

    final List<FeaturedProgramData> mockFeaturedCourses = [
      FeaturedProgramData(
        title: 'International PG Program in Emergency Medicine',
        imageUrl: 'assets/images/mrcp.png',
        accreditedBy: 'UK Universities',
      ),
      FeaturedProgramData(
        title: 'Clinical Fellowship in Diabetes Management',
        imageUrl: 'assets/images/program2.jpg',
        accreditedBy: 'Royal College',
      ),
      FeaturedProgramData(
        title: 'Short Course in Advanced Diagnostics',
        imageUrl: 'assets/images/program3.jpg',
        accreditedBy: 'Global Academy',
      ),
    ];
    // Example Mock Data in _MedicalAcademyScreenState build method:
    const List<NavItem> navItems = [
      NavItem(label: "Home", icon: Icons.home_outlined),
      NavItem(label: "Explore", icon: Icons.search),
      NavItem(label: "Courses", icon: Icons.book_outlined),
      NavItem(label: "Blog", icon: Icons.article_outlined),
      NavItem(label: "Profile", icon: Icons.person_outlined),
    ];
    int _selectedIndex = 0;
    void onItemTapped(int index) {
      if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else if (index == 4) {
        Navigator.pushNamed(context, RouteConstants.profile);
      } else {
        setState(() {
          _selectedIndex = index;
        });
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomNavBar(
        items: navItems,
        selectedIndex: _selectedIndex,
        onItemSelected: onItemTapped,
        // Optional: you can pass activeColor/inactiveColor here if needed
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.45,
              child: Stack(
                children: <Widget>[
                  // Banner carousel
                  if (_isLoadingBanners)
                    Positioned.fill(
                      child: Container(
                        color: Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                    )
                  else if (_banners.isNotEmpty)
                    Positioned.fill(
                      child: PageView.builder(
                        itemCount: _banners.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentBannerIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final banner = _banners[index];
                          return ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                                  Colors.white,
                                  Colors.white,
                                  Colors.black,
                                ],
                                stops: <double>[0.0, 0.7, 1.0],
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.dstIn,
                            child: Image.network(
                              banner.contentAppUrl ?? '',
                              fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: Colors.grey[300],
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          value:
                                              loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                            ),
                          );
                        },
                      ),
                    )
                  else
                    // Fallback to static image if no banners
                    Positioned.fill(
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Colors.white,
                              Colors.white,
                              Colors.black,
                            ],
                            stops: <double>[0.0, 0.7, 1.0],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.dstIn,
                        child: Image.asset(
                          'assets/images/mrcp.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),

                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Logo Section
                          Row(children: <Widget>[
                            ],
                          ),
                          // Title Text
                          Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _banners.isNotEmpty
                          ? List.generate(
                              _banners.length,
                              (index) => _PageIndicatorDot(
                                isActive: index == _currentBannerIndex,
                              ),
                            )
                          : <Widget>[
                              _PageIndicatorDot(isActive: true),
                              _PageIndicatorDot(isActive: false),
                              _PageIndicatorDot(isActive: false),
                              _PageIndicatorDot(isActive: false),
                            ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (_isLoadingActivities)
              Container(
                margin: const EdgeInsets.only(top: 10.0, right: 10, left: 10),
                child: const Center(child: CircularProgressIndicator()),
              )
            else if (_recentActivities.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 10.0, right: 10, left: 10),
                child: ContinueLearningCard(activity: _recentActivities.first),
              )
            else
              Container(
                margin: const EdgeInsets.only(top: 10.0, right: 10, left: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  border: (Border.all(color: Color(0XFFD6D6D6))),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No recent activity found.'),
                ),
              ),

            // Add some padding at the bottom for scroll comfort
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Explore Our Programs',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0), // Added space here
            ExploreProgramsSection(),
            const SizedBox(height: 10.0), // Added space here

            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Latest Blog Post',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0), // Added space here

            if (_isLoadingBlogs)
              const Center(child: CircularProgressIndicator())
            else if (_blogs.isNotEmpty)
              BlogPostsSection(blogs: _blogs)
            else
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text("No blog posts available"),
              ),
            const SizedBox(height: 10.0), // Added space here
            ExploreBySpecialtySection(accentBlue: accentBlue),
            const SizedBox(height: 10.0), // Added space here
            // Example of how it's used inside the FeaturedCoursesSection widget:
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Featured Courses',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            FeaturedCoursesSection(courses: mockFeaturedCourses),
            const SizedBox(height: 5.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Our Esteemed Partnerships',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const PartnershipScroller(),
            const SizedBox(height: 10.0),

            DailyChallengeCard(
              title: "Daily Clinical Challenge",
              description:
                  "Test your knowledge and stay sharp with our daily questions.",
              buttonText: "Take the Challenge",
              onButtonPressed: () {},
            ), // Added space here
            const SizedBox(height: 10.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Top Trending Fellowship Course',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            if (_isLoadingTrending)
              const Center(child: CircularProgressIndicator())
            else if (_fellowshipCourses.isNotEmpty)
              SizedBox(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: _fellowshipCourses.length,
                  itemBuilder: (context, index) {
                    return TrendingCourseCard(
                      course: _fellowshipCourses[index],
                    );
                  },
                ),
              ),
            const SizedBox(height: 20.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Top Trending Certification Course',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            if (_isLoadingTrending)
              const Center(child: CircularProgressIndicator())
            else if (_certificationCourses.isNotEmpty)
              SizedBox(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: _certificationCourses.length,
                  itemBuilder: (context, index) {
                    return TrendingCourseCard(
                      course: _certificationCourses[index],
                    );
                  },
                ),
              ),
            const SizedBox(height: 20.0),
            TestimonialSlider(),
            const SizedBox(height: 20.0),
            ReferralCard(
              onTap: () {
                if (_referralCode != null && _userId != null) {
                  final String referralLink =
                      "https://www.ocacademy.in/filters?referralCode=$_referralCode&utm_source=referralPage&refererId=$_userId";
                  final String message =
                      "Hi, I think OC Academy's specialized courses could enhance your medical career. Explore 100+ courses and get a 5% discount (up to ₹45,000). Let me know if you have questions! $referralLink";

                  Clipboard.setData(ClipboardData(text: message));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Referral link copied to clipboard!'),
                    ),
                  );
                } else {
                  String errorMsg = 'Fetching referral data... please wait.';
                  if (_referralCode == null && _userId != null) {
                    errorMsg = 'Could not fetch referral code.';
                  } else if (_referralCode != null && _userId == null) {
                    errorMsg = 'Could not fetch user ID.';
                  } else if (_referralCode == null && _userId == null) {
                    // Keep default message or say "Failed to load data" if enough time passed?
                    // For now, let's assume it's still loading or failed both.
                    // But if we want to be helpful:
                    errorMsg = 'Referral data not available yet.';
                  }

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(errorMsg)));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Custom widget for the page indicator dots
class _PageIndicatorDot extends StatelessWidget {
  final bool isActive;

  const _PageIndicatorDot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 6.0),
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.blueGrey : Colors.black,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
