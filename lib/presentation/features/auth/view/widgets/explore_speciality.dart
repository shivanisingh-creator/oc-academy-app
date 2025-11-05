import 'package:flutter/material.dart';

class ExploreBySpecialtySection extends StatelessWidget {
  final List<SpecialtyData> specialties;
  final Color accentBlue;

  const ExploreBySpecialtySection({
    required this.specialties,
    required this.accentBlue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        const Padding(
          padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 10.0),
          child: Text(
            'Explore by Specialty',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        // Horizontal Scrollable List of Pills
        SizedBox(
          height: 120, // Height to accommodate the circle and the text label
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: specialties.length,
            itemBuilder: (context, index) {
              final specialty = specialties[index];
              return SpecialtyPillItem( // <-- NOW USING THE NEW, SEPARATE CLASS
                specialty: specialty,
                accentColor: accentBlue,
                isPillSelected: index == 0, // Mocking the first pill (Cardiology) as selected/active
              );
            },
          ),
        ),
      ],
    );
  }
}

// NEW: Specialty Pill Item (The single, reusable item in the horizontal list)
class SpecialtyPillItem extends StatelessWidget {
  final SpecialtyData specialty;
  final Color accentColor;
  final bool isPillSelected;

  const SpecialtyPillItem({
    required this.specialty,
    required this.accentColor,
    required this.isPillSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the color and border based on the selection state
    final Color iconColor = accentColor; // Changed: All icons are now the accent color.
    final Color pillBackgroundColor = isPillSelected ? accentColor.withOpacity(0.1) : Colors.grey.shade100;

    return Padding(
      padding: const EdgeInsets.only(right: 20.0), // Changed: Increased spacing.
      child: Column(
        children: [
          // Circular Icon Container
          Container(
            width: 80, // Changed: Made circle bigger.
            height: 80, // Changed: Made circle bigger.
            decoration: BoxDecoration(
              color: pillBackgroundColor,
              shape: BoxShape.circle,
              // border property removed as per request.
            ),
            child: Icon(
              specialty.icon,
              color: iconColor,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          // Text Label
          Text(
            specialty.name,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: isPillSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
class SpecialtyData {
  final String name;
  final IconData icon;

  SpecialtyData({required this.name, required this.icon});
}
