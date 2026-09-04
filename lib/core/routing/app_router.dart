import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'main_layout.dart';
import '../../features/downloader/screens/downloader_screen.dart';
import '../../features/gallery/screens/gallery_screen.dart';
import '../../features/gallery/screens/video_player_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/downloader',
  routes: [
    // TAM EKRAN VİDEO OYNATICI ROTASI
    // Alt menünün (Bottom Nav Bar) üzerine açılması için root navigatörü kullanıyoruz
    GoRoute(
      path: '/video_player',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final videoFile = state.extra as File;
        return VideoPlayerScreen(videoFile: videoFile);
      },
    ),

    // ALT MENÜ (SEKMELİ YAPI) ROTALARI
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
              builder: (context, state) => const GalleryScreen(),
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