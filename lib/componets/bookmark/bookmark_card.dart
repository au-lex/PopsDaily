import 'package:flutter/material.dart';

class BookmarkCard extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String description;
  final String source;
  final String timeAgo;
  final bool isBookmarked;
  final VoidCallback? onTap;
  final VoidCallback? onBookmarkTap;

  const BookmarkCard({
    super.key,
    this.imageUrl,
    this.title = "Artificial Intelligence is changing software development",
    this.description = "AI continues to transform businesses worldwide by improving efficiency and decision making.",
    this.source = "BBC",
    this.timeAgo = "5 mins ago",
    this.isBookmarked = true,
    this.onTap,
    this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xff1A1A1D),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 90,
                height: 90,
                color: Colors.white10,
                child: imageUrl != null
                    ? Image.network(imageUrl!, fit: BoxFit.cover)
                    : const Icon(Icons.image_outlined, color: Colors.white24),
              ),
            ),
            const SizedBox(width: 12),

            // Fixes the overflow: text column can now shrink/wrap
            // instead of forcing the Row taller than the image.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$source · $timeAgo",
                        style: const TextStyle(color: Colors.white38, fontSize: 12),
                      ),
                      GestureDetector(
                        onTap: onBookmarkTap,
                        child: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: isBookmarked ? Colors.greenAccent : Colors.white38,
                          size: 18,
                        ),
                      ),
                    ],
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