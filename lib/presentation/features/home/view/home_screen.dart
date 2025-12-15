import 'package:flutter/material.dart';

// --- 1. Data Model for Navigation Items ---
/// Defines the structure for each item in the bottom navigation bar.
class NavItem {
  final String label;
  final IconData icon;

  const NavItem({required this.label, required this.icon});
}

// --- 2. The Reusable Widget ---
/// A custom-styled bottom navigation bar with rounded corners and a label.
class CustomBottomNavBar extends StatelessWidget {
  /// The list of items to display.
  final List<NavItem> items;

  /// The index of the currently selected item.
  final int selectedIndex;

  /// The callback function when an item is tapped.
  final ValueChanged<int> onItemSelected;

  /// The color for the active icon and label.
  final Color activeColor;

  /// The color for inactive icons and labels.
  final Color inactiveColor;

  const CustomBottomNavBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
    this.activeColor = const Color(0xFF285698), // Primary Blue
    this.inactiveColor = const Color(0xFF6B7280), // Neutral Gray
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Container to give the bar its rounded top corners and elevation
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -5), // Shadow pointing up
          ),
        ],
      ),
      height: 80, // A fixed height for a clean look
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = index == selectedIndex;

          // Individual Nav Item Button
          return InkWell(
            onTap: () => onItemSelected(index),
            // Use a Column to stack the icon and label vertically
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  size: 24,
                  color: isSelected ? activeColor : inactiveColor,
                ),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected ? activeColor : inactiveColor,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _screens = [
    const Center(child: Text('Home Screen Content')),
    const Center(child: Text('Courses Screen Content')),
    const Center(child: Text('Profile Screen Content')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: _screens[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        items: const [
          NavItem(label: 'Home', icon: Icons.home),
          NavItem(label: 'Courses', icon: Icons.book),
          NavItem(label: 'Profile', icon: Icons.person),
        ],
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
    );
  }
}
