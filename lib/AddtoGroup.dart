import 'dart:convert';

import 'package:amritasreeproject/selectOption.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ATG extends StatefulWidget {

  @override
  _ATG createState() =>_ATG();
}

class _ATG extends State<ATG> {
  bool _validate = false;
  bool visible = true;

  @override
  void initState() {
    super.initState();
    getGroups();
  }

  List<String> s=[""];
  var dataJson=[];
  var datalogin;
  String groupid = null ;
  List<String> _groupid =[""];
  Future<String> getGroups()async{
    print(dataJson.isEmpty);

    String url = "http://192.168.1.10:4000/ATGget";
    print(url);

    Response response = await http.get(url,headers: {"Accept":"application/json"});
    print(response.headers);
    setState(() {
      dataJson = json.decode(response.body);
      print(dataJson);
      print(dataJson.length);
      if(dataJson!=null){
        s.add(dataJson[0]['GroupID'].toString());
        print(s);
        for(int i=1;i<dataJson.length;i++){
            s.add(dataJson[i]['GroupID'].toString());
        }
        s.removeAt(0);
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


  TextEditingController uname =TextEditingController();
  TextEditingController phno =TextEditingController();


  Future add(String num) async {
    final uri = "192.168.1.10:4000";
    final path = "/atg/"+num;
    final url= Uri.http(uri,path);

    print(url);
    Map<String, String> body = {
      "Username":uname.text,
      "Phone Number":phno.text,
      "GroupID":groupid,
    };
    var r = await http.post(url, body: body);

    if(r.statusCode == 200){
      setState(() {
      });
    }
    print(body);
    print(r.headers);
    return ;

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
                add(phno.text);
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
  Future<String> getlogin(String phno)async{
    final uri = "192.168.1.10:4000";
    final path = "/number/get/"+phno;
    final url= Uri.http(uri,path);
    print(url);

    http.Response response = await http.get(url,headers: {"Accept":"application/json"});
    print(response.headers);
    setState(() {
      datalogin = json.decode(response.body);
      print(datalogin);
    });
    return " Successful";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add To Group'),
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
                SizedBox(height:8.0,),
                TextFormField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(top: 10.0),
                    prefixIcon: _prefixIcon(Icons.person_outline),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.1),
                    hintText: 'Username',
                    counterText: "",
                  ),
                  controller: uname,
                  maxLength: 32,
                  validator: (gid){
                    gid.isEmpty?'Please enter the Username!':null;
                  },
                ),
                SizedBox(height: 20.0,),
                TextFormField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(top: 10.0),
                    prefixIcon: _prefixIcon(Icons.person_outline),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.1),
                    hintText: 'Phone Number',
                    counterText: "",
                  ),
                  controller: phno,
                  maxLength: 32,
                  validator: (gid){
                    gid.isEmpty?'Please enter the Phone Number!':null;
                  },
                ),
                SizedBox(height:8.0,),
                Container(
                  height: MediaQuery.of(context).size.height * 0.043,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                      border: Border.all()
                  ),
                  child: DropdownButton(value: groupid, items:_groupid
                      .map((value) =>
                      DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      ),).toList(),
                    onChanged: (String value) {
                      groupid = value;
                      setState(() {
                      });
                    },
                    hint: Text('Select the group'),
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
                              {getlogin(phno.text);
                              print(datalogin[0]['GroupID']);
                              if(datalogin[0]['GroupID']==1)
                                _ackAlert(context);
                              else
                                Navigator.push(context,MaterialPageRoute(
                                    builder: (BuildContext context)=>
                                        SelectOption()));
                              }
//                              else {
//                                showInSnackBar(
//                                    'Please fix the errors in red before submitting.');
//                              }
                            });;
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



