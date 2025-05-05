import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:secure_env_gui/src/providers/env_sync_provider.dart';

/// A bell icon that toggles an overlay showing project notifications.
class ProjectNotificationButton extends ConsumerStatefulWidget {
  final String projectId;
  const ProjectNotificationButton({super.key, required this.projectId});

  @override
  ConsumerState<ProjectNotificationButton> createState() =>
      _ProjectNotificationButtonState();
}

class _ProjectNotificationButtonState
    extends ConsumerState<ProjectNotificationButton> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _toggleOverlay() {
    if (_overlayEntry == null) {
      _overlayEntry = _buildOverlay();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    setState(() {});
  }

  OverlayEntry _buildOverlay() {
    final notifications =
        ref.watch(envSyncNotificationsProvider(widget.projectId));
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // full‐screen semi‐opaque background that closes on tap
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleOverlay,
            ),
          ),
          // your existing popup, unchanged
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            targetAnchor: Alignment.bottomRight,
            followerAnchor: Alignment.topRight,
            offset: const Offset(0, 8),
            child: Material(
              elevation: 4,
              // color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  8,
                ),
              ),
              child: Container(
                width: 300,
                height: 450,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    title: const Text('Notifications'),
                    actions: [
                      CloseButton(onPressed: _toggleOverlay),
                    ],
                  ),
                  body: notifications.isEmpty
                      ? Center(
                          child: Text(
                            'No notifications',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.all(8),
                          children: [
                            for (final notification in notifications)
                              ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                titleTextStyle:
                                    Theme.of(context).textTheme.bodyMedium,
                                subtitleTextStyle:
                                    Theme.of(context).textTheme.bodySmall,
                                leading:
                                    const Icon(FontAwesomeIcons.fileExport),
                                isThreeLine: true,
                                titleAlignment: ListTileTitleAlignment.center,
                                title: Text(notification.message),
                                subtitle: notification.details != null
                                    ? Text(notification.details!)
                                    : null,
                              ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifications =
        ref.watch(envSyncNotificationsProvider(widget.projectId));

    final count = notifications.length;
    return CompositedTransformTarget(
      link: _layerLink,
      child: IconButton(
        icon: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              Icons.notifications,
            ),
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text('$count',
                    style: const TextStyle(fontSize: 10, color: Colors.white)),
              ),
            ),
          ],
        ),
        tooltip: 'Notifications',
        onPressed: _toggleOverlay,
      ),
    );
  }
}
