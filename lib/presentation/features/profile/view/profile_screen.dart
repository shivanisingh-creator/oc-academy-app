import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_academy_app/data/repositories/home_repository.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/profile_info_card_widget.dart';
import 'package:oc_academy_app/presentation/features/profile/bloc/profile_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProfileBloc(homeRepository: HomeRepository())..add(FetchProfileData()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FB), // Light grey background
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              final user = state.user.response;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // 1. Profile Header & Verification
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: user?.profilePic != null
                          ? NetworkImage(user!.profilePic!)
                          : null,
                      backgroundColor: const Color(0xFF3F51B5),
                      child: user?.profilePic == null
                          ? Text(
                              "${user?.firstName?[0] ?? ''}${user?.lastName?[0] ?? ''}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold),
                            )
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Text(user?.fullName ?? 'Dr. ABC',
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),

                    // Verification Banner
                    if (user?.isDocVerificationReq == true)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF9C4), // Light Yellow
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "Verification is required. Get Profile Verification",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xFF856404),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    const SizedBox(height: 20),

                    // 2. Personal Details Card
                    ProfileInfoCard(
                      title: "Personal Details",
                      actions: const [
                        Icon(Icons.edit_outlined,
                            size: 20, color: Colors.grey),
                        SizedBox(width: 12),
                        Icon(Icons.camera_alt_outlined,
                            size: 20, color: Colors.grey),
                      ],
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user?.fullName ?? 'Dr. ABC',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500)),
                          Text(user?.mobileNumber ?? '+91 9800122899'),
                          Row(
                            children: [
                              Text(user?.email ?? 'aa@docademy.com'),
                              const SizedBox(width: 8),
                              if (user?.isEmailVerified == true)
                                const Icon(Icons.check_circle,
                                    color: Colors.green, size: 16),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // 3. Medical Details Card
                    ProfileInfoCard(
                      title: "Medical Details",
                      subtitle: "Qualifications, specialty and more",
                      actions: const [
                        Icon(Icons.arrow_forward_ios,
                            size: 16, color: Colors.grey)
                      ],
                      onTap: () {},
                    ),

                    // 4. Billing Address Card
                    ProfileInfoCard(
                      title: "Billing Address",
                      actions: const [
                        Icon(Icons.edit_outlined, size: 20, color: Colors.grey)
                      ],
                      content: Text(
                        user?.location ??
                            "Home\n123, MG Road, Indiranagar,\nBangalore, Karnataka - 560038\nIndia",
                        style: const TextStyle(height: 1.5),
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
              );
            } else if (state is ProfileError) {
              return Center(child: Text(state.message));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
