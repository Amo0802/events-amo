import 'package:events_amo/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(EventsApp());
}

class EventsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeoEvents',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF6200EA),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
        ),
        colorScheme: ColorScheme.dark(
          primary: Color(0xFF6200EA),
          secondary: Color(0xFF00E5FF),
          tertiary: Color(0xFFFF00E5),
          background: Color(0xFF0A0E21),
          onBackground: Colors.white,
        ),
      ),
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}