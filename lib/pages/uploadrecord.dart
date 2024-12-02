import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Uploadrecords extends StatefulWidget {
  const Uploadrecords({super.key});

  @override
  State<Uploadrecords> createState() => _UploadrecordsState();
}

class _UploadrecordsState extends State<Uploadrecords> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _uploadFile() async {
    try {
      // Use FilePicker to select a file
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        String userId = _auth.currentUser!.uid;
        String fileName = result.files.single.name;

        // Handle file bytes (for web support)
        Uint8List? fileBytes = result.files.single.bytes;

        if (fileBytes != null) {
          // Upload file bytes to Firebase Storage
          String filePath = 'uploads/$userId/$fileName';
          await _storage.ref(filePath).putData(fileBytes);

          // Get download URL
          String downloadUrl = await _storage.ref(filePath).getDownloadURL();

          // Save metadata to Firestore
          await _firestore
              .collection('user_files')
              .doc(_auth.currentUser!.uid)
              .collection('upload')
              .add({
            'userId': userId,
            'fileName': fileName,
            'filePath': filePath,
            'downloadUrl': downloadUrl,
            'timestamp': FieldValue.serverTimestamp(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File uploaded successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to read file data.')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading file: $e')),
      );
    }
  }

  Future<void> _deleteFile(String fileId, String filePath) async {
    try {
      // Delete file from Firebase Storage
      await _storage.ref(filePath).delete();

      // Remove metadata from Firestore
      await _firestore.collection('user_files').doc(fileId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: _uploadFile,
            child: const Text('Upload File'),
          ),
          const SizedBox(height: 20),
          StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('user_files')
                .doc(_auth.currentUser!.uid)
                .collection('upload')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No files uploaded yet.'));
              }

              final files = snapshot.data!.docs;

              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('File Name')),
                    DataColumn(label: Text("Uploaded")),
                    DataColumn(label: Text("Path")),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: files.map((file) {
                    final data = file.data() as Map<String, dynamic>;
                    return DataRow(cells: [
                      DataCell(Text(data['fileName'] ?? 'Unknown')),
                      DataCell(Text(
                        data['filePath'] ?? 'Unknown',
                        overflow: TextOverflow.ellipsis,
                      )),
                      DataCell(
                        Text(
                          data['timestamp'] != null
                              ? DateFormat('MMMM d, y h:mm a').format(
                                  (data['timestamp'] as Timestamp)
                                      .toDate(), // Convert Firestore Timestamp to DateTime
                                )
                              : 'Unknown',
                        ),
                      ),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.download),
                            onPressed: () async {
                              String url = data['downloadUrl'];
                              // Handle file download (e.g., open in browser)
                              await launchUrl(Uri.parse(url));
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                _deleteFile(file.id, data['filePath']),
                          ),
                        ],
                      )),
                    ]);
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
