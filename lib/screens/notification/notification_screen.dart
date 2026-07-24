import 'package:flutter/material.dart';
import 'package:news_app/model/app_notification.dart';
import 'package:news_app/theme/app_color_extension.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});


  static final List<AppNotification> _notifications = [
    AppNotification(
      id: 'welcome',
      title: 'Welcome to Pops Daily! 👋',
      body:
          "Thanks for choosing us — you're all set. Explore your feed, bookmark stories you love, and check back for what's new.",
      createdAt: DateTime.now(),
    ),
    AppNotification(
      id: 'tip_bookmarks',
      title: 'Tip: Save stories for later',
      body: 'Tap the bookmark icon on any article to find it again in your Bookmarks tab.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
    ),
    AppNotification(
      id: 'tip_categories',
      title: 'Explore by category',
      body: 'Head to Explore to filter news by politics, sports, tech, and more.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
  ];

  String _formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.bg,
        elevation: 0,
        title: Text('Notifications', style: TextStyle(color: colors.textPri)),
        iconTheme: IconThemeData(color: colors.textPri),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _notifications.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          color: colors.textSec.withOpacity(0.1),
        ),
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return _NotificationTile(
            notification: notification,
            colors: colors,
            timeAgo: _formatTimeAgo(notification.createdAt),
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.notification,
    required this.colors,
    required this.timeAgo,
  });

  final AppNotification notification;
  final AppColorsExtension colors;
  final String timeAgo;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: notification.isRead ? Colors.transparent : colors.pri.withOpacity(0.05),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!notification.isRead)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 6, right: 12),
              decoration: BoxDecoration(color: colors.pri, shape: BoxShape.circle),
            )
          else
            const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(
                    color: colors.textPri,
                    fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.body,
                  style: TextStyle(color: colors.textSec, fontSize: 13.5, height: 1.4),
                ),
                const SizedBox(height: 6),
         
              ],
            ),
          ),
        ],
      ),
    );
  }
}