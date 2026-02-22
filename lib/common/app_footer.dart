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
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    final paddingHorizontal = width * 0.04;
    final paddingVertical = 12.0; // fixed padding to avoid huge stretch
    final fontSize = isMobile ? 13.0 : 15.0;
    final iconSize = isMobile ? 16.0 : 20.0;
    final circlePadding = isMobile ? 8.0 : 10.0;

    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: paddingHorizontal,
          vertical: paddingVertical,
        ),
        decoration: BoxDecoration(
          color: Colors.green.shade900,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: isMobile
            ? Column(
                mainAxisSize: MainAxisSize.min, // important to prevent full screen
                children: [
                  _buildCopyright(fontSize),
                  const SizedBox(height: 8),
                  _buildSocialIcons(iconSize, circlePadding),
                ],
              )
            : Row(
                mainAxisSize: MainAxisSize.min, // important
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCopyright(fontSize),
                  _buildSocialIcons(iconSize, circlePadding),
                ],
              ),
      ),
    );
  }

  // ================= COPYRIGHT =================
  Widget _buildCopyright(double fontSize) {
    return Text(
      '© Kisan Traders 2026',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white70,
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // ================= SOCIAL ICONS =================
  Widget _buildSocialIcons(double iconSize, double padding) {
    return Wrap(
      spacing: 10,
      children: _socialLinks.entries.map((entry) {
        return InkWell(
          onTap: () => _launchURL(entry.value),
          borderRadius: BorderRadius.circular(50),
          splashColor: Colors.white24,
          child: Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white12,
            ),
            child: FaIcon(
              entry.key,
              color: Colors.white,
              size: iconSize,
            ),
          ),
        );
      }).toList(),
    );
  }

  // ================= URL LAUNCH =================
  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }
}