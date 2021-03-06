import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'MemberDetailsClass.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'LoanDetailsClass.dart';
import 'DepositClass.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Dashboard7 extends StatefulWidget {
  final int MemberID;

  Dashboard7({this.MemberID});
  @override
  _DashboardState createState() => _DashboardState(MemberID : MemberID);
}

enum TtsState { playing, stopped }

class _DashboardState extends State<Dashboard7> {
  final int MemberID;
  FlutterTts flutterTts;
  dynamic languages;
  String language;
  double volume = 10;
  double pitch = 1;
  double rate = .7;
  _DashboardState({this.MemberID});
  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  @override
  initState() {
    super.initState();
    initTts();
  }

  initTts() {
    flutterTts = FlutterTts();

    flutterTts.setStartHandler(() {
      setState(() {
        print("playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _speak(word) async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);
    // print(await flutterTts.getLanguages);
    flutterTts.setLanguage("ml-IN");
    // print("check");
    if (word != null) {
      if (word.isNotEmpty) {
        var result = await flutterTts.speak(word);
        if (result == 1) setState(() => ttsState = TtsState.playing);
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Material myItems(String icon, String heading, int color1) {
    return Material(
      color: Colors.black54,
      elevation: 14.0,
      shadowColor: Color(0x802196F3),
      borderRadius: BorderRadius.circular(24.0),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      // height: 20,
                      width: 220,
                      child: Text(
                        heading,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Center(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     // crossAxisAlignment: CrossAxisAlignment.end,
              //     children: <Widget>[
              //        Material(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(24.0),
              //         child: Padding(padding: const EdgeInsets.all(16.0),
              //         // child: Icon(icon,
              //         // color: Colors.black,
              //         // size: 30.0),
              //         child: Image(image: AssetImage(icon),
              //           height: 80,
              //           width: 100)
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                    child: Text(
                      'കേൾക്കു',
                      style: TextStyle(
                        fontSize: 8,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    height: 50,
                    minWidth: 30,
                    shape: CircleBorder(),
                    color: Colors.red,
                    onPressed: () {
                      _speak(heading); //Do something
                    },
                  )
                  // IconButton(icon: new Icon(Icons.audiotrack),
                  // onPressed: _speak(),
                  // iconSize: 40),
                  //  Material(
                  //   color: Colors.white,
                  //   borderRadius: BorderRadius.circular(24.0),
                  //   child: Padding(padding: const EdgeInsets.all(16.0),
                  //   child: Icon(Icons.audiotrack,
                  //   color: Colors.black,
                  //   size: 15.0,),
                  //   ),
                  // ),
                  // Container(
                  //   color: Colors.white,
                  // )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // speak( String word){
  //  flutterTts.speak(word);
  // }

  //  Future speak() async{
  //     var result = await flutterTts.speak("Hello World");
  //     if (result == 1) setState(() => ttsState = TtsState.playing);
  //  }

  //  Future stop() async{
  //    var result = await flutterTts.stop();
  //    if (result == 1) setState(() => ttsState = TtsState.stopped);
  //  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'അമൃതശ്രീ -> സംഘം വിവരങ്ങൾ',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StaggeredGridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: <Widget>[
          myItems('assets/images/nextdue.jpg', "അംഗം 1", 0xcefd622b),
          myItems('assets/images/nextdue.jpg', "അംഗം 2", 0xffed622b),
          myItems('assets/images/nextdue.jpg', "അംഗം 3", 0xffed622b),
          myItems('assets/images/nextdue.jpg', "അംഗം 4", 0xffed622b),
          myItems('assets/images/nextdue.jpg', "അംഗം 5", 0xffed622b),
          myItems('assets/images/nextdue.jpg', "അംഗം 6", 0xffed622b),
          myItems('assets/images/nextdue.jpg', "അംഗം 7", 0xffed622b),
          myItems('assets/images/nextdue.jpg', "അംഗം 8", 0xffed622b),
          myItems('assets/images/nextdue.jpg', "അംഗം 9", 0xffed622b),
          myItems('assets/images/nextdue.jpg', "അംഗം 10", 0xffed622b),
          myItems('assets/images/nextdue.jpg', "അംഗം 11", 0xffed622b),
          myItems('assets/images/nextdue.jpg', "അംഗം 12", 0xffed622b),
          // myItems('assets/images/pending payment.png',"ലോൺ അടവ് ബാക്കി തുക",0xffed622b),
          // myItems('assets/images/savings.jpg',"നിക്ഷേപം",0xffed622b),
          // myItems('assets/images/paymenthistory.png',"അടവ് വിവരങ്ങൾ ",0xffed622b),
          // myItems('assets/images/loandetails.png',"ലോൺ വിവരങ്ങൾ",0xffed622b),
          // myItems('assets/images/group.jpg',"സംഘം വിവരങ്ങൾ",0xffed622b),
          // myItems('assets/images/bell.jpg',"തിരിച്ചടവ് അറിയിപ്പ് ",0xffed622b),
        ],
        staggeredTiles: [
          StaggeredTile.extent(2, 100.0),
          StaggeredTile.extent(2, 100.0),
          StaggeredTile.extent(2, 100.0),
          StaggeredTile.extent(2, 100.0),
          StaggeredTile.extent(2, 100.0),
          StaggeredTile.extent(2, 100.0),
          StaggeredTile.extent(2, 100.0),
          StaggeredTile.extent(2, 100.0),
          StaggeredTile.extent(2, 100.0),
          StaggeredTile.extent(2, 100.0),
          StaggeredTile.extent(2, 100.0),
          StaggeredTile.extent(2, 100.0),
        ],
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

  _DetailListState({this.Details});

  bool equalsIgnoreCase(String string1, String string2) {
    return string1?.toLowerCase() == string2?.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: Details.length,
      itemBuilder: (context, index) {
        print('sdf');
        return Card(
          elevation: 3.0,
          child: ListTile(
            title: Text(
              Details[index].MemberName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            onTap: () {},
//            leading: CircleAvatar(
//              backgroundImage: ExactAssetImage('assets/amma.jpg'),
//            ),
            subtitle: Text(Details[index].PhNo.toString()),
          ),
        );
      },
    );
  }
}

Future<List<MemberDetailsClass>> fetchMembersDetails() async {
  Response response = await http.get('http://192.168.1.12:4000/');
//  Response response = await http.get('http://192.168.137.1:4000/');
  print(response.body);
  final parsed = json.decode(response.body);
  return parsed
      .map<MemberDetailsClass>((json) => MemberDetailsClass.fromJson(json))
      .toList();
}
