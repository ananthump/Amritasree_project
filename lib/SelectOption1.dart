import 'package:flutter/material.dart';

class SelectOption1 extends StatefulWidget {
  final int MemberID,GroupID;

  SelectOption1({this.MemberID, this.GroupID});

  @override
  _SelectOption1State createState() => _SelectOption1State();
}

class _SelectOption1State extends State<SelectOption1 > {


  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
//    var w = MediaQuery.of(context).size.width;

    return Scaffold(
//        backgroundColor:Colors.blue[300],
        backgroundColor:Color.fromARGB(255,70, 94, 116),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(

                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.only(top: h/50, bottom: h/90),
                          width: MediaQuery.of(context).size.width / 1.05,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black54,
                                        blurRadius: 10.0, // soften the shadow
                                        spreadRadius: 1.0, //extend the shadow
                                        offset: Offset(
                                          1.0, // Move to right 10  horizontally
                                          1.0, // Move to bottom 10 Vertically
                                        ),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(20.0),
                                    image: DecorationImage(
                                        image: AssetImage('assets/images/transaction.jpg'),
                                        fit: BoxFit.fill)),
                              ),

                              Padding(
                                padding:
                                EdgeInsets.only(left: 8.0, top: h/8),
                                child: Text(
                                  "Transactions",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Katibeh"),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Container(

                          padding: EdgeInsets.only(top: h/65, bottom: h/50),
                          width: MediaQuery.of(context).size.width / 1.05,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black54,
                                        blurRadius: 10.0, // soften the shadow
                                        spreadRadius: 1.0, //extend the shadow
                                        offset: Offset(
                                          1.0, // Move to right 10  horizontally
                                          1.0, // Move to bottom 10 Vertically
                                        ),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(20.0),
                                    image: DecorationImage(
                                        image: AssetImage('assets/images/groups.jpg'),
                                        fit: BoxFit.fill)),
                              ),

                              Padding(
                                padding:
                                EdgeInsets.only(left: 8.0, top:h/9),
                                child: Text(
                                  "Groups",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Katibeh"),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: (){

                        },
                        child: Container(
                          padding:EdgeInsets.only(top: h/130, bottom: h/40),
                          width: MediaQuery.of(context).size.width / 1.05,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black54,
                                        blurRadius: 10.0, // soften the shadow
                                        spreadRadius: 1.0, //extend the shadow
                                        offset: Offset(
                                          1.0, // Move to right 10  horizontally
                                          1.0, // Move to bottom 10 Vertically
                                        ),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(20.0),
                                    image:DecorationImage(
                                        image: AssetImage('assets/images/cluster.jpg'),
                                        fit: BoxFit.fill
                                    )
                                ),
                              ),

                              Padding(
                                padding:EdgeInsets.only(left: 8.0, top:h/8),
                                child: Text("Clusters",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,fontFamily:"Katibeh", ),),
                              )
                            ],
                          ),

                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
