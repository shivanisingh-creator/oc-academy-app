import 'package:flutter/material.dart';

class ProfileInfoCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Widget? content;
  final List<Widget>? actions;
  final VoidCallback? onTap;
  final Widget? expandedContent;

  final bool initiallyExpanded;

  const ProfileInfoCard({
    super.key,
    required this.title,
    this.subtitle,
    this.content,
    this.actions,
    this.onTap,
    this.expandedContent,
    this.initiallyExpanded = false,
  });

  @override
  State<ProfileInfoCard> createState() => _ProfileInfoCardState();
}

class _ProfileInfoCardState extends State<ProfileInfoCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap:
            widget.onTap ??
            () {
              if (widget.expandedContent != null) {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              }
            },
        splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
        highlightColor: Theme.of(context).primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  Row(
                    children: [
                      if (widget.expandedContent != null)
                        Icon(
                          _isExpanded
                              ? Icons.keyboard_arrow_down
                              : Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      if (widget.actions != null) ...widget.actions!,
                    ],
                  ),
                ],
              ),
              if (widget.subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  widget.subtitle!,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
              if (widget.content != null) ...[
                const SizedBox(height: 12),
                widget.content!,
              ],
              if (_isExpanded && widget.expandedContent != null) ...[
                const SizedBox(height: 12),
                widget.expandedContent!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
