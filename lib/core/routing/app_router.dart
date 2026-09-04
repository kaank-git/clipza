import 'package:go_router/go_router.dart';
import '../../main.dart'; // DummyHomeScreen için geçici import

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DummyHomeScreen(),
    ),
  ],
);