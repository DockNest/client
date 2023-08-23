import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:docknest/screens/docknests_screen.dart';

final kColorScheme = ColorScheme.fromSeed(seedColor: Colors.blueAccent);

void main() {
  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'docknest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: kColorScheme,
        useMaterial3: true,
        appBarTheme: AppBarTheme().copyWith(
            backgroundColor: kColorScheme.onPrimaryContainer,
            foregroundColor: kColorScheme.primaryContainer,
            titleTextStyle: TextStyle(fontSize: 22),
            iconTheme:
                IconThemeData(size: 32, color: kColorScheme.primaryContainer)),
        scaffoldBackgroundColor: Theme.of(context).colorScheme.background,
        textTheme: const TextTheme().copyWith(
          titleLarge: TextStyle(
            // AppBar title -> titleLarge
            fontWeight: FontWeight.normal,
            color: kColorScheme.onSecondaryContainer,
            fontSize: 14,
          ),
        ),
      ),
      home: const docknestsScreen(),
    );
  }
}
