import 'dart:convert';

import 'package:amritasreeproject/selectOption.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:http/http.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MC extends StatefulWidget {

  @override
  _MC createState() => _MC();
}

class _MC extends State<MC> {
  bool _validate = false;
  bool visible = true;

  @override
  void initState() {
    super.initState();
  }
  static List<String> s=[""];
  static List<String> s1=[""];

  var dataJson=[];
  var dataJson1=[];
  int c=0;
  var datalogin;
  String groupid1 = null;
  String groupid2 = null;
  String groupid3 = null;
  String groupid4 = null;
  String groupid5 = null;
  String clusterid=null;
  String clusterid1=null;

  List<String> _groupid = [""] ;
  List<String> _clusterid = [""] ;


  Future<String> getGroups(String clusterid1)async{
    print(dataJson.isEmpty);

    String url = "http://192.168.1.10:4000/ATGget";
    print(url);

    Response response = await http.get(url,headers: {"Accept":"application/json"});
    print(response.headers);
    setState(() {
      s=[""];
      dataJson = json.decode(response.body);
      print(dataJson);
      //print(dataJson.length);
      if(dataJson!=null){
        s.removeAt(0);
        print(s);
        for(int i=0;i<dataJson.length;i++){
          print(dataJson[i]['GroupID']);
          if(dataJson[i]['ClusterID']==int.parse(clusterid1)){
            s.add(dataJson[i]['GroupID'].toString());
          }
        }
        s.cast<String>();
        print(s);
        _groupid=s;
        print(_groupid);
      }
    });
    return " Successful";
  }


  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
  String district=null;
  String district1=null;

  final List<String> _district = [
    'Alappuzha',
    'Ernakulam',
    'Idukki',
    'Kannur',
    'Kasargod',
    'Kollam',
    'Kottayam',
    'Kozhikode',
    'Malappuram',
    'Palakkad',
    'Pathanamthitta',
    'Thiruvananthapuram',
    'Thrissur',
    'Wayanad'
  ];

  

   Future<String> getClusters(String district)async{
    print(dataJson1.isEmpty);
    s1=[""];
    String url = "http://192.168.1.10:4000/getcluster/"+district;
    print(url);

    Response response = await http.get(url,headers: {"Accept":"application/json"});
    print(response.headers);
    setState(() {
      dataJson1 = json.decode(response.body);
      print(dataJson1);
      //print(dataJson.length);
      if(dataJson1!=null){
        s1.removeAt(0);
        for(int i=0;i<dataJson1.length;i++){
          if(dataJson1[i]['ClusterID']!=0){
            s1.add(dataJson1[i]['ClusterID'].toString());
          }
        }s1.cast<String>();
        print(s1);
        _clusterid=s1;
        print(_clusterid);
      }
    });
    return " Successful";
  }

Future add(String groupid) async {
  final uri = "192.168.1.10:4000";
  final path = "/cr/" + groupid;
  final url = Uri.http(uri, path);

  print(url);
  print("Clusterid:" + clusterid);
  Map<String, String> body = {
    "district": district,
    "ClusterID": clusterid,
  };
  var r = await http.post(url, body: body);

  if (r.statusCode == 200) {
    setState(() {});
  }
  print(body);
  print(r.headers);
  return;
}
  Future<void> _ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            'Successfully Added',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                  print(_groupid.length);
                  print(c);
                  if(_groupid.length-c>=5) {
                    add(groupid1);
                    add(groupid2);
                    add(groupid3);
                    add(groupid4);
                    add(groupid5);
                  }

                Navigator.push(context,MaterialPageRoute(
                  builder: (BuildContext context)=>
                      SelectOption(),
                ));
              },
            ),
          ],
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Migrate Cluster'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            autovalidate: _validate,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                Container(
                  height: 76.0,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: FormField(
                        builder: (FormFieldState state) {
                          return InputDecorator(
                            decoration: InputDecoration(
                              prefixIcon: _prefixIcon(Icons.satellite),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(45.0),
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.1),
                            ),
                            child: DropdownButton(
                              value: district, items: _district
                                .map((value) =>
                                DropdownMenuItem(
                                  child: Text(value),
                                  value: value,
                                ),).toList(),
                              onChanged: (String value) {
                                district = value;
                                setState(() {
                                getClusters(district);

                                });
                              },
                              hint: Text('Select the new district'),
                            ),
                          );
                        }),
                  ),
                ),
                Container(
                  height: 76.0,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: FormField(
                        builder: (FormFieldState state) {
                          return InputDecorator(
                            decoration: InputDecoration(
                              prefixIcon: _prefixIcon(Icons.satellite),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(45.0),
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.1),
                            ),
                            child: DropdownButton(
                              value: clusterid, items: _clusterid
                                .map((value) =>
                                DropdownMenuItem(
                                  child: Text(value),
                                  value: value,
                                ),).toList(),
                              onChanged: (String value) {
                                clusterid = value;
                                setState(() {
                                });
                              },
                              hint: Text('Select the new cluster'),
                            ),
                          );
                        }),
                  ),
                ),
                Container(
                  height: 76.0,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: FormField(
                        builder: (FormFieldState state) {
                          return InputDecorator(
                            decoration: InputDecoration(
                              prefixIcon: _prefixIcon(Icons.satellite),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(45.0),
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.1),
                            ),
                            child: DropdownButton(
                              value: district1, items: _district
                                .map((value) =>
                                DropdownMenuItem(
                                  child: Text(value),
                                  value: value,
                                ),).toList(),
                              onChanged: (String value) {
                                district1 = value;
                                setState(() {
                                  getClusters(district1);

                                });
                              },
                              hint: Text('Select the old district'),
                            ),
                          );
                        }),
                  ),
                ),
                Container(
                  height: 76.0,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: FormField(
                        builder: (FormFieldState state) {
                          return InputDecorator(
                            decoration: InputDecoration(
                              prefixIcon: _prefixIcon(Icons.satellite),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(45.0),
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.1),
                            ),
                            child: DropdownButton(
                              value: clusterid1, items: _clusterid
                                .map((value) =>
                                DropdownMenuItem(
                                  child: Text(value),
                                  value: value,
                                ),).toList(),
                              onChanged: (String value) {
                                clusterid1 = value;
                                setState(() {
                                  getGroups(clusterid1);
                                });
                              },
                              hint: Text('Select the old cluster'),
                            ),
                          );
                        }),
                  ),
                ),
                SizedBox(height: 7,),
                Container(
                  height: MediaQuery.of(context).size.height * 0.043,
                  width: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                      border: Border.all()
                  ),
                  child: DropdownButton(value: groupid1, items:_groupid
                      .map((value) =>
                      DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      ),).toList(),
                    onChanged: (String value) {
                      groupid1 = value;
                      setState(() {
                        if(groupid1!=null)
                          c++;
                      });
                    },
                    hint: Text('Select the first group'),
                  ),
                ),
                SizedBox(height: 7,),
                Container(
                  height: MediaQuery.of(context).size.height * 0.043,
                  width: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                      border: Border.all()
                  ),
                  child: DropdownButton(value: groupid2, items:_groupid
                      .map((value) =>
                      DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      ),).toList(),
                    onChanged: (String value) {
                      groupid2 = value;
                      setState(() {
                        if(groupid2!=null)
                          c++;
                      });
                    },
                    hint: Text('Select the second group'),
                  ),
                ),
                SizedBox(height: 7,),
                Container(
                  height: MediaQuery.of(context).size.height * 0.043,
                  width: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                      border: Border.all()
                  ),
                  child: DropdownButton(value: groupid3, items:_groupid
                      .map((value) =>
                      DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      ),).toList(),
                    onChanged: (String value) {
                      groupid3 = value;
                      setState(() {
                        if(groupid3!=null)
                          c++;
                      });
                    },
                    hint: Text('Select the third group'),
                  ),
                ),
                SizedBox(height: 7,),
                Container(
                  height: MediaQuery.of(context).size.height * 0.043,
                  width: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                      border: Border.all()
                  ),
                  child: DropdownButton(value: groupid4, items:_groupid
                      .map((value) =>
                      DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      ),).toList(),
                    onChanged: (String value) {
                      groupid4 = value;
                      setState(() {
                        if(groupid4!=null)
                          c++;
                      });
                    },
                    hint: Text('Select the fourth group'),
                  ),
                ),
                SizedBox(height: 7,),
                Container(
                  height: MediaQuery.of(context).size.height * 0.043,
                  width: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                      border: Border.all()
                  ),
                  child: DropdownButton(value: groupid5, items:_groupid
                      .map((value) =>
                      DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      ),).toList(),
                    onChanged: (String value) {
                      groupid5 = value;
                      setState(() {
                        if(groupid5!=null)
                          c++;
                      });
                    },
                    hint: Text('Select the fifth group'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: ButtonTheme(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        height: 50.0,
                        minWidth: 150.0,
                        child: RaisedButton(
                          color: new Color(0xff622F74),
                          onPressed: (){
                            setState(() {
                              if(_formKey.currentState.validate())
                              {
                                _ackAlert(context);
                              }

                            });
                          },
                          child: Text(
                            'Add',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _prefixIcon(IconData iconData) {
    return Container(
        padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
        margin: const EdgeInsets.only(right: 8.0),
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                bottomRight: Radius.circular(10.0))),
        child: Icon(
          iconData,
          size: 20,
          color: Colors.grey,
        ));
  }

}



