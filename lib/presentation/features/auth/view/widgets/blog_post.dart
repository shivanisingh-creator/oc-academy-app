import 'package:flutter/material.dart';
import 'package:oc_academy_app/data/models/blog/blog_post_response.dart';
import 'package:url_launcher/url_launcher.dart';

class BlogPostsSection extends StatelessWidget {
  final List<BlogPostResponse> blogs;

  const BlogPostsSection({required this.blogs, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340, // Increased height to accommodate the "Read Here" button
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: blogs.length,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16.0), // Space between cards
            child: SizedBox(
              width: 200, // Fixed width for each card
              child: BlogCard(blog: blogs[index]),
            ),
          );
        },
      ),
    );
  }
}

// Blog Card Widget
class BlogCard extends StatelessWidget {
  final BlogPostResponse blog;

  const BlogCard({required this.blog, super.key});

  String _extractImageUrl() {
    if (blog.featuredMediaUrl != null) {
      return blog.featuredMediaUrl!;
    }

    final yoast = blog.yoastHeadJson;
    if (yoast == null) return 'assets/images/mrcp.png';

    try {
      // 1. Check Twitter Image (very reliable in Yoast)
      if (yoast['twitter_image'] != null) {
        return yoast['twitter_image'].toString();
      }

      // 2. Check Open Graph Image (List of Maps)
      if (yoast['og_image'] != null && yoast['og_image'] is List) {
        final List ogList = yoast['og_image'];
        if (ogList.isNotEmpty && ogList[0]['url'] != null) {
          return ogList[0]['url'].toString();
        }
      }

      // 3. Check Schema Graph (Common in modern WordPress)
      if (yoast['schema'] != null && yoast['schema']['@graph'] != null) {
        final List graph = yoast['schema']['@graph'];
        // Look for ImageObject or Article types that have an url
        for (var item in graph) {
          if (item['@type'] == 'ImageObject' && item['url'] != null) {
            return item['url'].toString();
          }
        }
      }
    } catch (e) {
      debugPrint("Error extracting image: $e");
    }

    // 4. Regex Fallback
    final RegExp imgRegex = RegExp(r'<img[^>]+src="([^">]+)"');
    final match = imgRegex.firstMatch(blog.content.rendered);
    if (match != null) {
      return match.group(1) ?? 'assets/images/mrcp.png';
    }

    return 'assets/images/mrcp.png';
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = _extractImageUrl();
    String readTime = blog.estimatedReadingTime ?? 'N/A';
    String category = blog.class_list
        .firstWhere(
          (element) => element.startsWith('category-'),
          orElse: () => 'category-Uncategorized',
        )
        .replaceFirst('category-', '');

    return GestureDetector(
      onTap: () => _launchUrl(blog.link),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12.0),
              ),
              child: imageUrl.startsWith('http')
                  ? Image.network(
                      imageUrl,
                      height: 120, // Height for the image
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 120,
                        color: Colors.blueGrey.shade100,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.article,
                          size: 40,
                          color: Colors.black54,
                        ),
                      ),
                    )
                  : Image.asset(
                      imageUrl,
                      height: 120, // Height for the image
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 120,
                        color: Colors.blueGrey.shade100,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.article,
                          size: 40,
                          color: Colors.black54,
                        ),
                      ),
                    ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category
                    Text(
                      category.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Title
                    Text(
                      blog.title.rendered,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Read Time
                    Text(
                      readTime,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(), // Pushes the button to the bottom
                    // Read Here Button
                    SizedBox(
                      width: double.infinity,
                      height: 36,
                      child: ElevatedButton(
                        onPressed: () => _launchUrl(blog.link),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0XFF3359A7),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          'Read Here',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
