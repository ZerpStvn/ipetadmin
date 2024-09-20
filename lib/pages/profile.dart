import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gopetadmin/controller/hooks.dart';
import 'package:gopetadmin/misc/randomstring.dart';
import 'package:gopetadmin/misc/theme.dart';
import 'package:gopetadmin/model/authprovider.dart';
import 'package:provider/provider.dart';

class VeterinaryProfile extends StatefulWidget {
  const VeterinaryProfile({super.key});

  @override
  State<VeterinaryProfile> createState() => _VeterinaryProfileState();
}

class _VeterinaryProfileState extends State<VeterinaryProfile> {
  final FirebaseAuth userauth = FirebaseAuth.instance;
  final FirebaseFirestore usercred = FirebaseFirestore.instance;

  TextEditingController _tinController = TextEditingController();
  TextEditingController _birController = TextEditingController();
  TextEditingController _dtiController = TextEditingController();

  bool isEditing = false;

  // Function to update data in Firestore
  Future<void> _updateServices(String tin, String bir, String dti) async {
    await usercred
        .doc(userauth.currentUser!.uid)
        .collection('vertirenary')
        .doc(userauth.currentUser!.uid)
        .update({
      'tin': tin,
      'bir': bir,
      'dti': dti,
    });
    setState(() {
      isEditing = false; // Exit edit mode after updating
    });
  }

  // Function to toggle between view and edit mode
  void _toggleEdit(Map<String, dynamic> services) {
    setState(() {
      isEditing = true;
      _tinController.text = services['tin'];
      _birController.text = services['bir'];
      _dtiController.text = services['dti'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: usercred
          .doc(userauth.currentUser!.uid)
          .collection('vertirenary')
          .doc(userauth.currentUser!.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          Map<String, dynamic>? services;
          if (snapshot.data!.exists) {
            services = snapshot.data!.data() as Map<String, dynamic>;
          }

          if (isEditing) {
            // Editing UI
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _tinController,
                  decoration: InputDecoration(labelText: 'TIN ID'),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _birController,
                  decoration: InputDecoration(labelText: 'BIR Certificate URL'),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _dtiController,
                  decoration: InputDecoration(labelText: 'DTI Certificate URL'),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () {
                    _updateServices(
                      _tinController.text,
                      _birController.text,
                      _dtiController.text,
                    );
                  },
                  child: const Text('Save'),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isEditing = false;
                    });
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          } else {
            // Viewing UI
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Government ID"),
                const SizedBox(height: 18),
                ListTile(
                  leading: const Icon(Icons.perm_identity),
                  subtitle: Text(
                    "${services!['tin']}",
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                  title: const Text("TIN ID:"),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("BIR CERTIFICATE"),
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: Image.network(
                              fit: BoxFit.cover, "${services['bir']}"),
                        ),
                      ],
                    ),
                    const SizedBox(width: 18),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("DTI CERTIFICATE"),
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: Image.network(
                              fit: BoxFit.cover, "${services['dti']}"),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () {
                    _toggleEdit(services!);
                  },
                  child: const Text('Edit'),
                ),
              ],
            );
          }
        }
        return Container();
      },
    );
  }
}
