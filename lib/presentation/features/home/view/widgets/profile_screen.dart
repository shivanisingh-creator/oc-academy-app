import 'package:flutter/material.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/profile_info_card_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB), // Light grey background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Profile Header & Verification
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF3F51B5),
              child: Text("PP", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            const Text("Dr. ABC", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            // Verification Banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9C4), // Light Yellow
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Verification is required. Get Profile Verification",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF856404), fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 20),

            // 2. Personal Details Card
            ProfileInfoCard(
              title: "Personal Details",
              actions: const [
                Icon(Icons.edit_outlined, size: 20, color: Colors.grey),
                SizedBox(width: 12),
                Icon(Icons.camera_alt_outlined, size: 20, color: Colors.grey),
              ],
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Dr. ABC", style: TextStyle(fontWeight: FontWeight.w500)),
                  const Text("+91 9800122899"),
                  Row(
                    children: const [
                      Text("aa@docademy.com"),
                      SizedBox(width: 8),
                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                    ],
                  ),
                ],
              ),
            ),

            // 3. Medical Details Card
            ProfileInfoCard(
              title: "Medical Details",
              subtitle: "Qualifications, specialty and more",
              actions: const [Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)],
              onTap: () {},
            ),

            // 4. Billing Address Card
            ProfileInfoCard(
              title: "Billing Address",
              actions: const [Icon(Icons.edit_outlined, size: 20, color: Colors.grey)],
              content: const Text(
                "Home\n123, MG Road, Indiranagar,\nBangalore, Karnataka - 560038\nIndia",
                style: TextStyle(height: 1.5),
              ),
            ),

            // 5. Logout Card
            ProfileInfoCard(
              title: "Logout",
              actions: const [Icon(Icons.logout, color: Colors.redAccent)],
              onTap: () {
                // Handle logout logic
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}