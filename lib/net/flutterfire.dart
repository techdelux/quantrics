import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


Future<bool> removeTicket(String id) async {
  String uid = FirebaseAuth.instance.currentUser.uid;
  FirebaseFirestore.instance
      ...
      .delete();
  return true;
}

///////////////////////////////////////////////////////
// CollectionReference users = FirebaseFirestore.instance.collection('users');
String uid = FirebaseAuth.instance.currentUser.uid;
CollectionReference tickets = FirebaseFirestore.instance
    ...;

Future<void> addTicket(
    String id, String customer, String vehicle, String cost) {
  var now = DateTime.now();
  var currentTime =
      "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  var timestamp = currentTime;
  var expense = double.parse(cost);
  return tickets
      .doc(id)
      .set({
        'Title': id,
        'Date': timestamp,
        'Client': customer,
        'Vehicle': vehicle,
        'Cost': expense
      })
      .then((value) => print("Ticket Added"))
      .catchError((error) => print("Failed to add ticket: $error"));
}

Future<void> updateTicket(
    String id, String customer, String vehicle, String cost) {

  var expense = double.parse(cost);
  return tickets
      .doc(id)
      .update({

        'Client': customer,
        'Vehicle': vehicle,
        'Cost': expense
      })
      .then((value) => print("Ticket Updated"))
      .catchError((error) => print("Failed to update ticket: $error"));
}
