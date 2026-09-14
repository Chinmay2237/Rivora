import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'app_router.dart';
import '../core/responsive/landscape_guard.dart';

class RivoraApp extends StatelessWidget {
  const RivoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rivora',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
      builder: (context, child) {
        return LandscapeGuard(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
