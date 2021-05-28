import 'package:amritasreeproject/selectOption.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class GrpRegistration extends StatefulWidget {

  @override
  GrpRegister createState() => GrpRegister();
}

class GrpRegister extends State<GrpRegistration> {
  bool _validate = false;
  bool visible = true;

  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String district=null;
  TextEditingController gname =TextEditingController();
  TextEditingController regno =TextEditingController();
  TextEditingController  panchayath=TextEditingController();
  TextEditingController  taluk=TextEditingController();
  TextEditingController  block=TextEditingController();
  TextEditingController  ward=TextEditingController();
  TextEditingController  gid=TextEditingController();


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
  String cluster="0";
  Future register() async{
    String url = "http://192.168.1.10:4000/grpreg";
    Map<String,String> body = {
      "GroupID":gid.text,
      "GroupName":gname.text,
      "GroupRegisterNum":regno.text,
      "district":district,
      "panchayath":panchayath.text,
      "taluk":taluk.text,
      "block":block.text,
      "ward":ward.text,
      "ClusterID":cluster
    };
    var r = await http.post(url, body: body);
    print(_district);
    if(r.statusCode == 200){
      setState(() {
      });
    }
    print(r.headers);
    return ;

  }

  Future<void> _ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
//        title: Text('Confirm Register',
//            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          content: const Text(
            'Successfully Registered',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                register();
                Navigator.push(context,MaterialPageRoute(
                  builder: (BuildContext context)=>
                      SelectOption(),
                ));//  Navigator.push(context, MaterialPageRoute(
//  builder: (BuildContext context) => MyApp1(text:null),
//  ));
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
        title: Text('Add Group'),
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
                    hintText: 'GroupId',
                    counterText: "",
                  ),
                  controller: gid,
                  maxLength: 32,
                  validator: (gid){
                    gid.isEmpty?'Please enter the  Group ID!':null;
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: _prefixIcon(Icons.add_location),
                      contentPadding: const EdgeInsets.all(16.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      hintText: 'GroupName',
                    ),
                    controller: gname,
                    validator: (gname){
                      gname.isEmpty?'Please enter the  Group Name!':null;
                    },)
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: _prefixIcon(Icons.calendar_today),
                      contentPadding: const EdgeInsets.only(top: 25.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      counterText: "",
                      hintText: 'RegNumber',
                    ),
                    controller: regno,
                    maxLength: 15,
                    keyboardType: TextInputType.phone,
                    validator: (regno){
                      regno.isEmpty?'Please enter the registration number!':null;
                    },)
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
                          hintText: 'Taluk'),
                      controller: taluk,
                    validator: (taluk){
                      taluk.isEmpty?'Please enter the taluk!':null;
                    },),
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
                        hintText: 'Ward'),
                    controller: ward,
                    validator: (ward){
                      ward.isEmpty?'Please enter the ward!':null;
                    },),
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



