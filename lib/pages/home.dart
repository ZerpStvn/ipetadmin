import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gopetadmin/misc/theme.dart';
import 'package:gopetadmin/pages/Feedbacks.dart';
import 'package:gopetadmin/pages/appointment.dart';
import 'package:gopetadmin/pages/calendar.dart';
import 'package:gopetadmin/pages/login.dart';
import 'package:gopetadmin/pages/profile.dart';

class HomeScreenVeterinary extends StatefulWidget {
  const HomeScreenVeterinary({super.key});

  @override
  State<HomeScreenVeterinary> createState() => _HomeScreenVeterinaryState();
}

class _HomeScreenVeterinaryState extends State<HomeScreenVeterinary> {
  int selectedIndex = 0;

  Widget navigator() {
    if (selectedIndex == 0) {
      return const UserAppointmentcheck(
        isvetadmin: true,
      );
    } else if (selectedIndex == 1) {
      return const Appointments();
    } else if (selectedIndex == 2) {
      return const VeterinaryProfile();
    } else if (selectedIndex == 3) {
      return const FeedbackReviews();
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
              flex: 1,
              child: Drawer(
                backgroundColor: maincolor,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      ListTile(
                        onTap: () {
                          setState(() {
                            selectedIndex = 0;
                          });
                        },
                        title: const Text(
                          "Calendar",
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: const Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ListTile(
                        onTap: () {
                          setState(() {
                            selectedIndex = 1;
                          });
                        },
                        title: const Text(
                          "Appointments",
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: const Icon(
                          Icons.list_alt_outlined,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ListTile(
                        onTap: () {
                          setState(() {
                            selectedIndex = 2;
                          });
                        },
                        title: const Text(
                          "Profile",
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: const Icon(
                          Icons.person_outline,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ListTile(
                        onTap: () {
                          setState(() {
                            selectedIndex = 3;
                          });
                        },
                        title: const Text(
                          "Feedbacks",
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: const Icon(
                          Icons.comment_outlined,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      ListTile(
                        onTap: () {
                          logout();
                        },
                        title: const Text(
                          "Logut",
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: const Icon(
                          Icons.logout_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          Expanded(
              flex: 5,
              child: Column(
                children: [navigator()],
              ))
        ],
      ),
    );
  }

  final userAuth = FirebaseAuth.instance;
  Future<void> logout() async {
    await userAuth.signOut().then((value) {
      setState(() {});
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const GloballoginController()),
          (route) => false);
    });
  }
}
