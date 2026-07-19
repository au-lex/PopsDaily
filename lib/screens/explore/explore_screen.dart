import 'package:flutter/material.dart';
import 'package:news_app/theme/app_color_extension.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  static const _accentTeal = Color(0xff2E9E8E);

  final List<_TopStory> _topStories = const [
    _TopStory(
      title: 'Artificial Intelligence (AI) Revolution: How AI is Shaping Our Lives in the Future',
      source: 'CBS News',
      timeAgo: '7 days ago',
      views: '749.3K',
      comments: '10.4K',
      image: 'https://picsum.photos/seed/topstory1/500/400',
    ),
    _TopStory(
      title: 'Chaos in Parliament: Debates and Decisions',
      source: 'BBC News',
      timeAgo: '6 days ago',
      views: '638.1K',
      comments: '8.2K',
      image: 'https://picsum.photos/seed/topstory2/500/400',
    ),
  ];

  final List<_Publisher> _publishers = const [
    _Publisher(name: 'Daily Sun', color: Color(0xffE63946)),
    _Publisher(name: 'Vanguard', color: Color(0xff003087)),
    _Publisher(name: 'Punch', color: Color(0xff2196F3)),
    _Publisher(name: 'ThisDay', color: Colors.black),
    _Publisher(name: 'The Guardian', color: Color(0xff1B7339)),
    _Publisher(name: 'Premium Times', color: Color(0xff6A1B9A)),
  ];

  final List<String> _trendingTags = const [
    'Politics',
    'Economy',
    'Naija Tech',
    'Sports',
    'Entertainment',
    'Elections2027',
    'Fuel Price',
    'Health',
  ];

  void _onTagTap(String tag) {
    // TODO: wire to your search screen/route, e.g.:
    // context.push('${AppRoutes.search}?q=$tag');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 12),

            // Header
            Row(
              children: [
                Text(
                  'Discover',
                  style: TextStyle(
                    color: colors.textPri,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.search, color: colors.textPri),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),

            // This Week's Top Stories
            _SectionTitle(
              title: "This Week's Top Stories",
              onViewAll: () {},
            ),
            const SizedBox(height: 14),

            SizedBox(
              height: 260,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _topStories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  return _TopStoryCard(story: _topStories[index]);
                },
              ),
            ),
            const SizedBox(height: 28),

            // Popular Official Publishers
            _SectionTitle(
              title: 'Popular Official Publishers',
              onViewAll: () {},
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 92,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _publishers.length,
                separatorBuilder: (_, __) => const SizedBox(width: 18),
                itemBuilder: (context, index) {
                  return _PublisherTile(publisher: _publishers[index]);
                },
              ),
            ),
            const SizedBox(height: 28),

            // Trending Topics — quick-search hashtags
            Text(
              'Trending Topics',
              style: TextStyle(
                color: colors.textPri,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _trendingTags.map((tag) {
                return InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => _onTagTap(tag),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: colors.textSec.withOpacity(0.35),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '#$tag',
                      style: const TextStyle(
                        color: _accentTeal,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;

  const _SectionTitle({required this.title, required this.onViewAll});

  static const _accentTeal = Color(0xff2E9E8E);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: colors.textPri,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        InkWell(
          onTap: onViewAll,
          child: const Row(
            children: [
              Text(
                'View All',
                style: TextStyle(
                  color: _accentTeal,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(Icons.chevron_right, color: _accentTeal, size: 18),
            ],
          ),
        ),
      ],
    );
  }
}

class _TopStoryCard extends StatelessWidget {
  final _TopStory story;

  const _TopStoryCard({required this.story});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      width: 220,
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                story.image,
                width: 220,
                height: 130,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              story.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colors.textPri,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              story.source,
              style: TextStyle(
                color: colors.textSec,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  story.timeAgo,
                  style: TextStyle(color: colors.textSec, fontSize: 11),
                ),
                const SizedBox(width: 10),
                Icon(Icons.visibility_outlined,
                    size: 13, color: colors.textSec),
                const SizedBox(width: 3),
                Text(
                  story.views,
                  style: TextStyle(color: colors.textSec, fontSize: 11),
                ),
                const SizedBox(width: 10),
                Icon(Icons.mode_comment_outlined,
                    size: 13, color: colors.textSec),
                const SizedBox(width: 3),
                Text(
                  story.comments,
                  style: TextStyle(color: colors.textSec, fontSize: 11),
                ),
                const Spacer(),
                Icon(Icons.share_outlined, size: 15, color: colors.textSec),
                const SizedBox(width: 10),
                Icon(Icons.more_vert, size: 15, color: colors.textSec),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PublisherTile extends StatelessWidget {
  final _Publisher publisher;

  const _PublisherTile({required this.publisher});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      width: 72,
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: publisher.color,
            child: Text(
              publisher.name.isNotEmpty ? publisher.name[0].toUpperCase() : '?',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            publisher.name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colors.textPri,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopStory {
  final String title;
  final String source;
  final String timeAgo;
  final String views;
  final String comments;
  final String image;

  const _TopStory({
    required this.title,
    required this.source,
    required this.timeAgo,
    required this.views,
    required this.comments,
    required this.image,
  });
}

class _Publisher {
  final String name;
  final Color color;

  const _Publisher({required this.name, required this.color});
}