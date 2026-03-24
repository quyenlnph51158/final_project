import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../data/models/news_model.dart';

class NewsCard extends StatelessWidget  {
  final News news;
  final bool isExpanded;
  final VoidCallback onTap;

  const NewsCard({
    super.key,
    required this.news,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      news.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(Icons.keyboard_arrow_down),
                  ),
                ],
              ),
            ),
          ),

          /// CONTENT – MỞ RỘNG (Using AnimatedCrossFade)
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 400),
            sizeCurve: Curves.easeOutCubic,
            // 1. CLOSED STATE: An empty box with no height
            firstChild: const SizedBox(width: double.infinity, height: 0),

            // 2. OPEN STATE: The actual content
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: HtmlWidget(
                news.content,
                textStyle: const TextStyle(
                  fontSize: 14.5,
                  color: Colors.black87,
                ),
              ),
            ),

            // 3. SWITCH LOGIC: Determine which child to show
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          ),
        ],
      ),
    );
  }
}
