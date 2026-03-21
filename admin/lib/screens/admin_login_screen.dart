import 'package:flutter/material.dart';
import '../services/admin_api_service.dart';
import 'dashboard_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  final AdminApiService api;
  const AdminLoginScreen({super.key, required this.api});
  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B1B17),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.admin_panel_settings, size: 64, color: Color(0xFFD35400)),
              const SizedBox(height: 16),
              const Text('Cheers Admin',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFD35400))),
              const SizedBox(height: 8),
              const Text('Management Panel', style: TextStyle(color: Colors.white54)),
              const SizedBox(height: 32),
              TextField(
                controller: _emailCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecor('Admin Email', Icons.email),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passCtrl,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecor('Password', Icons.lock),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _loading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD35400),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      : const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecor(String label, IconData icon) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: const Color(0xFFD35400)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white24)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFD35400))),
        filled: true,
        fillColor: const Color(0xFF3D2B24),
      );

  Future<void> _login() async {
    setState(() { _loading = true; _error = null; });
    final ok = await widget.api.login(_emailCtrl.text, _passCtrl.text);
    if (ok && mounted) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => DashboardScreen(api: widget.api)));
    } else {
      setState(() { _loading = false; _error = 'Invalid credentials'; });
    }
  }
}
