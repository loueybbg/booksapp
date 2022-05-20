// ignore: import_of_legacy_library_into_null_safe
import 'package:book_tracker/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> createUser(String displayName, BuildContext context) async {
  final userCollection = FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser!.uid;
  MUser user = MUser(displayName: displayName, uid: uid);

  userCollection.add(user.toMap());
  return;
}
