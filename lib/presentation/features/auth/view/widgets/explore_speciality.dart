import 'package:flutter/material.dart';
import 'package:oc_academy_app/data/models/home/specialty_response.dart';
import 'package:oc_academy_app/data/repositories/home_repository.dart';

class ExploreBySpecialtySection extends StatefulWidget {
  final Color accentBlue;

  const ExploreBySpecialtySection({required this.accentBlue, super.key});

  @override
  State<ExploreBySpecialtySection> createState() =>
      _ExploreBySpecialtySectionState();
}

class _ExploreBySpecialtySectionState extends State<ExploreBySpecialtySection> {
  final HomeRepository _homeRepository = HomeRepository();
  List<Specialty> _specialties = [];
  bool _isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchSpecialties();
  }

  Future<void> _fetchSpecialties() async {
    try {
      final response = await _homeRepository.getSpecialties();
      if (mounted) {
        setState(() {
          _specialties = response?.response ?? [];
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_specialties.isEmpty) {
      return const SizedBox.shrink();
    }

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
          height: 140, // Height to accommodate the circle and the text label
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: _specialties.length,
            itemBuilder: (context, index) {
              final specialty = _specialties[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: SpecialtyPillItem(
                  specialty: specialty,
                  accentColor: widget.accentBlue,
                  isPillSelected: index == _selectedIndex,
                ),
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
  final Specialty specialty;
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
    final Color iconColor =
        accentColor; // Changed: All icons are now the accent color.
    final Color pillBackgroundColor = isPillSelected
        ? accentColor.withOpacity(0.1)
        : Colors.grey.shade100;

    return Padding(
      padding: const EdgeInsets.only(
        right: 20.0,
      ), // Changed: Increased spacing.
      child: Column(
        children: [
          // Circular Icon Container
          Container(
            width: 85, // Changed: Made circle bigger.
            height: 85, // Changed: Made circle bigger.
            decoration: BoxDecoration(
              color: pillBackgroundColor,
              shape: BoxShape.circle,
              // border property removed as per request.
            ),
            child: ClipOval(
              child: Image.network(
                specialty.specialityImageUrl ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.local_hospital, color: iconColor, size: 30),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Text Label
          SizedBox(
            width: 80,
            child: Text(
              specialty.specialityName ?? '',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: isPillSelected
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
