import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gopetadmin/misc/theme.dart';
import 'package:intl/intl.dart';

class Appointments extends StatefulWidget {
  const Appointments({super.key});

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  User? currentuser = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> listdata = [];
  List<Map<String, dynamic>> _filteredData = [];
  final TextEditingController search = TextEditingController();
  String? docid;
  bool isview = false;
  String? name;
  dynamic appoinmentdate;
  String? clinic;
  String? urlprof;
  String? purpose;
  String? service;
  bool isAscending = true;

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  Future<void> fetchdata() async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('appointment')
          .doc(currentuser!.uid)
          .collection('vet')
          .get();

      if (query.docs.isNotEmpty) {
        setState(() {
          listdata = query.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            docid = doc.id;
            return data;
          }).toList();
          _filteredData = listdata;
        });
      }
    } catch (e) {
      debugPrint("$e");
    }
  }

  void _filterData(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredData = listdata;
      });
    } else {
      setState(() {
        _filteredData = listdata
            .where((data) =>
                data['name']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                data['userid']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  void _sortDataByDate() {
    setState(() {
      isAscending = !isAscending;
      _filteredData.sort((a, b) {
        Timestamp timestampA = a['appoinmentdate'] ?? Timestamp.now();
        Timestamp timestampB = b['appoinmentdate'] ?? Timestamp.now();
        DateTime dateA = timestampA.toDate();
        DateTime dateB = timestampB.toDate();

        if (isAscending) {
          return dateA.compareTo(dateB);
        } else {
          return dateB.compareTo(dateA);
        }
      });
    });
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text(
              "List of Appointments",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 260,
              height: 50,
              child: TextFormField(
                controller: search,
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.search_outlined),
                  hintText: "Search",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  _filterData(value);
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.80,
              child: DataTable(
                sortAscending: isAscending,
                sortColumnIndex: 2,
                columns: [
                  const DataColumn(label: Text("ID")),
                  const DataColumn(label: Text("Name")),
                  DataColumn(
                    label: const Text("Date"),
                    onSort: (columnIndex, _) {
                      _sortDataByDate();
                    },
                  ),
                  const DataColumn(label: Text("Actions")),
                ],
                rows: _filteredData.map((data) {
                  Timestamp timestamp =
                      data['appoinmentdate'] ?? Timestamp.now();
                  DateTime dateTime = timestamp.toDate();
                  String formattedDate =
                      DateFormat('MMMM dd, yyyy h:mm a').format(dateTime);

                  return DataRow(cells: [
                    DataCell(
                      Text(
                        data['userid'] != null
                            ? (data['userid'].length > 7
                                ? data['userid'].substring(0, 7)
                                : data['userid'])
                            : '',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    DataCell(Text(data['name'] ?? '')),
                    DataCell(Text(formattedDate)),
                    DataCell(IconButton(
                      onPressed: () {
                        setState(() {
                          name = data['name'];
                          appoinmentdate = data['appoinmentdate'];
                          clinic = data['clinic'];
                          urlprof = data['profile'];
                          purpose = data['purpose'];
                          service = data['service'];
                          isview = !isview;
                        });

                        showModalinfo();
                      },
                      icon: const Icon(Icons.visibility_outlined),
                    )),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showModalinfo() {
    Timestamp timestamp = appoinmentdate ?? Timestamp.now();
    DateTime dateTime = timestamp.toDate();
    String formattedDate = DateFormat('MMMM dd, yyyy h:mm a').format(dateTime);

    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 18,
                    ),
                    Center(
                      child: Icon(
                        Icons.calendar_month_outlined,
                        color: maincolor,
                        size: 110,
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Text("Name: $name"),
                    const SizedBox(
                      height: 18,
                    ),
                    Text("Schedule: $formattedDate"),
                    const SizedBox(
                      height: 18,
                    ),
                    const Text("Service: "),
                    const SizedBox(
                      height: 13,
                    ),
                    Chip(
                      label: Text("$service"),
                      backgroundColor: maincolor,
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    const Text("Purpose: "),
                    const SizedBox(
                      height: 13,
                    ),
                    Chip(
                      label: Text("$purpose"),
                      backgroundColor: maincolor,
                    ),
                    const SizedBox(
                      height: 18,
                    )
                  ],
                ),
              )
            ],
          );
        });
  }
}
