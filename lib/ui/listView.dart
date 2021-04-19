import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lmgmt/net/flutterfire.dart';
import 'package:lmgmt/ui/addView.dart';
import 'package:lmgmt/widgets/bottom_bar.dart';
import 'package:lmgmt/widgets/explore_drawer.dart';
import 'package:lmgmt/widgets/responsive.dart';
import 'package:lmgmt/widgets/topBar.dart';
import 'package:lmgmt/widgets/web_scrollbar.dart';

class CallInterface extends StatefulWidget {
  @override
  _CallInterfaceState createState() => _CallInterfaceState();
}

class _CallInterfaceState extends State<CallInterface> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget.isSmallScreen(context)
        ? MobileInterface()
        : Interface();
  }
}

class Interface extends StatefulWidget {
  @override
  _InterfaceState createState() => _InterfaceState();
}

class _InterfaceState extends State<Interface> {
  ScrollController _scrollController;
  double _scrollPosition = 0;
  double _opacity = 0;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  CollectionReference tickets = FirebaseFirestore.instance...
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    _opacity = _scrollPosition < screenSize.height * 0.40
        // ? _scrollPosition / (screenSize.height * 0.40)
        // : 1;
        ? _scrollPosition / (screenSize.height * 0.40)
        : 1;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      // extendBodyBehindAppBar: true,
      // backgroundColor: Colors.blueGrey[800],
      appBar: ResponsiveWidget.isSmallScreen(context)
          ? AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              // backgroundColor: Colors.black,
              elevation: 0,
              centerTitle: true,
              title: (Text(
                'QUANTRICS',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Anton',
                  letterSpacing: 1,
                  fontSize: 20,
                ),
              )),
            )
          : PreferredSize(
              preferredSize: Size(screenSize.width, 1000),
              child: TopBar(_opacity),
            ),
      drawer: ExploreDrawer(),
      body: WebScrollbar(
        color: Colors.grey[800],
        backgroundColor: Colors.transparent,
        width: 10,
        heightFraction: 0.5,
        controller: _scrollController,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: screenSize.height / 45),
              Column(
                children: [
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: screenSize.width / 5),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: tickets.snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: screenSize.height / 3),
                            child: Center(
                              child: Text(
                                "Loading...",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30),
                              ),
                            ),
                          );
                        }
                        // var index = snapshot.data.docs.length;

                        return Stack(
                          children: [
                            SizedBox(height: screenSize.height),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                primary: true,
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot tickets =
                                      snapshot.data.docs[index];

                                  return Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.5),
                                        color: Colors.blueGrey,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // SizedBox(width: screenSize.width / 12),
                                          Container(
                                            width: screenSize.width / 9,
                                            child: Text(
                                              "${tickets.id}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            ),
                                          ),
                                          // SizedBox(width: screenSize.width / 15),
                                          Container(
                                            width: screenSize.width / 12,
                                            child: Text(
                                                "${tickets.data()['Date']}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10)),
                                          ),
                                          // SizedBox(width: screenSize.width / 9),

                                          ConstrainedBox(
                                            constraints:
                                                BoxConstraints.tightFor(
                                                    width: screenSize.width / 9,
                                                    height: 35),
                                            child: OutlinedButton(
                                              child: Text(
                                                'View',
                                                style: TextStyle(fontSize: 10),
                                              ),
                                              style: OutlinedButton.styleFrom(
                                                primary: Colors.white,
                                                backgroundColor:
                                                    Colors.blueGrey[800],
                                                side: BorderSide(
                                                    color: Colors.blue,
                                                    width: 1.5),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewTicket(tickets.id),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          // SizedBox(width: screenSize.width / 9),
                                          ConstrainedBox(
                                            constraints:
                                                BoxConstraints.tightFor(
                                                    width: screenSize.width / 9,
                                                    height: 35),
                                            child: OutlinedButton(
                                              child: Text(
                                                'Remove',
                                                style: TextStyle(fontSize: 10),
                                              ),
                                              style: OutlinedButton.styleFrom(
                                                primary: Colors.white,
                                                backgroundColor:
                                                    Colors.blueGrey[800],
                                                side: BorderSide(
                                                    color: Colors.red,
                                                    width: 1.5),
                                              ),
                                              onPressed: () async {
                                                await removeTicket(tickets.id);
                                              },
                                              // onPressed: () {},
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        );
                      },
                    ),
                    // SizedBox(height: 70),
                  ),
                ],
              ),
              SizedBox(height: screenSize.height / 8),
              SizedBox(height: 25),
              BottomBar(),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddView(),
            ),
          );
        },
        child: Text(
          'Add',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}

//////////////////////////////////////////////
//////////////////////////////////////////////
//////////////////////////////////////////////
//////////////////////////////////////////////
//////////////////////////////////////////////
//////////////////////////////////////////////
//////////////////////////////////////////////
//////////////////////////////////////////////
//////////////////////////////////////////////
//////////////////////////////////////////////
//////////////////////////////////////////////
//////////////////////////////////////////////
//////////////////////////////////////////////
//////////////////////////////////////////////

class MobileInterface extends StatefulWidget {
  @override
  _MobileInterfaceState createState() => _MobileInterfaceState();
}

class _MobileInterfaceState extends State<MobileInterface> {
  ScrollController _scrollController;
  double _scrollPosition = 0;
  double _opacity = 0;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  CollectionReference tickets = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('Tickets');
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    _opacity = _scrollPosition < screenSize.height * 0.40
        // ? _scrollPosition / (screenSize.height * 0.40)
        // : 1;
        ? _scrollPosition / (screenSize.height * 0.40)
        : 1;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      // extendBodyBehindAppBar: true,
      // backgroundColor: Colors.blueGrey[800],
      appBar: ResponsiveWidget.isSmallScreen(context)
          ? AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              // backgroundColor: Colors.black,
              elevation: 0,
              centerTitle: true,
              title: (Text(
                'QUANTRICS',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Anton',
                  letterSpacing: 1,
                  fontSize: 20,
                ),
              )),
            )
          : PreferredSize(
              preferredSize: Size(screenSize.width, 1000),
              child: TopBar(_opacity),
            ),
      drawer: ExploreDrawer(),
      body: WebScrollbar(
        color: Colors.grey[800],
        backgroundColor: Colors.transparent,
        width: 10,
        heightFraction: 0.5,
        controller: _scrollController,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: screenSize.height / 45),
              Column(
                children: [
                  Container(
                    // margin:
                    //     EdgeInsets.symmetric(horizontal: screenSize.width / 5),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: tickets.snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: screenSize.height / 3),
                            child: Center(
                              child: Text(
                                "Loading...",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30),
                              ),
                            ),
                          );
                        }
                        // var index = snapshot.data.docs.length;

                        return Stack(
                          children: [
                            SizedBox(height: screenSize.height),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                primary: true,
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot tickets =
                                      snapshot.data.docs[index];

                                  return Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.5),
                                        color: Colors.blueGrey,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // SizedBox(width: screenSize.width / 12),
                                          Container(
                                            width: screenSize.width / 5,
                                            child: Text(
                                              "${tickets.id}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11),
                                            ),
                                          ),
                                          SizedBox(
                                              width: screenSize.width / 15),
                                          Container(
                                            width: screenSize.width / 6,
                                            child: Text(
                                                "${tickets.data()['Date']}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10)),
                                          ),
                                          SizedBox(width: screenSize.width / 9),

                                          ConstrainedBox(
                                            constraints:
                                                BoxConstraints.tightFor(
                                                    width: screenSize.width / 6,
                                                    height: 35),
                                            child: OutlinedButton(
                                              child: Text(
                                                'View',
                                                style: TextStyle(fontSize: 10),
                                              ),
                                              style: OutlinedButton.styleFrom(
                                                primary: Colors.white,
                                                backgroundColor:
                                                    Colors.blueGrey[800],
                                                side: BorderSide(
                                                    color: Colors.blue,
                                                    width: 1.5),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewTicket(tickets.id),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          // SizedBox(width: screenSize.width / 9),
                                          ConstrainedBox(
                                            constraints:
                                                BoxConstraints.tightFor(
                                                    width: screenSize.width / 6,
                                                    height: 35),
                                            child: OutlinedButton(
                                              child: Text(
                                                'Remove',
                                                style: TextStyle(fontSize: 10),
                                              ),
                                              style: OutlinedButton.styleFrom(
                                                primary: Colors.white,
                                                backgroundColor:
                                                    Colors.blueGrey[800],
                                                side: BorderSide(
                                                    color: Colors.red,
                                                    width: 1.5),
                                              ),
                                              onPressed: () async {
                                                await removeTicket(tickets.id);
                                              },
                                              // onPressed: () {},
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        );
                      },
                    ),
                    // SizedBox(height: 70),
                  ),
                ],
              ),
              SizedBox(height: screenSize.height / 8),
              SizedBox(height: 25),
              BottomBar(),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddView(),
            ),
          );
        },
        child: Text(
          'Add',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}
