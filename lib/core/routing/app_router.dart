import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'main_layout.dart';
import '../../features/downloader/screens/downloader_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/downloader',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainLayout(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/downloader',
              builder: (context, state) => const DownloaderScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/sticker',
              builder: (context, state) => const PremiumPlaceholderScreen(
                title: 'Sticker Maker',
                icon: Icons.auto_awesome_rounded,
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/gallery',
              builder: (context, state) => const PremiumPlaceholderScreen(
                title: 'Galeri',
                icon: Icons.photo_library_rounded,
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const PremiumPlaceholderScreen(
                title: 'Ayarlar',
                icon: Icons.settings_rounded,
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);