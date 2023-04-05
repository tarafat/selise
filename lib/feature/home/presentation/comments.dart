// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../data/firebase_crud.dart';

class ExpenseList extends StatelessWidget {
  final String vid;
  ExpenseList(this.vid);

  FireBaseHelper helper = FireBaseHelper();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: helper.getCommetsStreamSnapshots(context, vid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data!.size == 0) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("No comments Yet"),
            );
          }

          return ListView(children: getComments(snapshot));
        });
  }

  getComments(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs
        .map((doc) => ListTile(
            leading: Image.network(doc["imageUrl"]),
            title: Text(doc["name"]),
            subtitle: Text(doc["comment"].toString())))
        .toList();
  }
}
