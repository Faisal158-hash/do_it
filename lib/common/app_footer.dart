import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  // ─────────────── DATA ───────────────
  static const _menuItems = [
    'Home', 'About Us', 'Market Rates',
    'Sell Crops', 'Buy Crops', 'Contact',
  ];

  static const _addresses = [
    {
      'line1': 'Main Grain Market, Sabzi Mandi',
      'line2': 'Lahore, Punjab',
    },
    {
      'line1': '45-B Faisalabad Road',
      'line2': 'Sargodha, Punjab',
    },
  ];

  static const _contacts = [
    {'icon': FontAwesomeIcons.phone,    'label': '0300 1234567 – 0311 9876543'},
    {'icon': FontAwesomeIcons.whatsapp, 'label': '0300 1234567'},
    {'icon': FontAwesomeIcons.envelope, 'label': 'info@kisantraders.com'},
  ];

  static const _socialLinks = <String, String>{
    'facebook':  'https://www.facebook.com/kisantraders',
    'instagram': 'https://www.instagram.com/kisantraders',
    'whatsapp':  'https://wa.me/923001234567',
    'youtube':   'https://youtube.com/@kisantraders',
  };

  static IconData _socialIcon(String key) {
    switch (key) {
      case 'facebook':  return FontAwesomeIcons.facebookF;
      case 'instagram': return FontAwesomeIcons.instagram;
      case 'whatsapp':  return FontAwesomeIcons.whatsapp;
      case 'youtube':   return FontAwesomeIcons.youtube;
      default:          return FontAwesomeIcons.link;
    }
  }

  // ─────────────── BUILD ───────────────
  @override
  Widget build(BuildContext context) {
    final width  = MediaQuery.of(context).size.width;
    final isMobile  = width < 600;
    final isTablet  = width >= 600 && width < 1024;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _mainFooter(isMobile, isTablet, width),
        _bottomBar(isMobile, width),
      ],
    );
  }

  // ══════════════════════════════════════
  //  MAIN FOOTER BODY
  // ══════════════════════════════════════
  Widget _mainFooter(bool isMobile, bool isTablet, double width) {
    final hPad = width * 0.05;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(hPad, 40, hPad, 32),
      decoration: BoxDecoration(
        color: Colors.green.shade900,
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 12, offset: Offset(0, -3)),
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _brandBlock(),
                const SizedBox(height: 28),
                _followUs(),
                _divider(),
                _contactUs(),
                _divider(),
                _menuColumn(),
                _divider(),
                _storeAddresses(),
              ],
            )
          : isTablet
              ? Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _brandBlock()),
                        const SizedBox(width: 24),
                        Expanded(child: _followUs()),
                        const SizedBox(width: 24),
                        Expanded(child: _contactUs()),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _menuColumn()),
                        const SizedBox(width: 24),
                        Expanded(flex: 2, child: _storeAddresses()),
                      ],
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _brandBlock()),
                    const SizedBox(width: 16),
                    Expanded(child: _followUs()),
                    const SizedBox(width: 16),
                    Expanded(child: _contactUs()),
                    const SizedBox(width: 16),
                    Expanded(child: _menuColumn()),
                    const SizedBox(width: 16),
                    Expanded(child: _storeAddresses()),
                  ],
                ),
    );
  }

  // ══════════════════════════════════════
  //  BRAND BLOCK
  // ══════════════════════════════════════
  Widget _brandBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo row
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade700,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.grass_rounded, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kisan Traders',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Connecting Farmers & Markets',
                  style: TextStyle(
                    color: Colors.green.shade300,
                    fontSize: 10.5,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          'Empowering Pakistani farmers with real-time\nmarket rates, direct buyers, and fair prices.',
          style: TextStyle(
            color: Colors.white.withOpacity(0.65),
            fontSize: 12.5,
            height: 1.65,
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════
  //  FOLLOW US
  // ══════════════════════════════════════
  Widget _followUs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Follow Us'),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _socialLinks.entries.map((e) {
            return Tooltip(
              message: '@kisantraders',
              child: InkWell(
                onTap: () => _launch(e.value),
                borderRadius: BorderRadius.circular(50),
                splashColor: Colors.white24,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.shade700,
                    border: Border.all(color: Colors.green.shade500, width: 1.2),
                  ),
                  child: FaIcon(_socialIcon(e.key), color: Colors.white, size: 15),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),
        // Social handle labels
        ...{
          FontAwesomeIcons.instagram: '@kisantraders',
          FontAwesomeIcons.facebookF: '@KisanTradersPK',
          FontAwesomeIcons.youtube:   '@kisantraders',
        }.entries.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: Row(
              children: [
                FaIcon(e.key, color: Colors.green.shade300, size: 13),
                const SizedBox(width: 8),
                Text(
                  e.value,
                  style: TextStyle(color: Colors.white.withOpacity(0.80), fontSize: 12.5),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════
  //  CONTACT US
  // ══════════════════════════════════════
  Widget _contactUs() {
    final actions = [
      {'icon': FontAwesomeIcons.phone,    'text': '0300 1234567',           'url': 'tel:+923001234567'},
      {'icon': FontAwesomeIcons.phone,    'text': '0311 9876543',           'url': 'tel:+923119876543'},
      {'icon': FontAwesomeIcons.whatsapp, 'text': '0300 1234567',           'url': 'https://wa.me/923001234567'},
      {'icon': FontAwesomeIcons.envelope, 'text': 'info@kisantraders.com',  'url': 'mailto:info@kisantraders.com'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Contact Us'),
        const SizedBox(height: 14),
        ...actions.map(
          (a) => Padding(
            padding: const EdgeInsets.only(bottom: 11),
            child: InkWell(
              onTap: () => _launch(a['url'] as String),
              borderRadius: BorderRadius.circular(6),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.green.shade700,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FaIcon(a['icon'] as IconData, color: Colors.white, size: 11),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      a['text'] as String,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.82),
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════
  //  MENU
  // ══════════════════════════════════════
  Widget _menuColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Menu'),
        const SizedBox(height: 14),
        ..._menuItems.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chevron_right_rounded, color: Colors.green.shade400, size: 15),
                  const SizedBox(width: 4),
                  Text(
                    item,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.82),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════
  //  STORE ADDRESSES
  // ══════════════════════════════════════
  Widget _storeAddresses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Our Locations'),
        const SizedBox(height: 14),
        ..._addresses.map(
          (addr) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.green.shade700,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.location_on_rounded, color: Colors.white, size: 13),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      addr['line1']!,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      addr['line2']!,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.60),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════
  //  BOTTOM BAR  (was the old full footer)
  // ══════════════════════════════════════
  Widget _bottomBar(bool isMobile, double width) {
    final hPad = width * 0.05;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 12),
      color: Colors.green.shade500,  // one shade darker for clear separation
      child: isMobile
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _socialIconsRow(),
                const SizedBox(height: 8),
                _copyrightText(),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _copyrightText(),
                _socialIconsRow(),
              ],
            ),
    );
  }

  Widget _copyrightText() {
    return Text(
      '© Kisan Traders 2026 – All rights reserved',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 12),
    );
  }

  Widget _socialIconsRow() {
    return Wrap(
      spacing: 10,
      children: _socialLinks.entries.map((e) {
        return InkWell(
          onTap: () => _launch(e.value),
          borderRadius: BorderRadius.circular(50),
          splashColor: Colors.white24,
          child: Container(
            padding: const EdgeInsets.all(7),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white12,
            ),
            child: FaIcon(_socialIcon(e.key), color: Colors.white, size: 14),
          ),
        );
      }).toList(),
    );
  }

  // ─────────────── HELPERS ───────────────
  Widget _sectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 32,
          height: 3,
          decoration: BoxDecoration(
            color: Colors.green.shade400,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _divider() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Divider(color: Colors.white.withOpacity(0.12), thickness: 1),
      );

  void _launch(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }
}