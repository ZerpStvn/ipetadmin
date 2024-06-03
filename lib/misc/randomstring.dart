// ignore_for_file: file_names

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

String generateRandomString() {
  const chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random();
  String result = '';

  for (int i = 0; i < 5; i++) {
    result += chars[random.nextInt(chars.length)];
  }

  return result;
}

String splitWords(String words) {
  List<String> wordList = words.split(RegExp(r'\s+'));
  String firstWord = wordList[0];
  String secondWord = wordList.skip(1).join(' ');

  return '$firstWord $secondWord';
}

Future<double> calculateRating(String documentid) async {
  double totalRating = 0;
  int reviewCount = 0;
  CollectionReference ratingsCollection = FirebaseFirestore.instance
      .collection('ratings')
      .doc(documentid)
      .collection('reviews');

  QuerySnapshot querySnapshot = await ratingsCollection.get();

  for (int i = 0; i < querySnapshot.docs.length; i++) {
    Map<String, dynamic>? documentdata =
        querySnapshot.docs[i].data() as Map<String, dynamic>?;
    double rating = documentdata!['rates'] ?? 0;
    totalRating += rating;
    reviewCount++;
  }

  double averageRating = reviewCount > 0 ? totalRating / reviewCount : 0;

  return averageRating;
}
