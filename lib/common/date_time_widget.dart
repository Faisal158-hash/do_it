import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeWidget extends StatefulWidget {
  const DateTimeWidget({super.key});

  @override
  State<DateTimeWidget> createState() => _DateTimeWidgetState();
}

class _DateTimeWidgetState extends State<DateTimeWidget> {
  late Timer _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();

    // ⭐ smoother and more professional update system
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _now = DateTime.now());
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get formattedDate =>
      DateFormat('EEE, dd MMM yyyy').format(_now);

  String get formattedTime =>
      DateFormat('hh:mm:ss a').format(_now);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // ⭐ responsive sizing
    final isMobile = width < 600;
    final paddingHorizontal = width * 0.03;
    final paddingVertical = width * 0.02;
    final dateFontSize = isMobile ? 11.0 : 13.0;
    final timeFontSize = isMobile ? 13.0 : 16.0;
    final borderRadius = width * 0.04;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),

      /// ⭐ glass blur effect
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: paddingHorizontal,
            vertical: paddingVertical,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.35),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          /// ⭐ modern layout
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// DATE
              Text(
                formattedDate,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: dateFontSize,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 2),

              /// TIME
              Text(
                formattedTime,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: timeFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}