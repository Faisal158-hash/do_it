import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

final Map<IconData, String> _socialLinks = {
  FontAwesomeIcons.facebookF: 'https://www.facebook.com/kisantraders',
  FontAwesomeIcons.instagram: 'https://www.instagram.com/kisantraders',
  FontAwesomeIcons.whatsapp: 'https://wa.me/1234567890',
};

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.green.shade900,
        borderRadius: const BorderRadius.vertical(top: Radius.zero),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left Spacer (optional, can be 0)
          const Spacer(flex: 1),

          // COPYRIGHT TEXT CENTERED
          const Text(
            '© Kisan Traders 2026',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          // Right Spacer pushes icons to the right
          const Spacer(flex: 1),

          // SOCIAL ICONS
          Row(
            children: _socialLinks.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: InkWell(
                  onTap: () => _launchURL(entry.value),
                  borderRadius: BorderRadius.circular(30),
                  splashColor: Colors.white24,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white12,
                    ),
                    child: FaIcon(entry.key, color: Colors.white, size: 18),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // 🔹 Open social link
  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }
}
