import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Registration extends StatefulWidget {
  final int GroupID;

  Registration({this.GroupID});

  @override
  Register createState() => Register(GroupID: GroupID);
}

class Register extends State<Registration> {
  bool _validate = false;
  bool visible = true;

  Widget _decideImageView() {
    if (imageFile == null) {
      return Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: Text("No Image Selected"));
    } else {
      return Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: Image.file(imageFile, width: 700.0, height: 350.0));
    }
  }

  File imageFile;
  _openGallery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Make a choice"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: () {
                      _openGallery(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                  ),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      _openCamera(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (this.mounted) super.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  final int GroupID;
  String name, age, password, address, degree, mobile;
  var aplorbpl = ["APL", "BPL"];
  var groupRole = ["Admin", "User"];
  var currentRole = "Admin";
  var currentAPLorBPL = 'APL';
  String _color = '';

  TextEditingController MemberNameController = TextEditingController();
  TextEditingController AddressController = TextEditingController();
  TextEditingController AgeController = TextEditingController();
  TextEditingController EducationalQualificationController =
      TextEditingController();
  TextEditingController PhNoController = TextEditingController();
  TextEditingController UsernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _AnswerController = TextEditingController();

  List<String> securityQuestion = [
    "What is the name of your house ?",
    "What is your mother's maiden ?",
    "Name of your pet ?",
    "Name of your village ?",
    "What is your favorite movie ?"
  ];
  var _currentSecurityQuestion = "What is the name of your house ?";

  String confirmPassword;
  var _currentAPLorBPL = ["APL", "BPL"];
  List<String> currentSecutiyQuestion = [
    "What is the name of your house ?",
    "What is your mother's maiden ?",
    "Name of your pet ?",
    "Name of your village ?",
    "What is your favorite movie ?"
  ];

  final formKey = GlobalKey<FormState>();

  Register({this.GroupID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Member'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
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
                    hintText: 'Name',
                    counterText: "",
                  ),
                  controller: MemberNameController,
                  maxLength: 32,
                  onSaved: (String val) {
                    name = val;
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
                      hintText: 'Address',
                    ),
                    controller: AddressController,
                    validator: (input) => input.contains('@!#%^&*?')
                        ? 'Not a valid address'
                        : null,
                    onSaved: (input) => address = input,
                  ),
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
                      hintText: 'Age',
                    ),
                    controller: AgeController,
                    maxLength: 3,
                    keyboardType: TextInputType.phone,
                    validator: (input) => input.length >= 3
                        ? 'Plese enter your correct age'
                        : null,
                    onSaved: (input) => age = input,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: _prefixIcon(Icons.school),
                      hintText: 'Educational Qualification',
                      contentPadding: const EdgeInsets.only(top: 25.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                    ),
                    controller: EducationalQualificationController,
                    validator: (input) =>
                        input.contains('!@#%^&*') ? 'Not a valid degree' : null,
                    onSaved: (input) => degree = input,
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
                          isEmpty: _color == '',
                          child: new DropdownButtonHideUnderline(
                            child: new DropdownButton<String>(
                              items: _currentAPLorBPL
                                  .map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(dropDownStringItem),
                                );
                              }).toList(),
                              onChanged: (String newValueSelected) {
                                setState(() {
                                  this.currentAPLorBPL = newValueSelected;
                                });
                              },
                              value: currentAPLorBPL,
                            ),
                          ),
                        );
                      },
                    ),
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
                          hintText: 'Mobile Number'),
                      controller: PhNoController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      validator: validateMobile,
                      onSaved: (String val) {
                        mobile = val;
                      }),
                ),
                Container(
                  height: 76.0,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: FormField(
                      builder: (FormFieldState state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            prefixIcon: _prefixIcon(Icons.build),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(45.0),
                                borderSide: BorderSide.none),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.1),
                          ),
                          isEmpty: _color == '',
                          child: new DropdownButtonHideUnderline(
                            child: new DropdownButton<String>(
                              items: groupRole.map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(dropDownStringItem),
                                );
                              }).toList(),
                              onChanged: (String newValueSelected) {
                                setState(() {
                                  this.currentRole = newValueSelected;
                                });
                              },
                              value: currentRole,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: _prefixIcon(Icons.account_box),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      counterText: "",
                      hintText: 'Username',
                    ),
                    controller: UsernameController,
                    maxLength: 10,
                  ),
                ),
                Container(
                  height: 76.0,
                  child: Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: TextFormField(
                          obscureText: visible,
                          //validator: validatePassword,
                          controller: _passwordController,
                          decoration: InputDecoration(
                              prefixIcon: _prefixIcon(Icons.lock),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.1),
                              counterText: "",
                              hintText: 'Password',
                              suffix: InkWell(
                                child: visible
                                    ? Icon(
                                        Icons.visibility_off,
                                        size: 18,
                                        color: Colors.orange,
                                      )
                                    : Icon(
                                        Icons.visibility,
                                        size: 18,
                                        color: Colors.orange,
                                      ),
                                onTap: () {
                                  setState(() {
                                    visible = !visible;
                                  });
                                },
                              )),
                          onSaved: (str) {
                            password = str;
                          })),
                ),
                Container(
                  height: 76.0,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: visible,
                        validator: (confirmation) {
                          return confirmation.isEmpty
                              ? 'Confirm password is required'
                              : validationEqual(
                                      confirmation, _passwordController.text)
                                  ? null
                                  : 'Password not match';
                        },
                        decoration: InputDecoration(
                            prefixIcon: _prefixIcon(Icons.lock),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.1),
                            counterText: "",
                            hintText: 'Confirm Password',
                            suffix: InkWell(
                              child: visible
                                  ? Icon(
                                      Icons.visibility_off,
                                      size: 18,
                                      color: Colors.orange,
                                    )
                                  : Icon(
                                      Icons.visibility,
                                      size: 18,
                                      color: Colors.orange,
                                    ),
                              onTap: () {
                                setState(() {
                                  visible = !visible;
                                });
                              },
                            )),
                        onSaved: (str) {
                          confirmPassword = str;
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
                            prefixIcon: _prefixIcon(Icons.security),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(45.0),
                                borderSide: BorderSide.none),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.1),
                          ),
                          isEmpty: _color == '',
                          child: new DropdownButtonHideUnderline(
                            child: new DropdownButton<String>(
                              items: currentSecutiyQuestion
                                  .map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(dropDownStringItem),
                                );
                              }).toList(),
                              onChanged: (String newValueSelected) {
                                setState(() {
                                  this._currentSecurityQuestion =
                                      newValueSelected;
                                });
                              },
                              value: _currentSecurityQuestion,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: _prefixIcon(Icons.done),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      hintText: 'Answer',
                    ),
                    controller: _AnswerController,
                  ),
                ),
//                Container(
//                  child: Center(
//                    child: Column(
//                      children: <Widget>[
//                        _decideImageView(),
//                        Padding(
//                          padding: const EdgeInsets.only(top: 20.0),
//                          child: ButtonTheme(
//                            minWidth: 30.0,
//                            height: 40.0,
//                            child: RaisedButton(
//                              color: new Color(0xff622F74),
//                              onPressed: () {
//                                _showChoiceDialog(context);
//                              },
//                              child: Text(
//                                "Select an Image",
//                                style: TextStyle(
//                                    fontSize: 15,
//                                    fontWeight: FontWeight.bold,
//                                    color: Colors.white),
//                              ),
//                            ),
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
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
                          onPressed: _submit,
                          child: Text(
                            'Sign In',
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

  void _submit() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      register();
    }
  }

  String validateMobile(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Mobile is Required";
    } else if (value.length != 10) {
      return "Mobile number must 10 digits";
    } else if (!regExp.hasMatch(value)) {
      return "Mobile Number must be digits";
    }
    return null;
  }

  String validateName(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Name is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Name must be a-z and A-Z";
    }
    return null;
  }

  String validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String validateConfirmPassword(String value) {
    if (value.isEmpty) {
      return 'Confirm password is required';
    } else if (value.length < 8) {
      return 'Confirm password must be at least 8 characters';
    }
    return null;
  }

  bool validationEqual(String currentValue, String checkValue) {
    if (currentValue == checkValue) {
      return true;
    } else {
      return false;
    }
  }

  void register() {
    print("Entered Register");
    String MemberName = MemberNameController.text;
    String Address = AddressController.text;
    String Age = AgeController.text;
    String EducationalQualification = EducationalQualificationController.text;
    String PhNo = PhNoController.text;
    String Username = UsernameController.text;
    String Password = _passwordController.text;
    String Answer = _AnswerController.text;

    var url = "http://192.168.1.10:4000/register";

    http.post(url, body: {
      "MemberName": MemberName,
      "Address": Address,
      "Age": Age,
      "EducationalQualification": EducationalQualification,
      "APLorBPL": currentAPLorBPL,
      "PhNo": PhNo,
      "GroupRole": currentRole,
      "GroupID": GroupID.toString(),
      "Username": Username,
      "Password": Password,
      "SecurityQuestion": _currentSecurityQuestion,
      "Answer": Answer
    });

    newUserAdded(context);
  }
}
Future<bool> newUserAdded(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          content: new Text('A new member has been created'),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      });
}



