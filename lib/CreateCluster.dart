import 'dart:convert';

import 'package:amritasreeproject/selectOption.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:http/http.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CRC extends StatefulWidget {

  @override
  _CRC createState() => _CRC();
}

class _CRC extends State<CRC> {
  bool _validate = false;
  bool visible = true;

  @override
  void initState() {
    super.initState();
    getGroups();
  }
static List<String> s=[""];
  var dataJson=[];
  var datalogin;
  String groupid1 = null;
  String groupid2 = null;
  String groupid3 = null;
  String groupid4 = null;
  String groupid5 = null;
  List<String> _groupid = [""] ;


  Future<String> getGroups()async{
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
        s.add(dataJson[0]['GroupID'].toString());
        print(s);
        for(int i=1;i<dataJson.length;i++){
          print(dataJson[i]['GroupID']);
          if(dataJson[i]['ClusterID']==0){
            s.add(dataJson[i]['GroupID'].toString());
          }
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

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
  String district=null;
  TextEditingController  panchayath=TextEditingController();
  TextEditingController  taluk=TextEditingController();
  TextEditingController  block=TextEditingController();


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
  TextEditingController clustername = TextEditingController();


  Future addCluster() async {
    final uri = "192.168.1.10:4000";
    final path = "/cr";
    final url= Uri.http(uri,path);

    print(url);
    Map<String, String> body = {
      "ClusterName":clustername.text,
      "District": district,
      "Panchayath": panchayath.text,
      "Block":block.text,
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

  Future getClusterid(String clustername) async {
    final uri = "192.168.1.10:4000";
    final path = "/getclusterid/"+clustername;
    final url= Uri.http(uri,path);

    print(url);
    Response response = await http.get(url,headers: {"Accept":"application/json"});
    var cid = [];
    cid=json.decode(response.body);
    print("cid:"+cid[0]['ClusterID'].toString());
    return cid[0]['ClusterID'].toString();
  }

  Future add(String groupid) async {
    final uri = "192.168.1.10:4000";
    final path = "/cr/"+groupid;
    final url= Uri.http(uri,path);

    print(url);
    print(clustername.text);
    String clusterid= await getClusterid(clustername.text);
    print("Returned:"+ clusterid);
    Map<String, String> body = {
      "ClusterID":clusterid,
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
  int flag= 0;
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
                print(flag);
                    if(flag==0) {
                      if (groupid1 != groupid2 && groupid1 != groupid3 &&
                          groupid1 != groupid4 && groupid1 != groupid5 &&
                          groupid2 != groupid3 && groupid2 != groupid4 &&
                          groupid2 != groupid5 && groupid3 != groupid4 &&
                          groupid3 != groupid5 && groupid4 != groupid5) {
                        add(groupid1);
                        add(groupid2);
                        add(groupid3);
                        add(groupid4);
                        add(groupid5);
                      }
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

  Future<String> getClusterID(String groupid)async{
    final uri = "192.168.1.10:4000";
    final path = "/cr/"+groupid;
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
        title: Text('Add Cluster'),
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
                TextFormField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(top: 10.0),
                    prefixIcon: _prefixIcon(Icons.person_outline),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.1),
                    hintText: 'Cluster Name',
                    counterText: "",
                  ),
                  controller: clustername,
                  maxLength: 32,
                  validator: (gid){
                    gid.isEmpty?'Please enter the  Group ID!':null;
                  },
                ),
                Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: _prefixIcon(Icons.location_on),
                        hintText: 'Panchayath',
                        contentPadding: const EdgeInsets.only(top: 25.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.1),
                      ),
                      controller: panchayath,
                      validator: (panchayath){
                        panchayath.isEmpty?'Please enter panchayath/muncipality! ':null;
                      },)
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
                              value: district, items: _district
                                .map((value) =>
                                DropdownMenuItem(
                                  child: Text(value),
                                  value: value,
                                ),).toList(),
                              onChanged: (String value) {
                                district = value;
                                setState(() {});
                              },
                              hint: Text('Select the district'),
                            ),
                          );
                        }),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: _prefixIcon(Icons.phone),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.1),
                        counterText: "",
                        hintText: 'Block'),
                    controller: block,
                    validator: (block){
                      block.isEmpty?'Please enter the block!':null;
                    },),
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
                      getClusterID(groupid1);
                      print(datalogin[0]['ClusterID']);
                      if(datalogin[0]['ClusterID']!=0)
                        flag++;
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
                      getClusterID(groupid2);
                      print(datalogin[0]['ClusterID']);
                      if(datalogin[0]['ClusterID']!=0)
                        flag++;
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
                      getClusterID(groupid3);
                      print(datalogin[0]['ClusterID']);
                      if(datalogin[0]['ClusterID']!=0)
                        flag++;
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
                      getClusterID(groupid4);
                      print(datalogin[0]['ClusterID']);
                      if(datalogin[0]['ClusterID']!=0)
                        flag++;
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
                      getClusterID(groupid5);
                      print(flag);
                      print(datalogin[0]['ClusterID']);
                      if(datalogin[0]['ClusterID']!=0)
                        flag++;
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
                                addCluster();
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



