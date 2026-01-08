import 'package:flutter/material.dart';
import 'package:oc_academy_app/core/utils/helpers/api_utils.dart';
import 'package:oc_academy_app/core/utils/helpers/url_helper.dart';

class LogbookCard extends StatelessWidget {
  const LogbookCard({super.key});

  @override
  Widget build(BuildContext context) {
    final String logbookUrl = ApiUtils.instance.config.logbookUrl;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Logbook',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            'Track your clinical cases and procedures.',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                UrlHelper.launchUrlString(logbookUrl);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0XFF3359A7), // A nice blue
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Open Logbook',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
