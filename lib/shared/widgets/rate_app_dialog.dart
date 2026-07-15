import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RateAppDialog {
  static const String _rateDialogShownKey = 'rate_dialog_shown';
  static const int _daysBeforePrompt = 3;

  static Future<void> checkAndShow(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final hasShown = prefs.getBool(_rateDialogShownKey) ?? false;
    
    final installDate = prefs.getString('install_date');
    if (installDate != null) {
      final date = DateTime.parse(installDate);
      final days = DateTime.now().difference(date).inDays;
      if (days < _daysBeforePrompt) return;
    } else {
      prefs.setString('install_date', DateTime.now().toIso8601String());
      return;
    }

    if (hasShown) return;
    
    Future.delayed(const Duration(seconds: 5), () {
      if (context.mounted) {  // ✅ Guard
        _showRateDialog(context);
      }
    });
  }

  static Future<void> _showRateDialog(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const _RateDialog(),
    );

    if (result == true) {
      final url = Uri.parse('https://play.google.com/store/apps/details?id=com.tekflow.app');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
      prefs.setBool(_rateDialogShownKey, true);
    } else if (result == false) {
      prefs.setBool(_rateDialogShownKey, true);
    } else {
      prefs.setString('rate_dialog_later', DateTime.now().toIso8601String());
    }
  }
}

class _RateDialog extends StatefulWidget {
  const _RateDialog();

  @override
  State<_RateDialog> createState() => _RateDialogState();
}

class _RateDialogState extends State<_RateDialog> {
  int _rating = 0;
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Column(
        children: [
          const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 48),
          const SizedBox(height: 8),
          Text(
            'Enjoying tekflow?',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
      content: _submitted
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.favorite_rounded, color: Color(0xFFE8365D), size: 48),
                const SizedBox(height: 12),
                Text(
                  'Thank you for your rating! ❤️',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your feedback helps us improve tekflow.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Rate our app on the Play Store',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () => setState(() => _rating = index + 1),
                      child: Icon(
                        index < _rating ? Icons.star_rounded : Icons.star_border_rounded,
                        color: const Color(0xFFFFB300),
                        size: 40,
                      ).animate().scale(
                        duration: 200.ms,
                        curve: Curves.elasticOut,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context, null),
                        child: Text(
                          'Later',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _rating >= 4
                            ? () {
                                setState(() => _submitted = true);
                                Future.delayed(const Duration(seconds: 1), () {
                                  if (mounted) Navigator.pop(context, true);  // ✅ Guard
                                });
                              }
                            : _rating >= 1
                                ? () {
                                    setState(() => _submitted = true);
                                    Future.delayed(const Duration(seconds: 1), () {
                                      if (mounted) Navigator.pop(context, false);  // ✅ Guard
                                    });
                                  }
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00D4FF),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _rating >= 4 ? 'Rate Now ⭐' : 'Send Feedback',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}