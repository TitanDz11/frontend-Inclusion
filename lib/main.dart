import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'services/accessibility_provider.dart';
import 'services/database_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AccessibilityProvider()),
      ],
      child: const InclusionApp(),
    ),
  );
}

class InclusionApp extends StatelessWidget {
  const InclusionApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Only rebuild MaterialApp if theme changes significantly (dark mode).
    // For font scale and contrast, we handle it inside builder to avoid jank.
    return Selector<AccessibilityProvider, bool>(
      selector: (_, a11y) => a11y.darkMode,
      builder: (context, isDarkMode, _) {
        ThemeData theme = AppTheme.lightTheme;
        if (isDarkMode) {
           // Future expansion for dark mode theme
        }

        return MaterialApp(
          title: 'Inclusion Atlantida',
          debugShowCheckedModeBanner: false,
          theme: theme,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('es', 'ES'),
          ],
          builder: (context, child) {
            final fontScale = context.select<AccessibilityProvider, double>((a) => a.fontScale);
            final contrast = context.select<AccessibilityProvider, double>((a) => a.contrast);
            
            final mediaQuery = MediaQuery.of(context);
            
            Widget tree = MediaQuery(
              data: mediaQuery.copyWith(
                textScaler: TextScaler.linear(fontScale),
              ),
              child: child!,
            );

            if (contrast != 1.0) {
              final c = contrast;
              final t = (1.0 - c) / 2.0 * 255.0;
              tree = ColorFiltered(
                colorFilter: ColorFilter.matrix([
                   c, 0, 0, 0, t,
                   0, c, 0, 0, t,
                   0, 0, c, 0, t,
                   0, 0, 0, 1, 0,
                ]),
                child: tree,
              );
            }

            return tree;
          },
          home: const HomeScreen(),
        );
      },
    );
  }
}
