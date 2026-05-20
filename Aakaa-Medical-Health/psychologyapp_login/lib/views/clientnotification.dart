import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/zen_background.dart';
import '../controllers/notification_controller.dart';

class ClientNotification extends StatefulWidget {
  const ClientNotification({super.key});

  @override
  State<ClientNotification> createState() => _ClientNotificationState();
}

class _ClientNotificationState extends State<ClientNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F5),
      body: ZenBackground(
        child: ValueListenableBuilder<List<NotificationModel>>(
          valueListenable: NotificationController.notificationsNotifier,
          builder: (context, notifications, child) {
            final unreadCount = notifications.where((n) => !n.isRead).length;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 120.0,
                  floating: false,
                  pinned: true,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF065643)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  actions: [
                    if (notifications.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: TextButton.icon(
                          onPressed: () {
                            if (unreadCount > 0) {
                              NotificationController.markAllAsRead();
                            } else {
                              NotificationController.clearAll();
                            }
                          },
                          icon: Icon(
                            unreadCount > 0 ? Icons.done_all_rounded : Icons.clear_all_rounded,
                            color: const Color(0xFF0A7D62),
                            size: 18,
                          ),
                          label: Text(
                            unreadCount > 0 ? "Mark all read" : "Clear all",
                            style: GoogleFonts.outfit(
                              color: const Color(0xFF0A7D62),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: const Color(0xFF0A7D62).withValues(alpha: 0.2)),
                            ),
                          ),
                        ),
                      ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    centerTitle: false,
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Notifications",
                          style: GoogleFonts.outfit(
                            color: const Color(0xFF065643),
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        if (unreadCount > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0A7D62),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "$unreadCount",
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                if (notifications.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 120),
                          Container(
                            padding: const EdgeInsets.all(40),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF065643).withValues(alpha: 0.06),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                              border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.05)),
                            ),
                            child: Icon(
                              Icons.notifications_none_rounded,
                              size: 80,
                              color: const Color(0xFF065643).withValues(alpha: 0.5),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            "All Quiet for Now",
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF065643),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "You're all caught up! We'll notify you when your session is confirmed or milestones are reached.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              color: const Color(0xFF065643).withValues(alpha: 0.7),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return _buildNotificationCard(notifications[index]);
                        },
                        childCount: notifications.length,
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 60)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel item) {
    IconData iconData;
    Color iconColor;

    switch (item.iconType) {
      case 'session':
        iconData = Icons.event_available_rounded;
        iconColor = const Color(0xFF0A7D62);
        break;
      case 'mood':
        iconData = Icons.favorite_rounded;
        iconColor = const Color(0xFF00C853);
        break;
      case 'journal':
        iconData = Icons.edit_note_rounded;
        iconColor = const Color(0xFF065643);
        break;
      case 'premium':
        iconData = Icons.workspace_premium_rounded;
        iconColor = Colors.amber;
        break;
      default:
        iconData = Icons.notifications_rounded;
        iconColor = const Color(0xFF065643);
    }

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => NotificationController.removeNotification(item.id),
      background: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFF4B4B),
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 28),
      ),
      child: GestureDetector(
        onTap: () => NotificationController.markAsRead(item.id),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: item.isRead 
                  ? const Color(0xFF065643).withValues(alpha: 0.05)
                  : const Color(0xFF0A7D62).withValues(alpha: 0.3),
              width: item.isRead ? 1 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: item.isRead ? 0.02 : 0.04),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: GoogleFonts.outfit(
                              color: const Color(0xFF065643),
                              fontWeight: item.isRead ? FontWeight.w600 : FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          item.timestamp,
                          style: GoogleFonts.outfit(
                            color: Colors.grey[400],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (!item.isRead) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF0A7D62),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.body,
                      style: GoogleFonts.outfit(
                        color: Colors.grey[600],
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
