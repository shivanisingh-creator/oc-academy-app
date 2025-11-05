import 'package:flutter/material.dart';

class TestimonialCard extends StatelessWidget {
  final TestimonialData testimonial;

  const TestimonialCard({
    required this.testimonial,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Profile Picture (Centered)
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
          child: CircleAvatar(
            radius: 50,
            // Placeholder for the profile image (ensure this asset exists)
            backgroundImage: AssetImage(testimonial.imageUrl),
            backgroundColor: Colors.pink.shade100, // Background if image fails to load
          ),
        ),
        const SizedBox(height: 30),

        // 2. The Quote (Italic and centered)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            '"${testimonial.quote}"',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              height: 1.5,
              fontStyle: FontStyle.italic,
              // Match the slightly heavier, elegant look
              fontWeight: FontWeight.w400, 
            ),
          ),
        ),
        const SizedBox(height: 20),

        // 3. Name (Bold)
        Text(
          testimonial.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        // 4. Role/Program
        Text(
          testimonial.role,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
class TestimonialData {
  final String quote;
  final String name;
  final String role;
  final String imageUrl; // For the profile picture

  TestimonialData({
    required this.quote,
    required this.name,
    required this.role,
    required this.imageUrl,
  });
}