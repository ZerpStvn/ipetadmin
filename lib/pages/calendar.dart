import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gopetadmin/misc/theme.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class UserAppointmentcheck extends StatefulWidget {
  final bool isvetadmin;
  const UserAppointmentcheck({super.key, required this.isvetadmin});

  @override
  State<UserAppointmentcheck> createState() => _UserAppointmentcheckState();
}

class _UserAppointmentcheckState extends State<UserAppointmentcheck> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<AppointEvent>> events = {};

  User? current = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    fetchData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> fetchData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('appointment')
          .doc(current!.uid)
          .collection('vet')
          .get();

      // final List<Map<String, dynamic>> fetchedData =
      //     snapshot.docs.map((doc) => doc.data()).toList();

      Map<DateTime, List<AppointEvent>> newEvents = {};
      for (var doc in snapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;

        Timestamp timestamp = data['appoinmentdate'];
        DateTime dateTime = timestamp.toDate();
        DateTime dateOnly =
            DateTime(dateTime.year, dateTime.month, dateTime.day);

        String formattedDate =
            DateFormat('EEE, M/d/y, h:mm a').format(dateOnly);
        if (newEvents[dateOnly] == null) {
          newEvents[dateOnly] = [];
        }

        newEvents[dateOnly]!.add(AppointEvent(
          name: data['clinic'],
          status: data['status'],
          date: formattedDate,
          vetid: doc.id,
          userid: data['userid'],
          username: data['name'],
          service: data['service'],
          purpose: data['purpose'],
        ));

        debugPrint('Events ID: ${doc.id}');
      }

      setState(() {
        events = newEvents;
      });
    } catch (error) {
      debugPrint("Error fetching data: $error");
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: widget.isvetadmin == false ? 50 : 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: _calendarFormat,
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: _onDaySelected,
              eventLoader: (day) {
                DateTime dateOnly = DateTime(day.year, day.month, day.day);
                debugPrint("event date ${events[dateOnly] ?? []}");
                return events[dateOnly] ?? [];
              },
              calendarStyle: const CalendarStyle(
                outsideDaysVisible: false,
              ),
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
            ),
          ),
          if (_selectedDay != null &&
              events[DateTime(_selectedDay!.year, _selectedDay!.month,
                      _selectedDay!.day)] !=
                  null)
            SizedBox(
              height: 250, // Adjust the height as needed
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // Number of columns
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 3, // Adjust the aspect ratio as needed
                    mainAxisExtent: 185),
                itemCount: events[DateTime(_selectedDay!.year,
                        _selectedDay!.month, _selectedDay!.day)]!
                    .length,
                itemBuilder: (context, index) {
                  final event = events[DateTime(_selectedDay!.year,
                      _selectedDay!.month, _selectedDay!.day)]![index];
                  return Card(
                    elevation: 29,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 85,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: maincolor),
                            ),
                            Positioned(
                                top: 20,
                                right: 0,
                                left: 0,
                                bottom: 0,
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.calendar_month_outlined,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      event.date,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )
                                  ],
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Center(child: Text(event.username)),
                        const SizedBox(
                          height: 15,
                        ),
                        Chip(
                            backgroundColor: maincolor,
                            label: Text(
                              event.service,
                              style: const TextStyle(color: Colors.white),
                            )),
                      ],
                    ),
                  );
                },
              ),
            )
          else
            const SizedBox(
              height: 250,
              child: Center(
                child: Text("You Don't Have Any Appointments"),
              ),
            ),
        ],
      ),
    );
  }

  Color renderColor(int status) {
    switch (status) {
      case 0:
        return maincolor;
      case 1:
        return Colors.redAccent;
      default:
        return maincolor;
    }
  }
}

class AppointEvent {
  String name;
  int status;
  String date;
  String vetid;
  String username;
  String userid;
  String service;
  String purpose;

  AppointEvent(
      {required this.vetid,
      required this.userid,
      required this.username,
      required this.name,
      required this.status,
      required this.service,
      required this.purpose,
      required this.date});
}
