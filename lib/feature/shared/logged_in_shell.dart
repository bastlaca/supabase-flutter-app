import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:workspace/core/auth/auth_state.dart';

class LoggedInShell extends ConsumerWidget {
  final Widget child;
  const LoggedInShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use GoRouter's current location in a more robust way
    final String location = GoRouterState.of(context).matchedLocation;

    // Determine current index based on exact path matching
    int currentIndex = switch (location) {
      '/loggedin/page1' => 0,
      '/loggedin/page2' => 1,
      _ => 0, // Default to first tab
    };
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Inner pages!'),
          actions: [
            IconButton(
              onPressed: () => ref.read(authProvider.notifier).logout(),
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Center(
          child: child,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Page1'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Page2'),
          ],
          onTap: (index) {
            if (index == 0) {
              context.go('/loggedin/page1');
            } else if (index == 1) {
              context.go('/loggedin/page2');
            }
          },
        ),
      ),
    );
  }
}
