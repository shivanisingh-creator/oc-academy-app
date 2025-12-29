import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final int? endDate;
  final int? progress;
  final String? imageUrl; // Image URL from API
  final bool isCompleted;
  final String? certificateUrl;
  final int? startDate;

  const CourseCard({
    super.key,
    required this.title,
    this.endDate,
    this.progress,
    this.imageUrl,
    this.isCompleted = false,
    this.certificateUrl,
    this.startDate,
  });

  @override
  Widget build(BuildContext context) {
    // Determine status
    final now = DateTime.now();
    final endDateTime = endDate != null
        ? DateTime.fromMillisecondsSinceEpoch(endDate!)
        : null;

    // Logic: If end date is in the past, it's expired.
    // Note: User prompt was slightly ambiguous ("if end date is greater than current date ... batch ended on"),
    // but standard logic implies "Current > End" = Ended.
    // Assuming "End Date < Current Date" -> Expired -> Contact Support.
    // However, strictly following the user's "greater than current date" = "batch ended" would mean
    // future courses are "ended". I will implement the LOGICAL interpretation:
    // Expired (End < Now) -> Batch ended.
    // Active (End > Now) -> Ends on.

    final isExpired = endDateTime != null && endDateTime.isBefore(now);

    final startDateTime = startDate != null
        ? DateTime.fromMillisecondsSinceEpoch(startDate!)
        : null;

    final dateText = endDateTime != null
        ? "${endDateTime.day}/${endDateTime.month}/${endDateTime.year}"
        : "N/A";

    final statusText = isCompleted
        ? 'Completed'
        : (isExpired
            ? 'Batch ended on $dateText'
            : 'Ends on $dateText');

    Widget button;
    if (isCompleted) {
      if (certificateUrl != null && certificateUrl!.isNotEmpty) {
        button = ElevatedButton(
          onPressed: () {
            // Download certificate logic
            print("Download certificate");
          },
          child: const Text("Download Certificate"),
        );
      } else if (startDateTime != null && endDateTime != null && endDateTime.isBefore(startDateTime)) {
        button = ElevatedButton(
          onPressed: () {
            // Watch again logic
            print("Watch again");
          },
          child: const Text("Watch Again"),
        );
      } else {
        button = ElevatedButton(
          onPressed: () {
            // Contact us logic
            print("Contact us");
          },
          child: const Text("Contact Us"),
        );
      }
    } else {
      button = ElevatedButton(
        onPressed: () {
          if (isExpired) {
            // Show Contact Support logic (Placeholder)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Contacting Support...'),
              ),
            );
          } else {
            // Start/Continue Learning logic
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0XFF3359A7),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          isExpired
              ? "Contact Support"
              : ((progress ?? 0) > 0
                  ? "Continue Learning"
                  : "Start Learning"),
        ),
      );
    }

    return Container(
      width: 240, // Fixed width for horizontal scrolling
      margin: const EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 12,
            offset: const Offset(0, 6), // Strong bottom shadow
          ),
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Area
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12.0),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12.0),
              ),
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? Image.network(
                      imageUrl!,
                      width: double.infinity,
                      height: 100,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.medical_services_outlined,
                            size: 50,
                            color: Colors.grey.shade400,
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Icon(
                        Icons.medical_services_outlined,
                        size: 50,
                        color: Colors.grey.shade400,
                      ),
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
                  statusText,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 12.0),
                SizedBox(
                  width: double.infinity,
                  child: button,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
