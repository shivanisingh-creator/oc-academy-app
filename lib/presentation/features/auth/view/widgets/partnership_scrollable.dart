import 'package:flutter/material.dart';
import 'dart:async';
import 'package:oc_academy_app/data/repositories/home_repository.dart';

// --- Reusable Widget ---

class PartnershipScroller extends StatefulWidget {
  const PartnershipScroller({super.key});

  @override
  State<PartnershipScroller> createState() => _PartnershipScrollerState();
}

class _PartnershipScrollerState extends State<PartnershipScroller> {
  final HomeRepository _homeRepository = HomeRepository();
  List<String> _partners = [];
  bool _isLoading = true;

  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  final Duration _scrollDuration = const Duration(milliseconds: 50);
  final double _scrollStep = 1.0;
  final Duration _initialDelay = const Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    _fetchPartners();
  }

  Future<void> _fetchPartners() async {
    try {
      final response = await _homeRepository.getGlobalPartners();
      if (response != null && response.response != null) {
        setState(() {
          // Duplicate the list for smooth continuous scrolling
          _partners = [...response.response!, ...response.response!];
          _isLoading = false;
        });
        // Start auto-scrolling after data is loaded
        Future.delayed(_initialDelay, () {
          if (mounted) {
            _startAutoScroll();
          }
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(_scrollDuration, (timer) {
      if (!_scrollController.hasClients) return;

      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentOffset = _scrollController.offset;

      // The scrollable width is the original list's width (maxScroll / 2)
      double originalListEnd = maxScroll / 2;

      if (currentOffset >= maxScroll) {
        // If we hit the absolute end, jump back to the start of the duplicated list section
        _scrollController.jumpTo(originalListEnd);
      } else {
        // Scroll forward
        _scrollController.animateTo(
          currentOffset + _scrollStep,
          duration: _scrollDuration,
          curve: Curves.linear,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Partnership Scroller Container
        SizedBox(
          height: 120, // Increased from 80
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _partners.isEmpty
              ? const Center(
                  child: Text(
                    'No partners available',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: _partners.length,
                  itemBuilder: (context, index) {
                    return PartnerLogo(imageUrl: _partners[index]);
                  },
                ),
        ),
      ],
    );
  }
}

// --- Partner Logo Item Widget ---

class PartnerLogo extends StatelessWidget {
  final String imageUrl;

  const PartnerLogo({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180, // Increased from 140
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.business, size: 40, color: Colors.grey.shade400);
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
                strokeWidth: 2,
              ),
            );
          },
        ),
      ),
    );
  }
}
