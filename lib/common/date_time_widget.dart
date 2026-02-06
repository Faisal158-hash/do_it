import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeWidget extends StatefulWidget {
  const DateTimeWidget({super.key});

  @override
  State<DateTimeWidget> createState() => _DateTimeWidgetState();
}

class _DateTimeWidgetState extends State<DateTimeWidget> {
  late String _timeString;

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  void _updateTime() {
    _timeString = _formatDateTime(DateTime.now());
    if (mounted) {
      setState(() {});
      Future.delayed(const Duration(seconds: 1), _updateTime);
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('EEE, dd MMM yyyy • hh:mm:ss a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _timeString,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }
}
