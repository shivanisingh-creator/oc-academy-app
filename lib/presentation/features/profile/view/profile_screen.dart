import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_academy_app/core/constants/route_constants.dart';
import 'package:oc_academy_app/data/repositories/login_repository.dart';
import 'package:oc_academy_app/data/repositories/home_repository.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/profile_info_card_widget.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/custom_phone_field.dart';
import 'package:oc_academy_app/presentation/features/profile/bloc/profile_bloc.dart';
import 'package:oc_academy_app/data/models/home/specialty_response.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _selectedQualification;
  List<int> _selectedSpecialtyIds = [];
  List<Specialty> _specialties = [];
  bool _isLoadingSpecialties = true;
  bool _isUpdating = false;
  bool _isEditingName = false;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchSpecialties();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _fetchSpecialties() async {
    try {
      final response = await HomeRepository().getSpecialties();
      if (mounted) {
        setState(() {
          _specialties = response?.response ?? [];
          _isLoadingSpecialties = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching specialties: $e");
      if (mounted) {
        setState(() {
          _isLoadingSpecialties = false;
        });
      }
    }
  }

  void _handleProfileUpdate() async {
    setState(() {
      _isUpdating = true;
    });

    // TODO: Implement actual API call for profile update if endpoint discovered
    debugPrint(
      "Updating profile with: "
      "Name: ${_nameController.text}, "
      "Qualification: $_selectedQualification, "
      "Specialties: $_selectedSpecialtyIds",
    );

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isUpdating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      // Refresh data
      context.read<ProfileBloc>().add(FetchProfileData());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        homeRepository: HomeRepository(),
        authRepository: AuthRepository(),
      )..add(FetchProfileData()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FB), // Light grey background
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is LogoutSuccess) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouteConstants.login,
                (route) => false,
              );
            } else if (state is ProfileError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is ProfileLoaded) {
              final user = state.user.response;
              if (_selectedQualification == null &&
                  user?.qualification != null) {
                setState(() {
                  _selectedQualification = user!.qualification;
                });
              }
              if (_selectedSpecialtyIds.isEmpty &&
                  user?.specialitiesOfInterestIds != null &&
                  user!.specialitiesOfInterestIds!.isNotEmpty) {
                final ids = user.specialitiesOfInterestIds!
                    .map((id) {
                      if (id is int) return id;
                      if (id is String) return int.tryParse(id);
                      return null;
                    })
                    .whereType<int>()
                    .toList();

                setState(() {
                  _selectedSpecialtyIds = ids;
                });
              }
              if (_nameController.text.isEmpty && user?.fullName != null) {
                _nameController.text = user!.fullName!;
              }
            }
          },
          child: BlocBuilder<ProfileBloc, ProfileState>(
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
                                "${_nameController.text.isNotEmpty ? _nameController.text[0] : (user?.firstName?[0] ?? '')}${user?.lastName?[0] ?? ''}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _nameController.text.isNotEmpty
                            ? _nameController.text
                            : (user?.fullName ?? 'Dr. ABC'),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Verification Banner
                      if (user?.isDocVerificationReq == true)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF9C4), // Light Yellow
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "Verification is required. Get Profile Verification",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF856404),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),

                      // 2. Personal Details Card
                      ProfileInfoCard(
                        title: "Personal Details",
                        actions: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _isEditingName = !_isEditingName;
                              });
                            },
                            icon: Icon(
                              _isEditingName
                                  ? Icons.check
                                  : Icons.edit_outlined,
                              size: 20,
                              color: _isEditingName
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          ),
                          const Icon(
                            Icons.camera_alt_outlined,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ],
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_isEditingName)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: TextFormField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Full Name',
                                    isDense: true,
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (val) {
                                    setState(() {}); // Refresh header name
                                  },
                                ),
                              )
                            else
                              Text(
                                _nameController.text.isNotEmpty
                                    ? _nameController.text
                                    : (user?.fullName ?? 'Dr. ABC'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            Text(user?.mobileNumber ?? '+91 9800122899'),
                            Row(
                              children: [
                                Text(user?.email ?? 'aa@docademy.com'),
                                const SizedBox(width: 8),
                                if (user?.isEmailVerified == true)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 16,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // 3. Medical Details Card
                      ProfileInfoCard(
                        title: "Medical Details",
                        actions: const [],
                        initiallyExpanded: false,
                        expandedContent: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomDropdownField(
                              label: '',
                              value:
                                  const [
                                    'MBBS/FMG',
                                    'MD/MSM/DNB',
                                  ].contains(_selectedQualification)
                                  ? _selectedQualification
                                  : null,
                              items: const ['MBBS/FMG', 'MD/MSM/DNB'],
                              onChanged: (val) {
                                setState(() {
                                  _selectedQualification = val;
                                });
                              },
                              hintText: 'Select Qualification',
                            ),
                            const SizedBox(height: 10),
                            (() {
                              final specialtyItems = _specialties
                                  .map((s) => s.specialityName ?? '')
                                  .where((name) => name.isNotEmpty)
                                  .toSet()
                                  .toList();

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomDropdownField(
                                    label: '',
                                    value: null,
                                    items: specialtyItems
                                        .where(
                                          (name) => !_selectedSpecialtyIds.any((
                                            id,
                                          ) {
                                            final specialty = _specialties
                                                .firstWhere(
                                                  (s) => s.specialityId == id,
                                                  orElse: () => Specialty(),
                                                );
                                            return specialty.specialityName ==
                                                name;
                                          }),
                                        )
                                        .toList(),
                                    onChanged: (val) {
                                      if (val != null) {
                                        final selected = _specialties
                                            .firstWhere(
                                              (s) => s.specialityName == val,
                                            );
                                        setState(() {
                                          if (!_selectedSpecialtyIds.contains(
                                            selected.specialityId!,
                                          )) {
                                            _selectedSpecialtyIds.add(
                                              selected.specialityId!,
                                            );
                                          }
                                        });
                                      }
                                    },
                                    hintText: _isLoadingSpecialties
                                        ? 'Loading Specialties...'
                                        : 'Select Specialization',
                                  ),
                                  if (_selectedSpecialtyIds.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 4,
                                      children: _selectedSpecialtyIds.map((id) {
                                        final specialty = _specialties
                                            .firstWhere(
                                              (s) => s.specialityId == id,
                                              orElse: () => Specialty(
                                                specialityName: 'Unknown',
                                              ),
                                            );
                                        return Chip(
                                          label: Text(
                                            specialty.specialityName ?? '',
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          deleteIcon: const Icon(
                                            Icons.close,
                                            size: 16,
                                          ),
                                          onDeleted: () {
                                            setState(() {
                                              _selectedSpecialtyIds.remove(id);
                                            });
                                          },
                                          backgroundColor: Colors.grey
                                              .withOpacity(0.1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ],
                              );
                            })(),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isUpdating
                                    ? null
                                    : _handleProfileUpdate,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0XFF3359A7),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: _isUpdating
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        "Update Profile",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 4. Billing Address Card
                      ProfileInfoCard(
                        title: "Billing Address",
                        actions: const [
                          Icon(
                            Icons.edit_outlined,
                            size: 20,
                            color: Colors.grey,
                          ),
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
                        actions: const [
                          Icon(Icons.logout, color: Colors.redAccent),
                        ],
                        onTap: () {
                          context.read<ProfileBloc>().add(LogoutEvent());
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
      ),
    );
  }
}
