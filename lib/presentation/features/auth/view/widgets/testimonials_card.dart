import 'package:flutter/material.dart';
import 'package:oc_academy_app/data/models/home/testimonial_response.dart';
import 'package:oc_academy_app/data/repositories/home_repository.dart';

// --- Reusable Testimonial Card Widget (The content unit) ---
/// Displays a single testimonial with profile image, quote, name, and designation.
class TestimonialCard extends StatelessWidget {
  final Testimonial testimonial;

  const TestimonialCard({super.key, required this.testimonial});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Image
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.network(
                testimonial.contentUrl ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.person, size: 60, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Quote
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              '"${testimonial.description ?? ''}"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: Color(0xFF4A4A4A), // Dark grey for text
                height: 1.5,
                fontFamily: 'Inter',
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Name
          Text(
            "${testimonial.title ?? ''} ${testimonial.name ?? ''}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937), // Primary dark text color
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

// --- 3. Custom Dot Indicator Widget ---
class DotIndicator extends StatelessWidget {
  final bool isActive;

  const DotIndicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1F2937) : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// --- 4. Swipable Widget with Indicator (The main container) ---
/// A swipable carousel of testimonials with a page indicator.
class TestimonialSlider extends StatefulWidget {
  const TestimonialSlider({super.key});

  @override
  State<TestimonialSlider> createState() => _TestimonialSliderState();
}

class _TestimonialSliderState extends State<TestimonialSlider> {
  final PageController _pageController = PageController();
  final HomeRepository _homeRepository = HomeRepository();
  List<Testimonial> _testimonials = [];
  bool _isLoading = true;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _fetchTestimonials();
    _pageController.addListener(_onPageChanged);
  }

  Future<void> _fetchTestimonials() async {
    try {
      final response = await _homeRepository.getTestimonials();
      if (mounted) {
        setState(() {
          _testimonials = response?.response ?? [];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onPageChanged() {
    // Ensure page value is not null before rounding
    if (_pageController.hasClients && _pageController.page != null) {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_testimonials.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Main Title
        const Text(
          "What Our Students Say",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 40),

        // Swipable Testimonial Area
        SizedBox(
          height: 400, // Fixed height for PageView content
          child: PageView.builder(
            controller: _pageController,
            itemCount: _testimonials.length,
            itemBuilder: (context, index) {
              return TestimonialCard(testimonial: _testimonials[index]);
            },
          ),
        ),

        // Page Indicator (Dots)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _testimonials.length,
            (index) => DotIndicator(isActive: index == _currentPage),
          ),
        ),
      ],
    );
  }
}
