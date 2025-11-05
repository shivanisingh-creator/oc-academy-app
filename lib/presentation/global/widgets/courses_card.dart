import 'package:flutter/material.dart';

// NOTE: You will need to define or import the FeaturedProgramData model
// The model is currently defined in main.dart
// class FeaturedProgramData {
//   final String title;
//   final String imageUrl;
//   final String accreditedBy; // e.g., 'UK Universities'
//   // ... other course details
// }

class FeaturedCourseCard extends StatelessWidget {
  final FeaturedProgramData program;

  const FeaturedCourseCard({
    required this.program,
    super.key,
  });

  // Constants for styling
  static const Color accentBlue = Color(0XFF3359A7);
  static const double cardWidth = 260.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      margin: const EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Course Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
            child: Image.asset(
              program.imageUrl,
              height: 150,
              width: cardWidth,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 150,
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                child: const Icon(Icons.school_outlined, size: 50, color: Colors.grey),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Course Title
                Text(
                  program.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Accreditation Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: accentBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.shield_outlined, size: 16, color: accentBlue),
                      const SizedBox(width: 6),
                      Text(
                        'Accredited by ${program.accreditedBy}',
                        style: TextStyle(
                          color: accentBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8), 
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class FeaturedProgramData {
  final String title;
  final String imageUrl;
  final String accreditedBy;
  // ... potentially other properties like duration, shortDescription
  
  FeaturedProgramData({
    required this.title,
    required this.imageUrl,
    required this.accreditedBy,
  });
}