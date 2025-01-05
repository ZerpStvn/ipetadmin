import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final current = FirebaseAuth.instance.currentUser!.uid;
  final userauth = FirebaseAuth.instance;
  Map<String, dynamic>? userData;

  Future<void> fetchUserData() async {
    try {
      final fetchdata = await FirebaseFirestore.instance
          .collection('users')
          .doc(userauth.currentUser!.uid)
          .get();

      if (fetchdata.exists) {
        setState(() {
          userData = fetchdata.data();
        });
      } else {
        print('Document does not exist.');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> _deleteBooking(String bookingId) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(current)
          .collection('books')
          .doc(bookingId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Booking deleted successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete booking: $e")),
      );
    }
  }

  Future<void> _markAsIn(String bookingId) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(current)
          .collection('books')
          .doc(bookingId)
          .update({'status': 'in'});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Booking marked as 'in'!")),
        );
      }
      await FirebaseFirestore.instance
          .collection('notif')
          .doc(bookingId)
          .collection('not')
          .add({
        "type": "booking",
        "title": "${userData!['nameclinic']} accepted your bookng",
        'clid': userauth.currentUser!.uid,
        'time': Timestamp.now(),
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update booking status: $e")),
        );
      }
    }
  }

  Widget _buildBookingTable() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .doc(current)
          .collection('books')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error loading bookings."));
        }

        final bookings = snapshot.data?.docs ?? [];

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: DataTable(
              columns: const [
                DataColumn(label: Text("Name")),
                DataColumn(label: Text("Start Date")),
                DataColumn(label: Text("End Date")),
                DataColumn(label: Text("Actions")),
              ],
              rows: bookings.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final bookingId = doc.id;
                final startDate = (data['startDate'] as Timestamp).toDate();
                final endDate = (data['endDate'] as Timestamp).toDate();

                return DataRow(cells: [
                  DataCell(FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(data['Name'])
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.hasError) {
                          return Text("Unknown");
                        } else {
                          var datan = snapshot.data!.data();
                          return Text("${datan!['fname']} ${datan['lname']}");
                        }
                      })),
                  DataCell(Text(DateFormat('yyyy-MM-dd').format(startDate))),
                  DataCell(Text(DateFormat('yyyy-MM-dd').format(endDate))),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteBooking(bookingId),
                      ),
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () => _markAsIn(bookingId),
                      ),
                    ],
                  )),
                ]);
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: _buildBookingTable(),
    );
  }
}
