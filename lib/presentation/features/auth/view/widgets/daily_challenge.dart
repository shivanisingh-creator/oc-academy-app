import 'package:flutter/material.dart';

/// A customizable card widget for promoting a daily challenge or static content.
///
/// It features a solid background color, a title, a description, and a primary
/// action button. It also includes an optional background icon/illustration.
class DailyChallengeCard extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final Color backgroundColor;
  final Color titleColor;
  final Color descriptionColor;

  const DailyChallengeCard({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onButtonPressed,
    this.backgroundColor = const Color(0XFF3359A7), // Primary Blue from image
    this.titleColor = Colors.white,
    this.descriptionColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // The main container styled as a card
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24.0),
      child: Stack(
        children: [
          // Optional: Background Illustration/Icon (Static visual element)
          Positioned(
            right: 0,
            bottom: 0,
            child: Opacity(
              opacity: 0.1,
              child: Transform.rotate(
                angle: -0.1, // Slight rotation for effect
                child: const Icon(
                  Icons.text_snippet, // Using a generic code icon for placeholder
                  color: Colors.white,
                  size: 150,
                ),
              ),
            ),
          ),
          
          // Main Content Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                title,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 8),

              // Description
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.83, // Restrict width to make room for background illustration
                child: Text(
                  description,
                  style: TextStyle(
                    color: descriptionColor,
                    fontSize: 14,
                    height: 1.4,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Action Button
              ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // White background as per image
                  foregroundColor: backgroundColor, // Text color matches card background
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}