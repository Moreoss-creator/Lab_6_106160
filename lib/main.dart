import 'package:flutter/material.dart';
import 'signup.dart';
import 'login.dart';
import 'dashboard.dart';
import 'room_list.dart';

void main() {
  runApp(const HotelReservationApp());
}

class HotelReservationApp extends StatelessWidget {
  const HotelReservationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Borneo Haven Hotel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00695C), // Deep Emerald Teal
          secondary: const Color(0xFFFF8F00), // Warm Amber Accent
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F7F6),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF00695C),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      initialRoute: '/signup',
      routes: {
        '/signup': (context) => const SignupPage(),
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/rooms': (context) => const RoomListPage(),
      },
    );
  }
}