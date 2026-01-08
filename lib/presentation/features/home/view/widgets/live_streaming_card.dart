import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oc_academy_app/core/utils/helpers/url_helper.dart';
import 'package:oc_academy_app/data/models/home/live_event_response.dart';

class LiveStreamingCard extends StatelessWidget {
  final LiveEvent event;

  const LiveStreamingCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final String endTimeStr = event.endTime != null
        ? DateFormat(
            'dth MMM yyyy, h:mm a',
          ).format(DateTime.fromMillisecondsSinceEpoch(event.endTime!))
        : '';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFDADA), // Light red/pinkish background
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: const Color(0xFFFFB4AB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Streaming Now',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            event.name ?? '',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          if (event.description != null && event.description!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              // Simple way to strip HTML tags if description contains them
              event.description!.replaceAll(RegExp(r'<[^>]*>'), ''),
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (endTimeStr.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Ends on $endTimeStr',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (event.joinLink != null) {
                  UrlHelper.launchUrlString(event.joinLink!);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.podcasts, color: Colors.red, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Join Live Event',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
