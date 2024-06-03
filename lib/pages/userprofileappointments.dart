import 'package:flutter/material.dart';

class UserProfileAppointments extends StatefulWidget {
  final String name;
  final dynamic appoinmentdate;
  final String clinic;
  final String urlprof;
  final String purpose;
  final String service;
  const UserProfileAppointments(
      {super.key,
      required this.name,
      this.appoinmentdate,
      required this.clinic,
      required this.urlprof,
      required this.purpose,
      required this.service});

  @override
  State<UserProfileAppointments> createState() =>
      _UserProfileAppointmentsState();
}

class _UserProfileAppointmentsState extends State<UserProfileAppointments> {
  List<Map<String, dynamic>> listdata = [];

  @override
  Widget build(BuildContext context) {
    return const Column();
  }
}
