import 'package:flutter/material.dart';

// --- 1. Data Model ---
/// Defines the structure for a single testimonial entry.
class Testimonial {
  final String quote;
  final String name;
  final String designation;
  final String imageUrl;

  const Testimonial({
    required this.quote,
    required this.name,
    required this.designation,
    required this.imageUrl,
  });
}

// Public Mock Data for easy access if needed
const List<Testimonial> mockTestimonials = [
  Testimonial(
    quote:
        "The depth of knowledge and practical insights I gained from the fellowship here is unparalleled. It has truly accelerated my career.",
    name: "Dr. Chloe Sharma",
    designation: "PG Program in Advanced Cardiology",
    imageUrl: "assets/images/mrcp.png",
  ),
  Testimonial(
    quote:
        "An incredible learning journey! The faculty support was exceptional, and the hands-on projects were crucial for mastering the skills.",
    name: "Anya Singh",
    designation: "Masters in Computer Science",
    imageUrl: "assets/images/mrcp.png",
  ),
  Testimonial(
    quote:
        "I highly recommend this program to anyone serious about their career. It opened doors I didn't even know existed. Simply transformative!",
    name: "Ben Lee",
    designation: "Executive MBA Program",
    imageUrl: "assets/images/mrcp.png",
  ),
];

// --- 2. Reusable Testimonial Card Widget (The content unit) ---
/// Displays a single testimonial with profile image, quote, name, and designation.
class TestimonialCard extends StatelessWidget {
  final Testimonial testimonial;

  const TestimonialCard({
    super.key,
    required this.testimonial,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profile Image
        Container(
          width: 120,
          height: 120,
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
              testimonial.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.person, size: 60, color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 30),

        // Quote
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            '"${testimonial.quote}"',
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
        const SizedBox(height: 30),

        // Name
        Text(
          testimonial.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937), // Primary dark text color
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 4),

        // Designation
        Text(
          testimonial.designation,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }
}

// --- 3. Custom Dot Indicator Widget ---
class DotIndicator extends StatelessWidget {
  final bool isActive;

  const DotIndicator({
    super.key,
    required this.isActive,
  });

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
  final List<Testimonial> testimonials;

  const TestimonialSlider({
    super.key,
    this.testimonials = mockTestimonials, // Use mock data as default
  });

  @override
  State<TestimonialSlider> createState() => _TestimonialSliderState();
}

class _TestimonialSliderState extends State<TestimonialSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    if (widget.testimonials.isNotEmpty) {
      _pageController.addListener(_onPageChanged);
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
    if (widget.testimonials.isEmpty) {
      return const Center(child: Text("No testimonials available."));
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
          height: 370, // Fixed height for PageView content
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.testimonials.length,
            itemBuilder: (context, index) {
              return TestimonialCard(testimonial: widget.testimonials[index]);
            },
          ),
        ),

        // Page Indicator (Dots)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.testimonials.length,
            (index) => DotIndicator(
              isActive: index == _currentPage,
            ),
          ),
        ),
      ],
    );
  }
}