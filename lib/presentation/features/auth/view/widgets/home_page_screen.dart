import 'package:flutter/material.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MedicalAcademyScreen(),
    );
  }
}

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

  @override
  void initState() {
    super.initState();
    _fetchBanners();
    _fetchTrendingCourses();
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
    const Color primaryDark = Color(0xFF1A237E);
    // A distinct blue for the button
    const Color accentBlue = (Color(0XFF3359A7));
    final List<BlogData> mockBlogs = [
      BlogData(
        category: 'PEDIATRICS',
        title: 'Navigating the Challenges of Modern Pediatrics',
        readTime: '5 min read',
        imageUrl: 'assets/images/mrcp.png',
      ),
      BlogData(
        category: 'CARDIOLOGY',
        title: 'The Future of Cardiology: AI and Predictive Analytics',
        readTime: '8 min read',
        imageUrl: 'assets/images/mrcp.png',
      ),
      BlogData(
        category: 'CARDIOLOGY',
        title: 'The Future of Cardiology: AI and Predictive Analytics',
        readTime: '8 min read',
        imageUrl: 'assets/images/mrcp.png',
      ),
    ];
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
      NavItem(label: "Profile", icon: Icons.person_outline),
    ];
    int _selectedIndex = 0;
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomNavBar(
        items: navItems,
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
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
            Container(
              margin: const EdgeInsets.only(top: 10.0, right: 10, left: 10),
              decoration: BoxDecoration(
                color: Colors
                    .white, // Slightly lighter dark background for the card
                borderRadius: BorderRadius.circular(12.0),
                border: (Border.all(color: Color(0XFFD6D6D6))),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'CONTINUE LEARNING',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Course Image Placeholder
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: primaryDark.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.white),
                          ),
                          child: const Center(
                            // Placeholder for the icon/image
                            child: Icon(
                              Icons.medical_services_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        // Course Details
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Clinical Fellowship in',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Paediatrics',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Module 1: Definition, Prevalence...',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    '60%',
                                    style: TextStyle(
                                      color: Color(0XFF3359A7),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: 0.6, // 60% progress
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          accentBlue,
                        ),
                        minHeight: 5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Resume Learning Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle button press
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentBlue, // Button color
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Resume Learning',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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

            BlogPostsSection(blogs: mockBlogs),
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
            const SizedBox(height: 10.0),
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
            const SizedBox(height: 20.0),

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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Referral card tapped! Navigating to referral page...',
                    ),
                  ),
                );
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
