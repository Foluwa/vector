import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/notification_service.dart';
import 'features/payments/services/session_service.dart';

void main() {
  runApp(const ProviderScope(child: VectorApp()));
}

class VectorApp extends ConsumerStatefulWidget {
  const VectorApp({super.key});

  @override
  ConsumerState<VectorApp> createState() => _VectorAppState();
}

class _VectorAppState extends ConsumerState<VectorApp> {
  @override
  void initState() {
    super.initState();
    // Restore active session on app start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(activeSessionProvider.notifier).restoreSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Vector - Money in Motion',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: NotificationService.messengerKey,
    );
  }
}
