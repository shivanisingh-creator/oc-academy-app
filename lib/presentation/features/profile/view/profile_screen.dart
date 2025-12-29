import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_academy_app/core/constants/route_constants.dart';
import 'package:oc_academy_app/data/repositories/home_repository.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/profile_info_card_widget.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/referal_card.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/custom_phone_field.dart';
import 'package:oc_academy_app/data/repositories/user_repository.dart';
import 'package:oc_academy_app/data/models/user/billing_address_response.dart';
import 'package:oc_academy_app/presentation/features/profile/bloc/profile_bloc.dart';
import 'package:oc_academy_app/data/models/home/specialty_response.dart';
import 'package:oc_academy_app/core/utils/helpers/dialog_helper.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

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
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  File? _selectedImage;
  BillingAddress? _billingAddress;
  bool _isLoadingBilling = true;

  DateTime? _lastUpdateTime;

  @override
  void initState() {
    super.initState();
    _fetchSpecialties();
    _fetchBillingAddress();

    // Initialize local state from current Bloc state if available
    final state = context.read<ProfileBloc>().state;
    if (state is ProfileLoaded) {
      final user = state.user.response;
      if (user != null) {
        _firstNameController.text = user.firstName ?? '';
        _lastNameController.text = user.lastName ?? '';
        _selectedQualification = user.qualification;

        if (user.specialitiesOfInterestIds != null) {
          final rawIds = user.specialitiesOfInterestIds!;
          final List<int> parsedIds = [];

          for (var item in rawIds) {
            if (item is int) {
              parsedIds.add(item);
            } else if (item is String) {
              // Handle potential list format "[1, 2]" string or single "1"
              if (item.startsWith('[') && item.endsWith(']')) {
                final clean = item.replaceAll('[', '').replaceAll(']', '');
                if (clean.isNotEmpty) {
                  final split = clean.split(',');
                  for (var s in split) {
                    final p = int.tryParse(s.trim());
                    if (p != null) parsedIds.add(p);
                  }
                }
              } else {
                final p = int.tryParse(item);
                if (p != null) parsedIds.add(p);
              }
            }
          }

          _selectedSpecialtyIds = parsedIds;
        }
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
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

  Future<void> _fetchBillingAddress() async {
    try {
      final response = await UserRepository().getBillingAddress();
      if (mounted) {
        setState(() {
          _billingAddress = response?.response;
          _isLoadingBilling = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching billing address: $e");
      if (mounted) {
        setState(() {
          _isLoadingBilling = false;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        await _handleProfileUpdate();
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  Future<void> _handleProfileUpdate() async {
    setState(() {
      _isUpdating = true;
    });

    try {
      final userResponse = await UserRepository().updateProfileAndFetch(
        fullName: "${_firstNameController.text} ${_lastNameController.text}",
        qualification: _selectedQualification,
        specialitiesOfInterestIds: _selectedSpecialtyIds,
        profilePicPath: _selectedImage?.path,
      );

      if (mounted) {
        if (userResponse != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );
          setState(() {
            _isEditingName = false;
            _lastUpdateTime = DateTime.now(); // Mark the update time
          });
          // Update data via Bloc strictly with the fetched response
          context.read<ProfileBloc>().add(UpdateProfileLocal(userResponse));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update profile.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  Future<void> _handleReferralShare() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fetching referral data...')),
      );

      final homeRepo = HomeRepository();
      final userRepo = UserRepository();

      final code = await homeRepo.getReferralCode();
      final userLite = await userRepo.getUserLite();
      final userId = userLite?.response?.userId;

      if (code != null && userId != null) {
        final String referralLink =
            "https://www.ocacademy.in/filters?referralCode=$code&utm_source=referralPage&refererId=$userId";
        final String message =
            "Hi, I think OC Academy's specialized courses could enhance your medical career. Explore 100+ courses and get a 5% discount (up to ₹45,000). Let me know if you have questions! $referralLink";

        // Share via system share sheet (WhatsApp, Gmail, etc.)
        await Share.share(message);
      } else {
        if (mounted) {
          String errorMsg = 'Could not fetch referral data.';
          if (code == null && userId != null) {
            errorMsg = 'Could not fetch referral code.';
          } else if (code != null && userId == null) {
            errorMsg = 'Could not fetch user ID.';
          }

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(errorMsg)));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB), // Light grey background
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FB),
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
            // Only synchronize if we haven't recently updated locally
            // This prevents stale server data from overwriting local state "then and there"
            final hasRecentlyUpdated =
                _lastUpdateTime != null &&
                DateTime.now().difference(_lastUpdateTime!).inSeconds < 2;

            final user = state.user.response;

            // ALWAYS update Medical Details from API (Qualification & Specialities)
            // This ensures logic: Change -> API -> Fetch -> UI Update is respected.
            if (user?.qualification != null) {
              setState(() {
                _selectedQualification = user!.qualification;
              });
            }
            if (user?.specialitiesOfInterestIds != null) {
              final rawIds = user!.specialitiesOfInterestIds!;
              final List<int> parsedIds = [];

              for (var item in rawIds) {
                if (item is int) {
                  parsedIds.add(item);
                } else if (item is String) {
                  if (item.startsWith('[') && item.endsWith(']')) {
                    final clean = item.replaceAll('[', '').replaceAll(']', '');
                    if (clean.isNotEmpty) {
                      final split = clean.split(',');
                      for (var s in split) {
                        final p = int.tryParse(s.trim());
                        if (p != null) parsedIds.add(p);
                      }
                    }
                  } else {
                    final p = int.tryParse(item);
                    if (p != null) parsedIds.add(p);
                  }
                }
              }

              setState(() {
                _selectedSpecialtyIds = parsedIds;
              });
            }

            // Only protect Name fields from debounce
            if (!hasRecentlyUpdated) {
              if (user?.firstName != null) {
                _firstNameController.text = user!.firstName!;
              }
              if (user?.lastName != null) {
                _lastNameController.text = user!.lastName!;
              }
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
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: _selectedImage != null
                                ? FileImage(_selectedImage!)
                                : user?.profilePic != null
                                ? NetworkImage(
                                        "${user!.profilePic!}?v=${DateTime.now().millisecondsSinceEpoch}",
                                      )
                                      as ImageProvider
                                : null,
                            backgroundColor: const Color(0xFF3F51B5),
                            child:
                                _selectedImage == null &&
                                    user?.profilePic == null
                                ? Text(
                                    "${_firstNameController.text.isNotEmpty ? _firstNameController.text[0] : (user?.firstName?[0] ?? '')}${_lastNameController.text.isNotEmpty ? _lastNameController.text[0] : (user?.lastName?[0] ?? '')}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        if (_isEditingName)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 18,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 18,
                                  color: Colors.blue,
                                ),
                                onPressed: _pickImage,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      (_firstNameController.text.isNotEmpty ||
                              _lastNameController.text.isNotEmpty)
                          ? "Dr. ${_firstNameController.text} ${_lastNameController.text}"
                          : "Dr. ${user?.firstName ?? ''} ${user?.lastName ?? ''}"
                                .trim()
                                .isNotEmpty
                          ? "Dr. ${user?.firstName ?? ''} ${user?.lastName ?? ''}"
                          : "Dr. ABC",
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
                            if (_isEditingName) {
                              // Trigger update when saving name
                              _handleProfileUpdate();
                            }
                            setState(() {
                              _isEditingName = !_isEditingName;
                            });
                          },
                          icon: Icon(
                            _isEditingName ? Icons.check : Icons.edit_outlined,
                            size: 20,
                            color: _isEditingName ? Colors.green : Colors.grey,
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
                            Column(
                              children: [
                                TextFormField(
                                  controller: _firstNameController,
                                  decoration: const InputDecoration(
                                    labelText: 'First Name',
                                    isDense: true,
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (val) {
                                    setState(() {}); // Refresh header name
                                  },
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: _lastNameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Last Name',
                                    isDense: true,
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (val) {
                                    setState(() {}); // Refresh header name
                                  },
                                  onFieldSubmitted: (_) =>
                                      _handleProfileUpdate(),
                                ),
                              ],
                            )
                          else
                            Text(
                              (_firstNameController.text.isNotEmpty ||
                                      _lastNameController.text.isNotEmpty)
                                  ? "Dr. ${_firstNameController.text} ${_lastNameController.text}"
                                  : "Dr. ${user?.firstName ?? ''} ${user?.lastName ?? ''}"
                                        .trim()
                                        .isNotEmpty
                                  ? "Dr. ${user?.firstName ?? ''} ${user?.lastName ?? ''}"
                                  : "Dr. ABC",
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
                      initiallyExpanded: true,
                      expandedContent: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomDropdownField(
                            label: '',
                            value: _selectedQualification,
                            // Ensure the current selection is always part of the items list
                            items: [
                              ...{
                                'MBBS/FMG',
                                'MD/MSM/DNB',
                                if (_selectedQualification != null)
                                  _selectedQualification!,
                              }.toList(),
                            ],
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
                                        (name) =>
                                            !_selectedSpecialtyIds.any((id) {
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
                                      final selected = _specialties.firstWhere(
                                        (s) => s.specialityName == val,
                                      );
                                      // Create a new list reference to ensure setState detects change
                                      final newList = List<int>.from(
                                        _selectedSpecialtyIds,
                                      );
                                      if (!newList.contains(
                                        selected.specialityId!,
                                      )) {
                                        newList.add(selected.specialityId!);
                                        setState(() {
                                          _selectedSpecialtyIds = newList;
                                        });
                                      }
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
                                      final specialty = _specialties.firstWhere(
                                        (s) => s.specialityId == id,
                                        orElse: () => Specialty(
                                          specialityName: 'Unknown',
                                        ),
                                      );
                                      return Chip(
                                        label: Text(
                                          specialty.specialityName ?? '',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        deleteIcon: const Icon(
                                          Icons.close,
                                          size: 16,
                                        ),
                                        onDeleted: () {
                                          final newList = List<int>.from(
                                            _selectedSpecialtyIds,
                                          );
                                          newList.remove(id);
                                          setState(() {
                                            _selectedSpecialtyIds = newList;
                                          });
                                          _handleProfileUpdate();
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
                        Icon(Icons.edit_outlined, size: 20, color: Colors.grey),
                      ],
                      content: _isLoadingBilling
                          ? const Center(child: CircularProgressIndicator())
                          : Text(
                              (user?.location != null &&
                                      user!.location!.isNotEmpty)
                                  ? user.location!
                                  : (_billingAddress?.fullAddress ??
                                        "Home\n123, MG Road, Indiranagar,\nBangalore, Karnataka - 560038\nIndia"),
                              style: const TextStyle(height: 1.5),
                            ),
                    ),

                    // 5. Refer a Friend Card
                    ReferralCard(onTap: _handleReferralShare),

                    // 6. Logout Card
                    ProfileInfoCard(
                      title: "Logout",
                      actions: const [
                        Icon(Icons.logout, color: Color(0XFF3359A7)),
                      ],
                      onTap: () {
                        DialogHelper.showConfirmationDialog(
                          context: context,
                          title: 'Exit',
                          content: 'Are you sure you want to exit?',
                          confirmText: 'Yes',
                          cancelText: 'No',
                          onConfirm: () {
                            context.read<ProfileBloc>().add(LogoutEvent());
                          },
                        );
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
