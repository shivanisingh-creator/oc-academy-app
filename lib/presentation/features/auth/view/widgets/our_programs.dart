import 'package:flutter/material.dart';

class ProgramCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String duration;
  final String count;
  final String description;

  const ProgramCard({
    required this.imageUrl,
    required this.title,
    required this.duration,
    required this.count,
    required this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // The distinct blue color used for the 'Learn More' link
    const Color accentBlue = (Color(0XFF3359A7));

    return Container(
      width: 260, 
      margin: const EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade300, width: 1), // Light grey border
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
            child: Image.asset(
              // NOTE: Use a placeholder image since the actual assets are not available
              imageUrl,
              height: 140, // Fixed height for the image
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 140,
                color: Colors.blueGrey.shade100,
                alignment: Alignment.center,
                child: const Text('Placeholder Image', style: TextStyle(color: Colors.black54)),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Duration and Count Row
                Row(
                  children: [
                    // Duration Column
                    _DetailColumn(label: 'Duration', value: duration),
                    const SizedBox(width: 20),
                    // Count Column
                    _DetailColumn(label: 'Courses', value: count),
                  ],
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),

                // Learn More Link
                InkWell(
                  onTap: () {
                    // Handle navigation
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Learn More',
                        style: TextStyle(
                          color: accentBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios, color: accentBlue, size: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Helper widget for the detail columns (Duration, Courses)
class _DetailColumn extends StatelessWidget {
  final String label;
  final String value;

  const _DetailColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}


// Container for the horizontally scrolling list of programs
class ExploreProgramsSection extends StatelessWidget {
  const ExploreProgramsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data based on the image
    final List<Map<String, String>> programs = [
      {
        'title': 'Certification Courses',
        'duration': '4 months',
        'count': '50+',
        'description': 'Short-term upskilling in various medical specialties.',
        // Mock image path. Please update this in your assets folder.
        'imageUrl': 'assets/images/mrcp.png', 
      },
      {
        'title': 'Post Graduation',
        'duration': '12 months',
        'count': '15+',
        'description': 'Flexible, self-paced learning to advance their chosen career path.',
        // Mock image path. Please update this in your assets folder.
        'imageUrl': 'assets/images/mrcp.png',
      },
      {
        'title': 'Diploma Programs',
        'duration': '6 months',
        'count': '10+',
        'description': 'Gain a quick specialization in a medical field.',
        // Mock image path. Please update this in your assets folder.
        'imageUrl': 'assets/images/mrcp.png',
      },
    ];

    return SizedBox(
      height: 350, // Sufficient height for the cards to display fully
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: programs.length,
        itemBuilder: (context, index) {
          final program = programs[index];
          return ProgramCard(
            imageUrl: program['imageUrl']!,
            title: program['title']!,
            duration: program['duration']!,
            count: program['count']!,
            description: program['description']!,
          );
        },
      ),
    );
  }
}