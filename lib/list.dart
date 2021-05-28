import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'MemberDetailsClass.dart';

class ListingDetails extends StatefulWidget {
  @override
  _ListingDetailsState createState() => _ListingDetailsState();
}

class _ListingDetailsState extends State<ListingDetails> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AmritaSREE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: new Color(0xff622F74)),
      home: MyHomePage(title: 'അമൃതശ്രീ -> സംഘം വിവരങ്ങൾ'),
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

  Future<Null> refreshList() async {
    await Future.delayed(Duration(milliseconds: 900));
    setState(() {
//      DetailList;
      fetchMembersDetails();
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        child: FutureBuilder<List<MemberDetailsClass>>(
          future: fetchMembersDetails(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            if (snapshot.hasData) {
              print("hi");
              return DetailList(Details: snapshot.data);
            } else
              return Center(child: CircularProgressIndicator());
          },
        ),
        onRefresh: refreshList,
      ),
//      floatingActionButton: FloatingActionButton.extended(
//        onPressed: () {
//          Navigator.push(context,
//              MaterialPageRoute(builder: (context) => registerMembers()));
////        Navigator.push(context, MaterialPageRoute(builder: (context) => TextFormFieldDemo()));
//        },
//        icon: Icon(Icons.add),
//        label: Text("Register"),
//      ),
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

  _DetailListState({this.Details});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: Details.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.black54,
          elevation: 5.0,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: ListTile(
              title: Text(
                Details[index].MemberName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0,color: Colors.white),
              ),
              onTap: () {
//              Navigator.push(context,
//                  MaterialPageRoute(builder: (context) => View_User_Details()));
              },
//            leading: CircleAvatar(
//              backgroundImage: ExactAssetImage('assets/amma.jpg'),
//            ),
//            subtitle: Text(Details[index].PhNo),
//            trailing: IconButton(
//                icon: Icon(Icons.delete, color: Colors.redAccent),
//                onPressed: () {
//                  deleteDialog(context).then((value) {
//                    if (value) {
//                      var url =
//                          "http://10.113.4.60:4000/delete";
//                      print(Details[index].serial_no);
//                      http.post(url, body: {
//                        "serial_no": Details[index].serial_no,
//                      });
//                      Scaffold.of(context).showSnackBar(SnackBar(
//                          duration: Duration(milliseconds: 2000),
//                          content: Text(
//                              'Delete ${Details[index].name} from database')));
//                      setState(() {
//                        Details.removeAt(index);
//                      });
//                    }
//                  });
//                }),
            ),
          )
        );
      },
    );
  }
}

Future<List<MemberDetailsClass>> fetchMembersDetails() async {
  Response response = await http.get('http://192.168.1.10:4000/');
  print(response.body);
  final parsed = json.decode(response.body);
  return parsed.map<MemberDetailsClass>((json) => MemberDetailsClass.fromJson(json)).toList();
}


