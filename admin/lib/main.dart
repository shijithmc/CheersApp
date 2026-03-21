import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/admin_api_service.dart';
import 'screens/admin_login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CheersAdminApp());
}

class CheersAdminApp extends StatelessWidget {
  const CheersAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    final api = AdminApiService();
    return MaterialApp(
      title: 'Cheers Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFD35400),
        scaffoldBackgroundColor: const Color(0xFF2B1B17),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD35400),
          secondary: Color(0xFFF39C12),
          surface: Color(0xFF3D2B24),
        ),
      ),
      home: AdminLoginScreen(api: api),
    );
  }
}
