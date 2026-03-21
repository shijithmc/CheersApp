import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_data_provider.dart';
import '../home/home_shell.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});
  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _age = TextEditingController();
  final _email = TextEditingController();
  final _address = TextEditingController();
  final _pincode = TextEditingController();
  String _bloodGroup = 'O+';

  static const _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.topBarBg,
      appBar: AppBar(title: const Text('Complete Profile'), backgroundColor: AppTheme.topBarBg),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFC0392B), border: Border.all(color: AppTheme.primary, width: 3)),
                child: const Center(child: Icon(Icons.person, size: 50, color: Colors.white)),
              ),
              const SizedBox(height: 16),
              _field(_name, 'Name'),
              _field(_age, 'Age', keyboard: TextInputType.number),
              _field(_email, 'Email', keyboard: TextInputType.emailAddress),
              _field(_address, 'Address'),
              _field(_pincode, 'Pin Code', keyboard: TextInputType.number),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _bloodGroup,
                items: _bloodGroups.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                onChanged: (v) => setState(() => _bloodGroup = v ?? 'O+'),
                decoration: InputDecoration(
                  labelText: 'Blood Group',
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide(color: Colors.white.withOpacity(0.35))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: const BorderSide(color: AppTheme.primary)),
                  filled: true, fillColor: Colors.white.withOpacity(0.08),
                ),
                dropdownColor: AppTheme.topBarBg,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Save Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label, {TextInputType? keyboard}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboard,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide(color: Colors.white.withOpacity(0.35))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: const BorderSide(color: AppTheme.primary)),
          filled: true, fillColor: Colors.white.withOpacity(0.08),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  void _save() {
    final auth = context.read<AuthProvider>();
    final user = UserModel(
      uid: auth.user?.uid ?? 'demo',
      name: _name.text,
      phone: auth.user?.phone ?? '',
      age: int.tryParse(_age.text) ?? 21,
      bloodGroup: _bloodGroup,
      email: _email.text,
      address: _address.text,
      pincode: _pincode.text,
      points: 789,
    );
    auth.updateProfile(user);
    context.read<AppDataProvider>().loadAll(user.uid);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeShell()));
  }
}
