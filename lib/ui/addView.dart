import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lmgmt/net/flutterfire.dart';

class AddView extends StatefulWidget {
  @override
  _AddViewState createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {
  TextEditingController _titleController = TextEditingController();
  // TextEditingController _dateController = TextEditingController();
  TextEditingController _clientController = TextEditingController();
  TextEditingController _vehicleController = TextEditingController();
  TextEditingController _costController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var currentTime =
        "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    var screenSize = MediaQuery.of(context).size;
    return Material(
      color: Colors.blueGrey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: screenSize.width / 1.3,
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Title",
                labelStyle: TextStyle(color: Colors.white),
              ),
              // keyboardType: TextInputType.,
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: screenSize.width / 1.3,
            child: TextField(
              // controller: _dateController,
              enabled: false,
              decoration: InputDecoration(
                labelText: currentTime,
                labelStyle: TextStyle(color: Colors.white),
              ),
              // keyboardType: TextInputType.,
            ),
          ),
          Container(
            width: screenSize.width / 1.3,
            child: TextField(
              controller: _clientController,
              decoration: InputDecoration(
                labelText: "Client",
                labelStyle: TextStyle(color: Colors.white),
                hintText: 'New Value',
                hintStyle: TextStyle(color: Colors.white),
              ),
              // keyboardType: TextInputType.,
            ),
          ),
          Container(
            width: screenSize.width / 1.3,
            child: TextField(
              controller: _vehicleController,
              decoration: InputDecoration(
                labelText: "Vehicle",
                labelStyle: TextStyle(color: Colors.white),
                hintText: 'New Value',
                hintStyle: TextStyle(color: Colors.white),
              ),
              // keyboardType: TextInputType.,
            ),
          ),
          Container(
            width: screenSize.width / 1.3,
            child: TextField(
              controller: _costController,
              decoration: InputDecoration(
                labelText: "Cost",
                labelStyle: TextStyle(color: Colors.white),
                hintText: 'New Value',
                hintStyle: TextStyle(color: Colors.white),
              ),
              // keyboardType: TextInputType.,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 5,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.blueGrey[800],
                ),
                child: MaterialButton(
                  onPressed: () async {
                    // Pending: Call to firestore
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Go Back',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 5,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.blueGrey[800],
                ),
                child: MaterialButton(
                  onPressed: () async {
                    // Pending: Call to firestore
                    await addTicket(
                        _titleController.text,
                        _clientController.text,
                        _vehicleController.text,
                        _costController.text);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////

class ViewTicket extends StatefulWidget {
  final String documentId;

  ViewTicket(this.documentId);

  @override
  _ViewTicketState createState() => _ViewTicketState();
}

class _ViewTicketState extends State<ViewTicket> {
  TextEditingController _titleController = TextEditingController();
  // TextEditingController _dateController = TextEditingController();
  TextEditingController _clientController = TextEditingController();
  TextEditingController _vehicleController = TextEditingController();
  TextEditingController _costController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    CollectionReference ticket = FirebaseFirestore.instance...

    return Material(
      child: Container(
        color: Colors.blueGrey,
        child: FutureBuilder<DocumentSnapshot>(
          future: ticket.doc(widget.documentId).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data = snapshot.data.data();
              // return Text("Title: ${widget.documentId} ${data['Date']}");
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: screenSize.width / 1.3,
                    child: TextField(
                      enabled: false,
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: "${widget.documentId}",
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: 'New Value',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      // keyboardType: TextInputType.,
                    ),
                  ),
                  Container(
                    width: screenSize.width / 1.3,
                    child: TextField(
                      // controller: data['Date'],
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Date: ${data['Date']}',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      // keyboardType: TextInputType.,
                    ),
                  ),
                  Container(
                    width: screenSize.width / 1.3,
                    child: TextField(
                      controller: _clientController..text = '${data['Client']}',
                      decoration: InputDecoration(
                        labelText: "Client",
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: 'New Value',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      // keyboardType: TextInputType.,
                    ),
                  ),
                  Container(
                    width: screenSize.width / 1.3,
                    child: TextField(
                      controller: _vehicleController
                        ..text = '${data['Vehicle']}',
                      decoration: InputDecoration(
                        labelText: "Vehicle",
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: 'New Value',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      // keyboardType: TextInputType.,
                    ),
                  ),
                  Container(
                    width: screenSize.width / 1.3,
                    child: TextField(
                      controller: _costController..text = '${data['Cost']}',
                      decoration: InputDecoration(
                        labelText: "Cost",
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: 'New Value',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      // keyboardType: TextInputType.,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 5,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.blueGrey[800],
                        ),
                        child: MaterialButton(
                          onPressed: () async {
                            // Pending: Call to firestore
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Go Back',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 5,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.blueGrey[800],
                        ),
                        child: MaterialButton(
                          onPressed: () async {
                            // Pending: Call to firestore
                            await updateTicket(
                                widget.documentId.toString(),
                                _clientController.text,
                                _vehicleController.text,
                                _costController.text);
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Update',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }

            return Text("Loading...");
          },
        ),
      ),
    );
  }
}
