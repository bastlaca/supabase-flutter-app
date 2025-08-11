import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:workspace/core/auth/auth_state.dart';

class LoggedInShell extends ConsumerWidget {
  final Widget child;
  const LoggedInShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
