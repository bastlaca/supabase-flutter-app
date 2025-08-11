import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:workspace/core/auth/auth_state.dart';
import 'package:workspace/feature/login/login_screen.dart';
import 'package:workspace/feature/shared/logged_in_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final router = _RouterNotifier(ref);
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: router,
    redirect: router._redirect,
    routes: router._routes,
  );
});

class _RouterNotifier extends ChangeNotifier {
  final Ref ref;

  _RouterNotifier(this.ref);

  String? _redirect(BuildContext context, GoRouterState state) {
    debugPrint('Current location: ${state.matchedLocation}');
    final authState = ref.watch(authProvider);
    final isAuth = authState is AuthStateAuthenticated;

    final isLoggingIn = state.matchedLocation == '/login';

    if (!isAuth && !isLoggingIn) return '/login';
    if (isAuth && isLoggingIn) return '/loggedin';
    if (isAuth && state.matchedLocation == '/') return '/loggedin/page1';
    return null;
  }

  List<RouteBase> get _routes => [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/loggedin', redirect: (_, __) => '/loggedin/page1'),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => LoggedInShell(child: child),
      routes: [
        GoRoute(
          path: '/loggedin/page1',
          builder: (context, state) => const Center(child: Text('Page1'),),
        ),
        GoRoute(
          path: '/loggedin/page2',
          builder: (context, state) => const Center(child: Text('Page2'),),
        ),
      ],
    ),
  ];
}
