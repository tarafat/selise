// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../../constants/app_constants.dart';

class FireBaseHelper {
  CollectionReference comments =
      FirebaseFirestore.instance.collection('comments');
  final storage = GetStorage();

  Future<void> addComment(String comment, String vid) {
    // Calling the collection to add a new user
    return comments
        //adding to firebase collection
        .add({
          //Data added in the form of a dictionary into the document.
          'name': storage.read(AppConstants.kKeyUserName),
          'comment': comment,
          'imageUrl': storage.read(AppConstants.kKeyPhotoUrl),
          'videoID': vid,
        })
        .then((value) => print("Student data Added"))
        .catchError((error) => print("Student couldn't be added."));
  }

  Stream<QuerySnapshot> getCommetsStreamSnapshots(
      BuildContext context, String vid) async* {
    yield* FirebaseFirestore.instance
        .collection('comments')
        .where("videoID", isEqualTo: vid)
        .snapshots();
  }
}
