import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String batchDate;
  final Color imageBackgroundColor; // To simulate the placeholder image

  const CourseCard({
    super.key,
    required this.title,
    required this.batchDate,
    required this.imageBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240, // Fixed width for horizontal scrolling
      margin: const EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Placeholder Area
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: imageBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12.0),
              ),
              // You would use an Image.network or Image.asset here
            ),
            child: Center(
              child: Icon(
                Icons.medical_services_outlined,
                size: 50,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Batch ends on $batchDate',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 12.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement course details navigation
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFF3359A7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Start Learning'),
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
