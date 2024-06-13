import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gopetadmin/pages/recordsview.dart';

class ViewMedRecord extends StatefulWidget {
  const ViewMedRecord({super.key});

  @override
  State<ViewMedRecord> createState() => _ViewMedRecordState();
}

class _ViewMedRecordState extends State<ViewMedRecord> {
  List<Map<String, dynamic>> records = [];
  List<Map<String, dynamic>> _filteredData = [];
  final TextEditingController search = TextEditingController();
  String? vetID;
  User? user = FirebaseAuth.instance.currentUser;
  String? docid;
  bool isview = false;
  bool isedit = false;
  @override
  void initState() {
    super.initState();
    handlegetuserdataRecord();
  }

  Future<void> handlegetuserdataRecord() async {
    try {
      final QuerySnapshot record = await FirebaseFirestore.instance
          .collection('medicalrecord')
          .doc(user!.uid)
          .collection('records')
          .get();

      if (record.docs.isNotEmpty) {
        setState(() {
          records = record.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            docid = doc.id;
            return data;
          }).toList();
          _filteredData = records;
        });
      }
    } catch (e) {
      debugPrint("$e");
    }
  }

  void _filterData(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredData = records;
      });
    } else {
      setState(() {
        _filteredData = records
            .where((data) =>
                data['owner_name']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                data['pet_name']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                data['owner_phone']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                data['owner_email']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  Future<void> deletedata() async {
    try {
      await FirebaseFirestore.instance
          .collection('medicalrecord')
          .doc(user!.uid)
          .collection('records')
          .doc(docid)
          .delete()
          .then((value) {
        showAlertinfo("Data Completely Deleted");
      });
    } catch (e) {
      showAlertinfo("Error Deleting the Data!\nTry again later");
    }
  }

  void showAlertinfo(String content) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Information"),
            content: Text(content),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);

                    setState(() {});
                  },
                  child: const Text("Continue"))
            ],
          );
        });
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(11.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 0,
          ),
          const Text(
            "List of Records",
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
              columns: const [
                DataColumn(label: Text("ID")),
                DataColumn(label: Text("Owners Name")),
                DataColumn(label: Text("Email")),
                DataColumn(label: Text("Contact")),
                DataColumn(
                  label: Text("Pets Name"),
                ),
                DataColumn(label: Text("Actions")),
              ],
              rows: _filteredData.map((data) {
                // Timestamp timestamp = data['appoinmentdate'] ?? Timestamp.now();
                // DateTime dateTime = timestamp.toDate();
                // String formattedDate =
                //     DateFormat('MMMM dd, yyyy h:mm a').format(dateTime);

                return DataRow(cells: [
                  DataCell(
                    Text(
                      docid != null
                          ? (docid!.length > 7
                              ? docid!.substring(0, 7)
                              : docid!)
                          : '',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(Text(data['owner_name'] ?? '')),
                  DataCell(Text(data['owner_email'] ?? '')),
                  DataCell(Text(data['owner_phone'] ?? '')),
                  DataCell(Text(data['pet_name'] ?? '')),
                  DataCell(Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RecordsView(
                                        userID: user!.uid,
                                        recordID: docid!,
                                        isview: true,
                                      )));
                        },
                        icon: const Icon(Icons.visibility_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RecordsView(
                                        userID: user!.uid,
                                        recordID: docid!,
                                        isview: false,
                                      )));
                        },
                        icon: const Icon(Icons.edit_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                          deletedata();
                        },
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  )),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
