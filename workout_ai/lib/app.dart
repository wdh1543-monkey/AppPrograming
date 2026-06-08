import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'application/chat_provider.dart';
import 'application/workout_provider.dart';
import 'presentation/screens/home_screen.dart';

class WorkoutAiApp extends StatelessWidget {
  const WorkoutAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WorkoutProvider()..init()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        title: 'Workout AI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1565C0),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
