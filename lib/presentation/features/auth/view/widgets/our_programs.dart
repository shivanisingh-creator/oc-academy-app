import 'package:flutter/material.dart';
import 'package:oc_academy_app/core/utils/helpers/api_utils.dart';
import 'package:oc_academy_app/core/utils/helpers/url_helper.dart';
import 'package:oc_academy_app/core/constants/legal_urls.dart';
import 'package:oc_academy_app/data/models/home/course_offering_response.dart';
import 'package:oc_academy_app/data/repositories/home_repository.dart';

class ProgramCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final List<String> tags;
  final String description;

  const ProgramCard({
    required this.imageUrl,
    required this.title,
    required this.tags,
    required this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // The distinct blue color used for the 'Learn More' link
    const Color accentBlue = (Color(0XFF3359A7));

    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ), // Light grey border
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          final env = ApiUtils.instance.config.environment;
          final url = LegalUrls.getCategoryUrl(env, title);
          UrlHelper.launchUrlString(url);
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12.0),
              ),
              child: Image.network(
                imageUrl,
                height: 140, // Fixed height for the image
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  debugPrint('Image load error for $imageUrl: $error');
                  return Container(
                    height: 140,
                    color: Colors.blueGrey.shade100,
                    alignment: Alignment.center,
                    child: const Text(
                      'Placeholder Image',
                      style: TextStyle(color: Colors.black54),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  SizedBox(
                    height: 40.0,
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tags Row
                  if (tags.isNotEmpty)
                    Text(
                      tags.join(" • "),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  const SizedBox(height: 12),

                  // Description
                  SizedBox(
                    height: 40.0,
                    child: Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Learn More Link
                  InkWell(
                    onTap: () {
                      final env = ApiUtils.instance.config.environment;
                      final url = LegalUrls.getCategoryUrl(env, title);
                      UrlHelper.launchUrlString(url);
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Learn More',
                          style: TextStyle(
                            color: accentBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: accentBlue,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Container for the horizontally scrolling list of programs
class ExploreProgramsSection extends StatefulWidget {
  const ExploreProgramsSection({super.key});

  @override
  State<ExploreProgramsSection> createState() => _ExploreProgramsSectionState();
}

class _ExploreProgramsSectionState extends State<ExploreProgramsSection> {
  final HomeRepository _homeRepository = HomeRepository();
  List<CourseOffering> _programs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPrograms();
  }

  Future<void> _fetchPrograms() async {
    try {
      final response = await _homeRepository.getCourseOfferings();
      if (mounted) {
        setState(() {
          _programs = response?.response ?? [];
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
        height: 350,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_programs.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 340, // Sufficient height for the cards to display fully
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: _programs.length,
        itemBuilder: (context, index) {
          final program = _programs[index];
          return ProgramCard(
            imageUrl: (program.media ?? '').replaceAll(' ', '%20'),
            title: program.title ?? '',
            tags: program.tags ?? [],
            description: program.description ?? '',
          );
        },
      ),
    );
  }
}
