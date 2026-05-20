// ─── rates_data.dart — Data Layer (models + static data) ─────────────────────

import 'package:flutter/material.dart';

// ─── Color Palette ────────────────────────────────────────────────────────────
const Color kGreenPrimary = Color(0xFF2E7D32);
const Color kGreenDark    = Color(0xFF1B5E20);
const Color kGreenLight   = Color(0xFF66BB6A);
const Color kGreenPale    = Color(0xFFE8F5E9);
const Color kGreenMint    = Color(0xFFF1F8E9);
const Color kGreenBorder  = Color(0xFFC8E6C9);
const Color kRedAlert     = Color(0xFFD32F2F);

// ─── Model ────────────────────────────────────────────────────────────────────
class CropRate {
  final String name;
  final String emoji;
  final String rate;
  final String unit;
  final String change;
  final double changeVal;
  final bool isUp;
  final String msp;
  final bool? aboveMsp;
  final String high;
  final String low;

  const CropRate({
    required this.name,
    required this.emoji,
    required this.rate,
    required this.unit,
    required this.change,
    required this.changeVal,
    required this.isUp,
    required this.msp,
    this.aboveMsp,
    required this.high,
    required this.low,
  });

  Color get trendColor => isUp ? kGreenPrimary : kRedAlert;
  Color get trendBg    => isUp ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE);
}

// ─── Static Data ──────────────────────────────────────────────────────────────
class RatesData {
  RatesData._();

  static const List<String> mandis = [
    'Lahore Mandi',
    'Faisalabad Mandi',
    'Multan Mandi',
    'Gujranwala Mandi',
    'Rawalpindi Mandi',
  ];

  /// Only 3 featured crops shown on screen.
  static const List<CropRate> featured = [
    CropRate(
      name: 'Wheat',
      emoji: '🌾',
      rate: '₨ 2,275',
      unit: 'per Quintal',
      change: '+1.8%',
      changeVal: 41.0,
      isUp: true,
      msp: '₨ 2,125',
      aboveMsp: true,
      high: '₨ 2,310',
      low: '₨ 2,200',
    ),
    CropRate(
      name: 'Basmati Rice',
      emoji: '🍚',
      rate: '₨ 4,520',
      unit: 'per Quintal',
      change: '+0.4%',
      changeVal: 18.0,
      isUp: true,
      msp: '₨ 4,000',
      aboveMsp: true,
      high: '₨ 4,600',
      low: '₨ 4,460',
    ),
    CropRate(
      name: 'Cotton',
      emoji: '🧶',
      rate: '₨ 6,780',
      unit: 'per Quintal',
      change: '-1.2%',
      changeVal: -82.0,
      isUp: false,
      msp: '₨ 6,620',
      aboveMsp: true,
      high: '₨ 6,900',
      low: '₨ 6,720',
    ),
  ];

  static const String lastUpdated = '9:45 AM';

  static const marketSummary = (up: 14, down: 4, stable: 2);
}