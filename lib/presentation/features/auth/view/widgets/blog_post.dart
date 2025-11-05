import 'package:flutter/material.dart';

class BlogPostsSection extends StatelessWidget {
  final List<BlogData> blogs;

  const BlogPostsSection({required this.blogs, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // Approximate height for the horizontally scrolling cards
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
  final BlogData blog;

  const BlogCard({required this.blog, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
            child: Image.asset(
              blog.imageUrl,
              height: 120, // Height for the image
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 120,
                color: Colors.blueGrey.shade100,
                alignment: Alignment.center,
                child: const Icon(Icons.article, size: 40, color: Colors.black54),
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category
                Text(
                  blog.category,
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
                  blog.title,
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
                  blog.readTime,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class BlogData {
  final String category;
  final String title;
  final String readTime;
  final String imageUrl;

  BlogData({
    required this.category,
    required this.title,
    required this.readTime,
    required this.imageUrl,
  });
}