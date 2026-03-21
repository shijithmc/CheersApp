import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_data_provider.dart';
import '../home/home_shell.dart';
import 'dart:async';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneCtrl = TextEditingController();
  final List<TextEditingController> _otpCtrls = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocus = List.generate(6, (_) => FocusNode());
  bool _otpSent = false;
  bool _ageConfirmed = true;
  int _resendSeconds = 0;
  Timer? _timer;

  bool get _phoneValid => _phoneCtrl.text.length == 10;
  bool get _otpComplete => _otpCtrls.every((c) => c.text.isNotEmpty);

  @override
  void dispose() {
    _phoneCtrl.dispose();
    for (final c in _otpCtrls) c.dispose();
    for (final f in _otpFocus) f.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _resendSeconds = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        _resendSeconds--;
        if (_resendSeconds <= 0) t.cancel();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: AppTheme.topBarBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
            child: Column(
              children: [
                const Text('🍺🍺', style: TextStyle(fontSize: 70)),
                const SizedBox(height: 8),
                const Text('Cherse', style: TextStyle(fontSize: 52, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -2)),
                const SizedBox(height: 36),
                if (!_otpSent) _phoneStep(auth) else _otpStep(auth),
                const SizedBox(height: 14),
                _statutoryWarning(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _phoneStep(AuthProvider auth) {
    return Column(
      children: [
        _phoneField(),
        const SizedBox(height: 14),
        Text('Enter your 10-digit mobile number',
            style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.35))),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 18, height: 18,
              child: Checkbox(
                value: _ageConfirmed,
                onChanged: (v) => setState(() => _ageConfirmed = v ?? false),
                activeColor: AppTheme.primary,
                side: BorderSide(color: Colors.white.withOpacity(0.5)),
              ),
            ),
            const SizedBox(width: 8),
            Text('Are you 21 Years Old ?', style: TextStyle(color: Colors.white.withOpacity(0.65), fontSize: 13)),
          ],
        ),
        const SizedBox(height: 14),
        _primaryButton(
          label: 'Send OTP',
          enabled: _phoneValid && _ageConfirmed && !auth.isLoading,
          loading: auth.isLoading,
          onTap: () async {
            final ok = await auth.sendOtp(_phoneCtrl.text);
            if (ok || true) {
              setState(() => _otpSent = true);
              _startTimer();
              Future.delayed(const Duration(milliseconds: 100), () => _otpFocus[0].requestFocus());
            }
          },
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => _enterDemoMode(context),
          child: Text('Enter Demo Mode', style: TextStyle(color: AppTheme.accent, fontSize: 13)),
        ),
      ],
    );
  }

  Widget _otpStep(AuthProvider auth) {
    return Column(
      children: [
        Text('OTP sent to', style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.55))),
        const SizedBox(height: 3),
        Text('+91 ${_phoneCtrl.text.substring(0, 5)}XXXXX',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => setState(() => _otpSent = false),
          child: const Text('Change number', style: TextStyle(fontSize: 11, color: AppTheme.primary)),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(6, (i) => Container(
            width: 44, height: 52, margin: const EdgeInsets.symmetric(horizontal: 4),
            child: TextField(
              controller: _otpCtrls[i],
              focusNode: _otpFocus[i],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                counterText: '',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white.withOpacity(0.3))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white.withOpacity(0.3))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primary)),
                filled: true,
                fillColor: _otpCtrls[i].text.isNotEmpty ? AppTheme.primary.withOpacity(0.2) : Colors.white.withOpacity(0.08),
              ),
              onChanged: (v) {
                setState(() {});
                if (v.isNotEmpty && i < 5) _otpFocus[i + 1].requestFocus();
                if (v.isEmpty && i > 0) _otpFocus[i - 1].requestFocus();
              },
            ),
          )),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_resendSeconds > 0)
              Text('Resend in ${_resendSeconds}s', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.45)))
            else
              GestureDetector(
                onTap: () {
                  for (final c in _otpCtrls) c.clear();
                  setState(() {});
                  _startTimer();
                  _otpFocus[0].requestFocus();
                },
                child: const Text('Resend OTP', style: TextStyle(fontSize: 12, color: AppTheme.primary)),
              ),
          ],
        ),
        const SizedBox(height: 16),
        _primaryButton(
          label: 'Login',
          enabled: _otpComplete && !auth.isLoading,
          loading: auth.isLoading,
          onTap: () async {
            final otp = _otpCtrls.map((c) => c.text).join();
            final ok = await auth.verifyOtp(_phoneCtrl.text, otp);
            if (mounted) {
              if (ok) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeShell()));
              } else {
                _enterDemoMode(context);
              }
            }
          },
        ),
      ],
    );
  }

  Widget _phoneField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(0.35), width: 1.5),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text('+91', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14, fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: TextField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              style: const TextStyle(color: Colors.white, fontSize: 15, letterSpacing: 1),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                counterText: '',
                hintText: 'Phone Number',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }

  Widget _primaryButton({required String label, required bool enabled, required VoidCallback onTap, bool loading = false}) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.primary,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Opacity(
          opacity: enabled ? 1.0 : 0.45,
          child: Center(
            child: loading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }

  Widget _statutoryWarning() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF111111), borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          const Text('🚭🍺', style: TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text.rich(TextSpan(children: [
            const TextSpan(text: 'STATUTORY WARNING\n', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
            TextSpan(text: 'SMOKING AND ALCOHOL CONSUMPTION IS INJURIOUS TO HEALTH', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10)),
          ]), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  void _enterDemoMode(BuildContext context) {
    context.read<AppDataProvider>().loadDemo();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeShell()));
  }
}
