import 'dart:async';
import 'dart:convert';
import 'package:amritasreeproject/SelectOption1.dart';
import 'package:amritasreeproject/SelectOption2.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'MemberDetailsClass.dart';
import 'Dashboard.dart';
import 'selectOption.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AmritaSREE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: new Color(0xff622F74)),
      home: MyHomePage(title: 'AmritaSREE Members'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<MemberDetailsClass>>(
        future: fetchMembersDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (snapshot.hasData) {
            print("hi");
            return DetailList(Details: snapshot.data);
          }
          else
            //return Center(child: CircularProgressIndicator());
            return Center(
              child: Text(
                'Error connecting to Server!!',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 18.0),
              ),
            );
        }
      ),
    );
  }
}

class DetailList extends StatefulWidget {
  final List<MemberDetailsClass> Details;

  DetailList({this.Details});

  @override
  _DetailListState createState() => _DetailListState(Details: Details);
}

class _DetailListState extends State<DetailList> {
  final List<MemberDetailsClass> Details;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  _DetailListState({this.Details});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          color: Colors.white,
          child: Padding(
              padding: EdgeInsets.all(10),
              child: ListView(
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child:
                          Image.asset('assets/images/amma.png', height: 180.0)),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'User Name',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  Container(
                      height: 70,
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: new Color(0xff622F74),
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        ),
                        onPressed: () {
                          for (int i = 0; i < Details.length; i++) {
                            if (Details[i].Username == nameController.text) {
                              if (Details[i].Password ==
                                  passwordController.text) {

                                var url = "http://192.168.1.12:4000/getMemberID";
                                print(Details[i].MemberID);
                                http.post(url, body: {
                                  "MemberID": Details[i].MemberID.toString(),
                                });

                                if (Details[i].GroupRole.toLowerCase() == "admin")
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              SelectOption2(
                                                  MemberID: Details[i].MemberID, GroupID: Details[i].GroupID)));
                                else
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              Dashboard(
                                                  MemberID:
                                                      Details[i].MemberID)));
                              }
//                              else{
//                                Scaffold.of(context).showSnackBar(SnackBar(
//                                    duration: Duration(milliseconds: 100),
//                                    content: Text("Please enter correct password")));
//                              }
                            }
//                            else{
//                              Scaffold.of(context).showSnackBar(SnackBar(
//                                  duration: Duration(milliseconds: 100),
//                                  content: Text("Please enter a valid username and password")));
//                            }
                          }
                        },
                      )),
                ],
              ))),
    );
  }
}

Future<List<MemberDetailsClass>> fetchMembersDetails() async {
  Response response = await http.get('http://192.168.1.12:4000/');
  print(response.body);
  final parsed = json.decode(response.body);
  return parsed
      .map<MemberDetailsClass>((json) => MemberDetailsClass.fromJson(json))
      .toList();
}
