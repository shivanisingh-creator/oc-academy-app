import 'package:flutter/material.dart';

// --- Reusable Widget ---

/// A reusable card widget designed to promote a referral program.
class ReferralCard extends StatelessWidget {
  /// Optional callback for when the card is tapped.
  final VoidCallback? onTap;

  const ReferralCard({super.key, this.onTap});

  // Custom colors derived from the image analysis
  static const Color _primaryBlue = Color(0xFF1A237E); // Deep blue for the icon background
  static const Color _lightBlueBackground = Color(0xFFF3F7FF); // Very light blue background for the card
  static const Color _lightBlueBorder = Color(0xFFCCD6E9); // Subtle border color

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      // The Outer Container simulates the subtle, bordered, rounded box
      child: Container(
        height: 110,
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: _lightBlueBackground,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: _lightBlueBorder,
            width: 1.0,
            // A subtle box shadow adds depth, complementing the light border look
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left: Circular Icon
            CircleAvatar(
              radius: 24,
              backgroundColor: _primaryBlue,
              child: const Icon(
                Icons.card_giftcard, // Using a gift card icon as it fits the "Rewards" theme
                color: Colors.white,
                size: 26,
              ),
            ),
            
            const SizedBox(width: 12.0),

            // Center: Title and Description Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'Roboto', // Use a standard font
                        color: Colors.black87,
                      ),
                      children: [
                        // "Refer a Friend & Earn"
                        TextSpan(
                          text: 'Refer a Friend & Earn ',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            height: 1.2, // Tighter line height for the title block
                          ),
                        ),
                        // "Rewards" on a new line (simulated by the line-breaking of the TextSpan)
                        TextSpan(
                          text: 'Rewards',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 4.0),
                  
                  // Description Text
                  const Text(
                    'Share the gift of knowledge and get rewarded.',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 12.5,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Right: Trailing Arrow Icon
            const Icon(
              Icons.keyboard_arrow_right,
              color: Colors.black45,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}