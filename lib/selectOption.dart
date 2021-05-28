import 'package:amritasreeproject/AddtoGroup.dart';
import 'package:amritasreeproject/CreateGroup.dart';
import 'package:flutter/material.dart';
import 'Dashboard.dart';
import 'registration.dart';
import 'Cluster Functions.dart';
import 'list.dart';
import 'Group Functions.dart';

class SelectOption extends StatelessWidget {
  final int MemberID,GroupID;

  SelectOption({this.MemberID, this.GroupID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AmritaSREE'),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/amma.png',
                  height: 150.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonTheme(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    height: 60.0,
                    minWidth: 270.0,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CF()));
                      },
                      child: Text(
                        "Cluster Functions",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      color: new Color(0xff622F74),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonTheme(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    height: 60.0,
                    minWidth: 270.0,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GF()));
                      },
                      child: Text(
                        "Group Functions",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      color: new Color(0xff622F74),
                    ),
                  ),
                ),
                //
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: ButtonTheme(
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(40),
                //     ),
                //     height: 60.0,
                //     minWidth: 270.0,
                //     child: RaisedButton(
                //       onPressed: () {
                //         Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => Registration(GroupID :GroupID)));
                //       },
                //       child: Text(
                //         "Add members",
                //         style: TextStyle(
                //             fontSize: 25,
                //             fontWeight: FontWeight.bold,
                //             color: Colors.white),
                //       ),
                //       color: new Color(0xff622F74),
                //     ),
                //   ),
                // ),
                /*Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonTheme(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    height: 60.0,
                    minWidth: 270.0,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListingDetails()));
                      },
                      child: Text(
                        "Group Info",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      color: new Color(0xff622F74),
                    ),
                  ),
                ),*/
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonTheme(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    height: 60.0,
                    minWidth: 270.0,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Dashboard(MemberID: MemberID)));
                      },
                      child: Text(
                        "Home",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      color: new Color(0xff622F74),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
